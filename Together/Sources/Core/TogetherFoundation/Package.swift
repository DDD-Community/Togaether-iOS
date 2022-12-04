// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TogetherFoundation",
    platforms: [
        .iOS(.v16),
    ],
    products: [
        .library(
            name: "TogetherFoundation",
            targets: ["TogetherFoundation"]
        ),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "TogetherFoundation",
            dependencies: []
        ),
        .testTarget(
            name: "TogetherFoundationTests",
            dependencies: ["TogetherFoundation"]
        ),
    ]
)
