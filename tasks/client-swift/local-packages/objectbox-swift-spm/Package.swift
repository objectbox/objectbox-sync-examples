// swift-tools-version: 5.9
// Temporary LOCAL override of the remote "objectbox-swift-spm" package (same package identity, i.e. the
// directory name must stay "objectbox-swift-spm") for the mesh sync interop test:
// - ObjectBox-Sync.xcframework is the locally built, mesh-enabled framework (not the released 5.3.0 one),
//   produced by ../../../../../objectbox-swift/ios-framework (see README.md next to this file).
// - ObjectBoxMeshSync adds the Google-Nearby-based mesh transport; its sources are a symlink into the
//   objectbox-swift repo (Sources/ObjectBoxMeshSync).

import PackageDescription

let package = Package(
  name: "ObjectBox",
  platforms: [
    .macOS(.v14), .iOS(.v17),
  ],
  products: [
    .library(name: "ObjectBox-Sync.xcframework", targets: ["ObjectBox-Sync.xcframework"]),
    .library(name: "ObjectBoxMeshSync", targets: ["ObjectBoxMeshSync"]),
  ],
  dependencies: [
    // No SPM version tags upstream yet; matches objectbox-swift/ObjectBoxMeshSync/Package.swift
    .package(url: "https://github.com/google/nearby.git", branch: "main")
  ],
  targets: [
    // Locally built, mesh-enabled ObjectBox Sync framework (see README.md)
    .binaryTarget(
      name: "ObjectBox-Sync.xcframework",
      path: "ObjectBox-Sync.xcframework"
    ),
    // Symlink to objectbox-swift/ObjectBoxMeshSync/Sources/ObjectBoxMeshSync
    .target(
      name: "ObjectBoxMeshSync",
      dependencies: [
        .product(name: "NearbyConnections", package: "nearby"),
        // So that "import ObjectBox" inside the transport sources resolves
        .target(name: "ObjectBox-Sync.xcframework"),
      ],
      path: "Sources/ObjectBoxMeshSync"
    ),
  ]
)
