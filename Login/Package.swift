// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Login",
    platforms: [
        .iOS(.v16),
    ],
    products: [
        .library(
            name: "Login",
            targets: ["Login"]
        ),
    ],
    dependencies: [
        .package(path: "../ThirdParty")
    ],
    targets: [
        .target(
            name: "Login",
            dependencies: [
                .product(name: "ThirdParty", package: "ThirdParty")
            ]
        ),
        .testTarget(
            name: "LoginTests",
            dependencies: ["Login"]
        ),
    ]
)
