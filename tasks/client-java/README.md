# Sync Client Example: using the Java SDK in a command line application

This example shows how to use the Sync client using the Java SDK in a JVM console application.

- See [`Task`](app/src/main/java/io/objectbox/example/Task.java) on how to define a simple entity
- See [`TasksSyncDB`](app/src/main/java/io/objectbox/example/TasksSyncDB.java) on how to set up Sync and perform basic database operations with `Task`

## Setup
     
> [!NOTE]
> This project is set up both as a default Gradle multi-project build and a Maven build.

### IntelliJ IDEA

1. Open this directory. Choose to open as Gradle or Maven project.
   In any case, the project should sync and is then ready to build.

2. To build and run the application, run [`Main.java`](app/src/main/java/io/objectbox/example/Main.java).

### Other IDEs or from the command line

1. Open this directory.

2. To build and run the application, run the following command:

  Using Gradle:

    ```shell
    ./gradlew run
    ```        

  Using Maven:

    ```shell
    ./mvnw compile exec:java
    ```

## Documentation

- [Sync client](https://sync.objectbox.io/sync-client)
- [ObjectBox Java API](https://docs.objectbox.io/getting-started)
- [ObjectBox Java API Reference](https://objectbox.io/docfiles/java/current/)
