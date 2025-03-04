# `client-java` Sync Example: Using the Sync Client on JVM 

This example shows how to use the [Sync client](https://sync.objectbox.io/sync-client) in a console-based Java application.

* See [`Task`](java-main-sync/src/main/java/io/objectbox/example/Task.java) on how to define a simple entity
* See [`TasksSyncDB`](java-main-sync/src/main/java/io/objectbox/example/TasksSyncDB.java) to perform basic operations on [`Task`](java-main-sync/src/main/java/io/objectbox/example/Task.java) with the Sync client

### Setup

#### Intellij Idea

1. Open the `client-java` directory in Intellij Idea. Opening the directory in Intellij Idea should automatically start building the project with Gradle.

2. On a successful Gradle build, right-click the `app/src/main/java/io/objectbox/example/Main.java` file and select the **Run 'Main.main()'** option.

#### Other IDEs

1. Open the `client-java` directory in an IDE of your choice. 
2. In the directory, execute the following command to build and run the CLI application:

```bash
./gradlew run
```

### Docs

- [Sync client](https://sync.objectbox.io/sync-client)
- [ObjectBox Java API Guides](https://docs.objectbox.io/getting-started)
- [ObjectBox Java API Reference](https://objectbox.io/docfiles/java/current/)