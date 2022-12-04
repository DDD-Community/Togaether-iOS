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
        .package(path: "../Core/TogetherCore"),
        .package(path: "../UI/TogetherUI"),
    ],
    targets: [
        .target(
            name: "Login",
            dependencies: [
                .product(name: "TogetherCore", package: "TogetherCore"),
                .product(name: "TogetherUI", package: "TogetherUI"),
            ]
        ),
        .testTarget(
            name: "LoginTests",
            dependencies: ["Login"]
        ),
    ]
)
