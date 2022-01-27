// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Configuration",
    platforms: [
        .iOS(.v14),
    ],
    products: [
        .library(
            name: "Configuration",
            targets: ["Configuration"]
        ),
    ],
    dependencies: [
        .package(path: "../Grid"),
        .package(path: "../GameOfLife"),
        .package(path: "../Theming"),
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", .upToNextMajor(from: "0.28.1"))
    ],
    targets: [
        .target(
            name: "Configuration",
            dependencies: [
                "Grid",
                "Theming",
                "GameOfLife",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]
        ),
        .testTarget(
            name: "ConfigurationTests",
            dependencies: ["Configuration"]),
    ]
)
