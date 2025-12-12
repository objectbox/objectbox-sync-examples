# Sync Client Example: using the Dart SDK in a Flutter application 

This example shows how to use ObjectBox Sync in a Flutter task list app written in Dart.

- See the [`ObjectBox`](lib/objectbox.dart) class on how to configure a Sync client and basic box operations.
- See the [`Task`](lib/model.dart) class on how to define a simple entity.

## Setup

### Android Studio

1. Open this directory in Android Studio with the Flutter plugin installed.

2. To run the app, from the toolbar select a device and once it is started click **Run 'main.dart'**.

### Other IDEs or from the command line

The basic steps to get this example running (assuming you have a working Flutter setup):

```shell
# Set up project, get latest dependencies
flutter pub get

# Run the app in debug mode
flutter run
```

If you make changes to the data model, run the ObjectBox generator to update generated files:

```shell
dart run build_runner build
```

### Prerequisites

* Ubuntu: If you get an error like "The following required packages were not found: gtk+-3.0", run`sudo apt-get install libgtk-3-dev`

## Documentation

- [Sync Client](https://sync.objectbox.io/sync-client)
- [ObjectBox Flutter API](https://docs.objectbox.io/getting-started)
- [`objectbox` Dart Package on `pub.dev`](https://pub.dev/packages/objectbox)
