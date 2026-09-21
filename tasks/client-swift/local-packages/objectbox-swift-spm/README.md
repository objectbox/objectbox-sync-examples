# Temporary local `objectbox-swift-spm` override (mesh sync interop test)

This directory is a **local SwiftPM package that overrides the remote
`https://github.com/objectbox/objectbox-swift-spm` dependency** of `client-swift.xcodeproj`
(Xcode matches them by package identity, which is the directory name `objectbox-swift-spm`).

Why: the released ObjectBox Swift 5.3.0 package has **no mesh sync support**. For the
macOS <-> Android mesh sync interop test the app needs

1. `ObjectBox-Sync.xcframework` built from the `mesh-sync` branch of the **objectbox-swift** repo, and
2. `ObjectBoxMeshSync`, the Google-Nearby-based mesh transport add-on from that same repo
   (`Sources/ObjectBoxMeshSync` here is a *relative symlink* into
   `../../../../../../objectbox-swift/ObjectBoxMeshSync/Sources/ObjectBoxMeshSync`, so both repos must
   be checked out next to each other, e.g. under `~/dev`).

`ObjectBox-Sync.xcframework` is **not** checked in (see `.gitignore`). Build it with:

```shell
cd ~/dev/objectbox-swift/ios-framework && make fetch_dependencies
xcodebuild build -project ~/dev/objectbox-swift/ios-framework/ObjectBox.xcodeproj \
  -scheme ObjectBox-macOS -configuration Release -destination 'platform=macOS' \
  -derivedDataPath ~/dev/objectbox-swift/ios-framework/build/mesh-interop
xcodebuild -create-xcframework \
  -framework ~/dev/objectbox-swift/ios-framework/build/mesh-interop/Build/Products/Release/ObjectBox.framework \
  -output ~/dev/objectbox-sync-examples/tasks/client-swift/local-packages/objectbox-swift-spm/ObjectBox-Sync.xcframework
```

Remove this directory (and the `XCLocalSwiftPackageReference` in `client-swift.xcodeproj`) once mesh
sync ships in a released ObjectBox Swift package.

Note: the xcframework built here is **macOS only**, so the `client-swift-ios` target cannot be built
while this override is active.
