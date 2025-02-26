# ObjectBox Sync Examples - A Task Manager App

This directory contains a simple 'task manager' app built with different ObjectBox Sync client SDKs for use with the ObjectBox Sync Server.

## Available Examples

1. `client-java`: Uses the Sync Java client-side APIs to build a command-line task-manager app

2. `client-android-java`: Demonstrates the usage of Sync client-side SDK for Java in an Android app

3. `client-android-kotlin`: Demonstrates the usage of Sync client-side SDK for Kotlin in an Android app

## Using The Examples

### Using the `client-java` example

#### Intellij Idea

1. Open the `client-java` directory in Intellij Idea. Opening the directory in Intellij Idea should automatically start building the project with Gradle.

2. On a successful Gradle build, right-click the `app/src/main/java/io/objectbox/example/Main.java` file and select the **Run 'Main.main()'** option.

#### Other IDEs

1. Open the `client-java` directory in an IDE of your choice. 
2. In the directory, execute the following command to build and run the CLI application:

```bash
./gradlew run
```

### Using the `client-android-java` and `client-android-kotlin` examples

1. Open the `client-android-java`/`client-android-kotlin` directory in Android Studio. A project build is initiated automatically; if not select the **Build > Build Project** from the toolbar.
2. After a successful project build, [connect an Android device](https://developer.android.com/studio/run/device) to your system. Once connected, the name of the device must be visible in top menu-bar in Android Studio. Click on the 'Play' button to run the app on the test-device.

### Using the `client-flutter` example

Open the `client-flutter` directory in an IDE and execute the following commands in a terminal:

```
# Set up project, get latest dependencies
flutter pub upgrade

# Generate model and code files for ObjectBox
dart run build_runner build

# Run the app in debug mode
flutter run
```

### Using the `client-go` example

```shell
$ go build main.go
```