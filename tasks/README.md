# ObjectBox Sync Examples - A Task Manager App

This directory contains the "task manager" app example:

- client examples using various ObjectBox Sync client APIs, as well as
- an example configuration and scripts to run an ObjectBox Sync server

are available.

With the app it is possible to:

- Create a new task with a description
- Mark a task as completed
- List all tasks or just the completed tasks
- Delete a task

Changes are synced to the server and all connected clients.

## Client examples

The following client examples are available:

- [client-java](./client-java/): a JVM command-line app built with Gradle, uses the ObjectBox Java
  SDK

- [client-android-java](./client-android-java/): an Android app written in Java, uses the
  ObjectBox Java SDK

- [client-android-kotlin](./client-android-kotlin/): an Android app written in Kotlin, uses the
  ObjectBox Java SDK

- [client-flutter](./client-flutter/): a Flutter app, uses the ObjectBox Dart SDK

- [client-go](./client-go/): a Go command-line app, uses the ObjectBox Go SDK

## Server examples

Server configuration and setup scripts are available:

- [server-docker](./server-docker/): uses the ObjectBox Sync server Docker image
