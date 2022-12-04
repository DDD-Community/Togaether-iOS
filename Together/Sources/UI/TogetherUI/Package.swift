// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TogetherUI",
    platforms: [
        .iOS(.v16),
    ],
    products: [
        .library(
            name: "TogetherUI",
            targets: ["TogetherUI"]
        ),
    ],
    dependencies: [
        .package(path: "../ThirdParty"),
    ],
    targets: [
        .target(
            name: "TogetherUI",
            dependencies: [
                .product(name: "ThirdParty", package: "ThirdParty"),
            ]),
        .testTarget(
            name: "TogetherUITests",
            dependencies: ["TogetherUI"]
        ),
    ]
)
