// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Theming",
    platforms: [
        .iOS(.v14),
    ],
    products: [
        .library(
            name: "Theming",
            targets: ["Theming"]
        ),
    ],
    dependencies: [ ],
    targets: [
        .target(
            name: "Theming",
            dependencies: []
        ),
        .testTarget(
            name: "ThemingTests",
            dependencies: ["Theming"]
        ),
    ]
)
