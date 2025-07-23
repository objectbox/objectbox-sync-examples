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

## Documentation

- [Sync client](https://sync.objectbox.io/sync-client)
- [ObjectBox Swift SDK](https://swift.objectbox.io/getting-started)
- [ObjectBox Swift API Reference](https://objectbox.io/docfiles/swift/current/)
