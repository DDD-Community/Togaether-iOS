// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ThirdParty",
    platforms: [
        .iOS(.v16),
    ],
    products: [
        .library(
            name: "ThirdParty",
            targets: ["ThirdParty"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/ioskrew/SwiftLayout", .upToNextMajor(from: "2.0.0")),
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", branch: "main"),
        .package(url: "https://github.com/airbnb/lottie-ios", from: "4.1.2"),
    ],
    targets: [
        .target(
            name: "ThirdParty",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "SwiftLayout", package: "SwiftLayout"),
                .product(name: "SwiftLayoutUtil", package: "SwiftLayout"),
                .product(name: "Lottie", package: "lottie-ios"),
            ]
        ),
    ]
)
