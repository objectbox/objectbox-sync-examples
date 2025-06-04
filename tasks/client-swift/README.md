# Sync Client Example: using the Swift SDK in an iOS and macOS application

This example shows how to use the Sync client using the Swift SDK in an iOS and macOS application.

- See [`Task`](shared/Task.swift) on how to define a simple entity
- See [`TaskStore`](shared/TaskStore.swift) on how to set up Sync and perform basic database operations with `Task`

## Setup

> [!NOTE]
> This project uses CocoaPods to manage dependencies, [check out its website](https://cocoapods.org/) for an introduction and installation instructions.

1. Run the following command in this directory to install the `ObjectBox` pod:

```
pod install --repo-update
```

2. Open `client-swift.xcworkspace` with Xcode, either by selecting the directory through **Xcode > Open Existing Project >**, or by running the following command in this directory:

```
open client-swift.xcworkspace
```

3. Choose `client-swift-ios` as an active scheme and click the 'Play' button to run the iOS app on the selected device. Similarly, choose the `client-swift-macos` as the active scheme to run the macOS app.

Note: to build and run the iOS app without having to sign in with an Apple ID (to set a development team), choose an iOS Simulator Device right next to the scheme.

## Documentation

- [Sync client](https://sync.objectbox.io/sync-client)
- [ObjectBox Swift API](https://swift.objectbox.io/getting-started)
- [ObjectBox Swift API Reference](https://objectbox.io/docfiles/swift/current/)
