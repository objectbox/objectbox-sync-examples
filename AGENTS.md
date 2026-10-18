# AGENTS.md

This file provides guidance to AI coding agents when working with code in this repository.

## What this repo is

Examples for ObjectBox Sync (offline-first data sync between devices and a server). Currently there is one example,
`tasks/` (a task manager), made of one Sync Server setup plus many independent client apps in different languages.
Each `tasks/client-*` and `tasks/server-*` directory is a self-contained project with its own build tooling and README;
there is no top-level build.

## The shared data model (most important invariant)

The server and every client must use the **same data model, identical by IDs and UIDs** (entity `Task`,
entity ID `1:6645479796472661392`). Each project keeps its own copy of the model JSON:

- `tasks/server-docker/objectbox-model.json`, `tasks/server-mongo-compose/objectbox-model.json` (the server loads it via
  `modelFile` in `sync-server-config.json`; copied from a client)
- Java/Android: `app/objectbox-models/default.json`; Flutter: `lib/objectbox-model.json`; Go: `model/objectbox-model.json`;
  C++/Python: `objectbox-model.json`; Swift: `model-client-swift-{ios,macos}.json`

Changing the model in one place means updating it consistently in the server copies and all other clients.
Generated binding code is committed (e.g. `client-go/model/*.obx.go`, `client-cpp/tasklist.obx.*`,
`client-flutter/lib/objectbox.g.dart`, `client-swift/generated/`) and must be regenerated after model changes
(`go generate` in `client-go/model`, `dart run build_runner build` for Flutter; Java/Android generate at build time).

Cross-client conventions: entities are marked as sync entities with a `SyncClock` property (conflict resolution);
an unfinished task has its finish date set to 0 (epoch start). Command-line clients (Java, Go, C++, Python) share the
same shell commands: `ls [-a]`, `new <text>`, `done <id>`, `exit`, `help`.

## Sync Server

- `tasks/server-docker/start.sh [tag]` runs `objectboxio/sync-server-trial` in Docker, mounting the directory as `/data`
  (DB in `./objectbox`, delete it to start fresh). Sync protocol on `ws://127.0.0.1:9999`, Admin UI on
  http://127.0.0.1:9980 (trial must be activated there). Config: `sync-server-config.json`
  (`unsecuredNoAuthentication: true`; rename `_debug` to `debug` for debug logs).
- `tasks/server-mongo-compose`: `docker compose up` for the Sync Server plus MongoDB (port 27017).
- Clients connect to `ws://127.0.0.1:9999`; Android emulators use `10.0.2.2` for the host.

## Build / run commands (as used in CI, `.gitlab-ci.yml`)

Run from the respective project directory:

- `client-java`: `./gradlew clean build`, `./gradlew run`; Maven: `./mvnw compile`, `./mvnw compile exec:java`
- `client-android-java`, `client-android-kotlin`: `./gradlew clean assembleDebug lintDebug`
- `client-swift`: `xcodebuild build -scheme client-swift-ios -destination 'platform=iOS Simulator,name=iPhone 11'`
  and `-scheme client-swift-macos -destination 'platform=macOS'`
- `client-cpp`: `./build.sh` (`--clean` first arg to wipe build dir, `--run` to run); binary
  `build/objectbox-examples-tasks-sync`
- `client-python`: `python -m venv .venv && .venv/bin/pip install -r requirements.txt && .venv/bin/python main.py`
  (options `--url`, `--directory`); requires the `objectbox-sync` package, not `objectbox`
- `client-go`: needs the ObjectBox C library with Sync (see its README), then `CGO_LDFLAGS="-L$(pwd)/lib" go build main.go`
- `client-flutter`: `flutter pub get`, `flutter run`

There are no unit tests. CI smoke-tests the CLI clients without a server by piping commands, e.g.
`printf "new Buy bananas\nls\nexit\n" | .venv/bin/python main.py` (the client keeps retrying the connection in the
background, which is fine).

## Versions

`scripts/java-set-version.sh <version>` bumps the ObjectBox version for all Java-based clients
(`gradle/libs.versions.toml` in client-java, client-android-java, client-android-kotlin and `client-java/pom.xml`)
and commits the change.
