# ObjectBox Sync Examples: A Task Manager App

The Tasks example is a simple app that is a good starting point to learn about ObjectBox Sync.
It allows you to see CRUD operations in action across multiple devices, platforms, and programming languages:

- Create a new task with a description
- Mark a task as completed
- List all tasks or just the completed tasks
- Delete a task

## Project organization

The Tasks example is organized into subdirectories:

- One directory with example configurations and scripts to run the ObjectBox Sync Server
- Multiple directories for independent client examples,
  each using ObjectBox Sync client APIs to automatically sync data with the server

To run the example, you need the ObjectBox Sync Server and at least one client.

## Sync Server

The ObjectBox Sync Server is an essential part of the example.
Follow the instructions to start the server:

- [server-docker](./server-docker/): uses the ObjectBox Sync Server Docker image

## Sync Client Examples

The user-facing part of the Tasks app are the clients.
Combine the Sync Server with any of the Sync Client examples:

- [client-java](./client-java/): a JVM command-line app written in Java (Gradle and Maven are supported)

- [client-android-java](./client-android-java/): an Android app written in Java

- [client-android-kotlin](./client-android-kotlin/): an Android app written in Kotlin

- [client-flutter](./client-flutter/): a Flutter app written in Dart

- [client-go](./client-go/): a Go command-line app

You can run multiple clients concurrently and on any number of devices.

## A few notes on the Data Model

* The server and the clients use the same data model, which is a prerequisite for synchronization.
* All clients have a "Task" entity in their specific language along with a JSON file representing the data model.
* The server example already contains the data model (which was copied from one of the clients).
