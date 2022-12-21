// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TogetherNetwork",
    platforms: [
        .iOS(.v16),
    ],
    products: [
        .library(
            name: "TogetherNetwork",
            targets: ["TogetherNetwork"]
        ),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "TogetherNetwork",
            dependencies: []),
        .testTarget(
            name: "TogetherNetworkTests",
            dependencies: ["TogetherNetwork"]
        ),
    ]
)
