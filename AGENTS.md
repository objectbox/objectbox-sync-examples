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

Sync matches entities and properties by UID, not by name: names may differ between clients (e.g. `date_created` in
C++, `dateCreated` in the server copy). Do not "fix" names to match; keep the IDs and UIDs identical.

Changing the model in one place means updating it consistently in the server copies and all other clients.
Generated binding code is committed (e.g. `client-go/model/*.obx.go`, `client-cpp/tasklist.obx.*`,
`client-flutter/lib/objectbox.g.dart`, `client-swift/generated/`) and must be regenerated after model changes
(`go generate` in `client-go/model`, `dart run build_runner build` for Flutter; Java/Android generate at build time).

Cross-client conventions: entities are marked as sync entities with a `SyncClock` property (conflict resolution);
an unfinished task has its finish date set to 0 (epoch start). Command-line clients (Java, Go, C++, Python) share the
same shell commands: `ls [-a]`, `new <text>`, `done <id>`, `exit`, `help` (`client-java` also has `rm <id>`).

## Sync Server

- `tasks/server-docker/start.sh [tag]` runs `objectboxio/sync-server-trial` in Docker, mounting the directory as `/data`
  (DB in `./objectbox`, delete it to start fresh). Sync protocol on `ws://127.0.0.1:9999`, Admin UI on
  http://127.0.0.1:9980 (trial must be activated there). Config: `sync-server-config.json`
  (`unsecuredNoAuthentication: true`; rename `_debug` to `debug` for debug logs).
- `tasks/server-mongo-compose`: `docker compose up` for the Sync Server plus MongoDB (port 27017).
- Clients connect to `ws://127.0.0.1:9999`; Android emulators use `10.0.2.2` for the host.
- Without trial activation, the server rejects every write: clients log `Received REJECT_TX ... with code 2`, the server
  `State condition failed in updatePreviousTxLog:61: trial`.
- **Only the user may activate the trial; agents must not.** Activation (Admin page `#/sync-trial`) is a legal consent:
  agreeing to the ObjectBox Trial License and Privacy Policies, stating the evaluation role, and registering or logging
  in. Do not fill in the form or call its endpoints; ask the user to activate it, or to provide a non-trial server image.
  The trial applies per dataset (30 days each): a fresh server database (e.g. after deleting `./objectbox` or with a new
  data directory) needs activation again, so prefer reusing an activated server over starting fresh ones.

## Build / run commands

Run from the respective project directory (GitLab CI, `.gitlab-ci.yml`, has jobs for client-java, the Android clients,
client-swift, client-cpp and client-python):

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

CI never syncs data. To test Sync end to end: start the server (with the trial activated by the user, see above),
then run two clients with separate databases, e.g. `main.py --directory a` and `main.py --directory b` (C++: `-d dir`);
`new` or `done` on one makes the other print "Task list has changed (synced)" with the updated list.

## client-python

- `requirements.txt` pins `objectbox-sync` (the Sync variant; install it instead of `objectbox`).
- Its `objectbox-model.json` is a copy of the server's (`tasks/server-docker`): objectbox-python stores property names
  in camelCase since 5.0 (`date_created` is `dateCreated`), so it matches the server's names, and opening the store
  leaves the file unchanged.

## Versions

`scripts/java-set-version.sh <version>` bumps the ObjectBox version for all Java-based clients
(`gradle/libs.versions.toml` in client-java, client-android-java, client-android-kotlin and `client-java/pom.xml`)
and commits the change.

## Commits

Prefix commit messages with the project or area, e.g. `client-flutter: ...`, `client-android-*: ...`, `CI: ...`.
The remote is `github`.
