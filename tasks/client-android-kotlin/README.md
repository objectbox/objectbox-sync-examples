# Sync Client Example: using the Java SDK in a Kotlin Android application 

This example shows how to use ObjectBox Sync in an Android task list app written in Kotlin.

- See [`ObjectBox`](app/src/main/java/io/objectbox/example/sync/ObjectBox.kt) on how to configure a Sync client.
- See [`Task`](app/src/main/java/io/objectbox/example/sync/Task.kt) on how to define a simple entity.
- See [`TasksActivity`](app/src/main/java/io/objectbox/example/sync/TasksActivity.kt) for basic box operations.

## Setup

### Android Studio

1. Open this directory in Android Studio. The Gradle project should sync automatically.

2. Once the project is synced, to build the project, from the menu click **Build > Build Project** or **Assemble 'app' Run Configuration**.

3. To run the app on an emulator or device, click **Run 'app'** in the toolbar.

### Other IDEs or from the command line

1. Open this directory.

2. To build the application, run the following command:

    ```shell
    ./gradlew assembleDebug
    ```

3. To install the application on an emulator or device, run the following command:

    ```shell
    ./gradlew installDebug
    ```

## Documentation

- [Sync client](https://sync.objectbox.io/sync-client)
- [ObjectBox Java API](https://docs.objectbox.io/getting-started)
- [ObjectBox Java API Reference](https://objectbox.io/docfiles/java/current/)
