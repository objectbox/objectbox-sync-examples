# Sync Client Example: using the Dart SDK in a Flutter application 

This example shows how to use ObjectBox Sync in a Flutter task list app written in Dart.

- See the [`ObjectBox`](lib/objectbox.dart) class on how to configure a Sync client and basic box operations.
- See the [`Task`](lib/model.dart) class on how to define a simple entity.

## Setup

### Android Studio

1. Open this directory in Android Studio with the Flutter plugin installed.

2. Run ObjectBox generator in this directory with the following command:

    ```shell
    dart run build_runner build
    ```

    > [!NOTE]
    > In an actual project the generator is only run when first creating or making changes to the model. And, in addition to the model JSON file, the generated `objectbox.g.dart` file would be version controlled.

3. To run the app, from the toolbar select a device and once it is started click **Run 'main.dart'**.

### Other IDEs or from the command line

The basic steps to get this example running (assuming you have a working Flutter setup):

```shell
# Set up project, get latest dependencies
flutter pub upgrade

# Generate model and code files for ObjectBox
dart run build_runner build

# Run the app in debug mode
flutter run
```

> [!NOTE]
> In an actual project the generator is only run when first creating or making changes to the model. And, in addition to the model JSON file, the generated `objectbox.g.dart` file would be version controlled.

## Documentation

- [Sync Client](https://sync.objectbox.io/sync-client)
- [ObjectBox Flutter API](https://docs.objectbox.io/getting-started)
- [`objectbox` Dart Package on `pub.dev`](https://pub.dev/packages/objectbox)
