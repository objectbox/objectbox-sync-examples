# Mesh Sync interop test: macOS app <-> Android emulator

Re-runnable setup for testing ObjectBox Mesh Sync (peer-to-peer over Google Nearby Connections) between the
Swift example app running on a Mac and the Kotlin example app running on an Android emulator hosted on a
Linux machine. No Sync Server is involved: both apps keep an unreachable server URL, so any object that
shows up on the other side came in over the mesh.

Both apps use the same mesh ID (`io.objectbox.example.sync.tasks`, see `ObjectBox.kt` and `TaskStore.swift`)
and the same data model (`Task`; the model files of all task example clients share their entity/property UIDs).

## Topology and why it works

- The Mac and the Linux host must be on the same LAN segment (mDNS/Bonjour must cross between them; check
  with `dns-sd -B _services._dns-sd._udp local.` on the Mac and `getent ahosts <mac>.local` on Linux).
- The emulator guest sits behind the emulator's own NAT. Nearby discovery over Wi-Fi LAN uses mDNS, which
  does not cross that NAT by default. The emulator's `netsimd` can forward mDNS from the host into the guest
  (`--forward-host-mdns`), which is enough: the emulator discovers the Mac and opens the TCP connection
  outbound (the Mac cannot route to the guest's private address, so the Mac side never initiates; both sides
  advertise and discover, so this is fine).
- The Mac side restricts Nearby to the Wi-Fi LAN medium; Android uses whatever mediums Play Services picks
  (Wi-Fi LAN, BLE, Bluetooth Classic). Only Wi-Fi LAN can reach the emulator.
- Nearby derives a Bonjour service type `_<hash>._tcp` from the mesh ID. Both platforms must end up with the
  same type; it shows up in the Android `serviceDiscovery`/`NearbyMediums` logs and in the Mac's network logs.

## Prerequisites

Linux host:
- Android SDK with emulator, platform-tools and a Google Play system image; an AVD created from it (Play
  Services with the Nearby module is required; plain AOSP images do not work). KVM.
- JDK matching the example's Gradle/AGP; `local.properties` with `sdk.dir`.
- Access to the internal Maven registry that hosts ObjectBox snapshot artifacts: Gradle properties `gitlabUrl`
  and `gitlabPrivateToken` (optionally `gitlabPrivateTokenName`) in `~/.gradle/gradle.properties`. The
  registry URL is derived in `tasks/client-android-kotlin/settings.gradle.kts`; nothing is hardcoded.

Mac (the Swift app must run on macOS, not iOS, for this test):
- Xcode, a GUI login session (the app needs the macOS Local Network permission, which can only be granted
  from a prompt on screen or in System Settings), Screen Sharing or physical access to answer that prompt.
- Checkouts of `objectbox-swift` (mesh-enabled branch) and this repo side by side under the same parent
  directory (the local SwiftPM package in `tasks/client-swift/local-packages/objectbox-swift-spm` symlinks
  the transport sources via a relative path `../../../../../../objectbox-swift/...`).
- When driving the Mac from Linux over SSH, follow the rules in the `objectbox-swift` AGENTS.md section
  "Building from a Linux machine via the build Mac" (multiplexed master socket, `-o BatchMode=yes`, no
  password handling). `USER@MAC` below stands for that login.

## Android side (Linux host)

### 1. ObjectBox artifacts

`tasks/client-android-kotlin/gradle/libs.versions.toml` has two version entries: `objectbox` for the Gradle
plugin (a release) and `objectbox-snapshot` for the libraries. Set `objectbox-snapshot` to the snapshot that
carries the mesh sync API you want to test. Snapshot names follow `<version>-<branch>-SNAPSHOT` of the
objectbox-java repo; they pull in the native `objectbox-sync-android-db` snapshot of the core's sync branch.
Available versions can be listed from the registry's `maven-metadata.xml`
(`<registry>/io/objectbox/<artifact>/maven-metadata.xml`, header `Private-Token: <token>`).

Verify what resolves (must not contain the plugin's release version for the libraries):

```shell
cd tasks/client-android-kotlin
./gradlew :app:dependencies --configuration debugRuntimeClasspath | grep io.objectbox
```

Notes:
- `objectbox-java`/`objectbox-kotlin` are declared explicitly: the Gradle plugin only injects them at its own
  version when the project does not declare them.
- `cacheChangingModulesFor(0, "seconds")` makes Gradle re-check the snapshots on every build.

### 2. Emulator with host-to-guest mDNS forwarding

```shell
export ANDROID_HOME=$HOME/Android/Sdk
nohup $ANDROID_HOME/emulator/emulator -avd <AVD> -netsim-args --forward-host-mdns > emulator.log 2>&1 &
$ANDROID_HOME/platform-tools/adb wait-for-device
# boot complete when this prints 1:
$ANDROID_HOME/platform-tools/adb shell getprop sys.boot_completed
pgrep -af netsimd     # must show --forward-host-mdns
```

Storage: Play images leave little free space in `/data`. If `pm install` fails with "not enough space",
install an ABI-specific APK (`-Pandroid.injected.build.abi=x86_64`), uninstall leftovers, run
`adb shell pm trim-caches 100000000000`, or enlarge the AVD's internal storage. As a last resort the guest's
low-storage reserve can be lowered (`adb shell settings put global sys_storage_threshold_percentage 1` and
`sys_storage_threshold_max_bytes 52428800`; revert with `settings delete global ...`).

### 3. Build, install, permissions, launch

```shell
cd tasks/client-android-kotlin
./gradlew :app:installDebug -Pandroid.injected.build.abi=x86_64
./grant_android_permissions.sh <serial>       # Nearby/Bluetooth/location runtime permissions
$ANDROID_HOME/platform-tools/adb shell am start -n io.objectbox.example.sync.kotlin/io.objectbox.example.sync.TasksActivity
$ANDROID_HOME/platform-tools/adb logcat -v time > logcat.log 2>&1 &
```

Useful log filters: `ObxMesh` (transport), `ObjectBox` with `[MshSnc]` (core mesh), `OBXSync` (app),
`NearbyConnections`/`NearbyMediums` (Play Services). Expected within a minute of launch:
"Advertising started with name: <hex>", "Discovery started", and `NearbyMediums` lines confirming Wi-Fi LAN
advertising/discovery. Seeing its own service ("but that's us. Ignoring." / "comes from a local address") is
normal.

### 4. Inspect objects without the UI (ObjectBox Admin, debug builds)

```shell
$ANDROID_HOME/platform-tools/adb forward tcp:8090 tcp:8090      # Admin logs its port; 8090 by default
SID=$(curl -s -X POST http://127.0.0.1:8090/api/v2/sessions | tr -d '"')
curl -s --compressed -H "Authorization: Bearer $SID" \
  'http://127.0.0.1:8090/api/query?entity_name=Task&offset=0&limit=100'
```

Admin on the Android build lists objects but cannot create them (no GraphQL). Add tasks in the emulator UI
or via `adb shell input tap/text` (coordinates depend on the AVD; check with `adb shell uiautomator dump`).

## Mac side

### 1. Build the mesh-enabled ObjectBox framework and wrap it as an xcframework

In the `objectbox-swift` checkout on the Mac (mesh-enabled branch, core submodule at the matching commit):

```shell
cd ~/dev/objectbox-swift/ios-framework && make fetch_dependencies
xcodebuild build -project ObjectBox.xcodeproj -scheme ObjectBox-macOS -configuration Release \
  -destination platform=macOS -derivedDataPath build/mesh-interop
OUT=~/dev/objectbox-sync-examples/tasks/client-swift/local-packages/objectbox-swift-spm/ObjectBox-Sync.xcframework
rm -rf "$OUT"
xcodebuild -create-xcframework -framework build/mesh-interop/Build/Products/Release/ObjectBox.framework -output "$OUT"
```

The xcframework is git-ignored; rebuild it whenever the framework changes. After such a rebuild, also clear
the app's cached copies before building the app, otherwise the Swift compiler keeps using the old module
(`build/Build/Products/Debug/ObjectBox.framework`, `build/Build/Products/Debug/PackageFrameworks`,
`build/Build/Intermediates.noindex/SwiftExplicitPrecompiledModules`, `build/ModuleCache.noindex`). The local package
(`local-packages/objectbox-swift-spm`, see its README) replaces the remote `objectbox-swift-spm`
dependency in the Xcode project, so no ObjectBox release is involved on this side. Because the override is
macOS only, the iOS target of the example does not build while it is in place.

### 2. Build and launch the app

```shell
cd ~/dev/objectbox-sync-examples/tasks/client-swift
xcodebuild -project client-swift.xcodeproj -scheme client-swift-macos -configuration Debug \
  -derivedDataPath build CODE_SIGN_IDENTITY=- CODE_SIGN_STYLE=Manual DEVELOPMENT_TEAM= build
open build/Build/Products/Debug/client-swift-macos.app
```

The first build compiles Google's Nearby C++ core (several minutes). Launching with `open` puts the app into
the GUI session even when started over SSH. Accept the **Local Network** prompt on the Mac's screen (and the
Bluetooth prompt if shown; Nearby initializes Bluetooth even though only Wi-Fi LAN is used). Until the
prompt is answered, Bonjour browse/advertise is silently suppressed: `mDNSResponder` logs
`policy 'pending'` for the app, and the mesh stays at "Discovering" with zero peers.

### 3. Logs

```shell
# zsh has a "log" builtin, hence the full path
/usr/bin/log show --last 5m --info --style compact --predicate 'process == "client-swift-macos"' | grep "Mesh:"
/usr/bin/log show --last 5m --info --style compact \
  --predicate 'process == "mDNSResponder" AND eventMessage CONTAINS "client-swift-macos"'
```

The app logs `Mesh: state=... peers=... peersDiscovered=... txLogsSent=... txLogsApplied=...` every 5 s,
and `Received change for entity id ...` for incoming objects. Its database is in
`~/Library/Application Support/io.objectbox.client-swift-macos/tasks`.

Driving all of this from Linux: rsync both checkouts to the Mac before building (see the AGENTS.md section
mentioned above for the `objectbox-swift` command; for this repo sync `tasks/client-swift/` and exclude
`build`, `DerivedData`, `.build` and `ObjectBox-Sync.xcframework`), then run the commands above through
`ssh -o BatchMode=yes -S ~/.cache/ssh-build-mac.sock USER@MAC 'zsh -lc "..."'`.

## Expected sequence and verification

1. Mac: `Mesh: state=Discovering` and, after the Local Network grant, the Mac's own service appears in
   `dns-sd -B _<hash>._tcp local.` on the Mac (the emulator's instance may show up there too).
2. Android: `NearbyMediums: WIFI_LAN discovered service name:<instance> type:._<hash>._tcp at ip:<mac-ip>`,
   then `ObxMesh: Endpoint found ... info bytes: 16`, `Connection initiated ... incoming: false`,
   `Connection result ... success: true`.
3. Mac: `peers=1`, `txLogsApplied` increases; Android: `OBXSync: Changes: 1` per incoming object.
4. Add a task on each side (Mac UI; Android UI or `adb shell input`) and confirm it on the other side:
   Android via the Admin query above, Mac via the app window or the `Received change` log lines.

Repeated "Endpoint found" / "Ignoring peer lost for connected peer" lines are Nearby's discovery duty cycle
and harmless.

## Troubleshooting

- Android never discovers the Mac: check the Mac's `policy 'pending'` (prompt not answered), that `netsimd`
  runs with `--forward-host-mdns`, and that the Linux host itself sees the Mac's Bonjour records.
- Android discovers but cannot connect: the Mac's firewall must allow incoming connections to the app.
- Mac never discovers Android: expected (guest address unroutable); the connection is Android-initiated.
- Two Nearby nodes in one process or on one machine do not work (shared Nearby core, loopback filtering);
  see the `ObjectBoxMeshSync` package README in `objectbox-swift`.
- Wire compatibility: both sides must use the same mesh protocol version, cluster strategy, hex-encoded
  endpoint names and service ID = mesh ID. Info bytes decoding to 0 on Android means a foreign or
  incompatible peer.

## Cleanup

- Emulator: revert the low-storage settings if changed; `adb emu kill`.
- Mac: quit the app; the SSH master is closed by its owner.
- To return the Swift example to the released ObjectBox package, revert the `client-swift` commits of the
  interop branch (they remove the remote `objectbox-swift-spm` reference).
