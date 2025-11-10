# Sync Client Example: using the Swift SDK in an iOS and macOS application

This example shows how to use the Sync client using the Swift SDK in an iOS and macOS application.

- See [`Task`](shared/Task.swift) on how to define a simple entity
- See [`TaskStore`](shared/TaskStore.swift) on how to set up Sync and perform basic database operations with `Task`

## Setup

1. Open `client-swift.xcodeproj` in Xcode, or run the following command in this directory:

   ```
   open client-swift.xcodeproj
   ```

2. Choose `client-swift-ios` as the active scheme and click the 'Play' button to run the iOS app on the selected device. Similarly, choose `client-swift-macos` as the active scheme to run the macOS app.

Note: to build and run the iOS app without having to sign in with an Apple ID (to set a development team), choose an iOS Simulator Device right next to the scheme.

## Updating the ObjectBox Swift Package Version

1. Open `client-swift.xcodeproj` in Xcode, or run the following command in this directory:

   ```
   open client-swift.xcodeproj
   ```

2. Control-click the ObjectBox package in the Project Navigator in the left and click "Update Package".

   To instead update all package dependencies, control-click the "Package Dependencies" header and click "Update to Latest Package Versions".

The latest available version might not be resolved if the dependency rule doesn't allow it.

To change the dependency rule:

1. Open the project `client-swift` from the Project Navigator and select 'Package Dependencies'. 

2. Update the 'Dependency Rule' of package 'ObjectBox' as needed.

## Documentation

- [Sync client](https://sync.objectbox.io/sync-client)
- [ObjectBox Swift SDK](https://swift.objectbox.io/getting-started)
- [ObjectBox Swift API Reference](https://objectbox.io/docfiles/swift/current/)
