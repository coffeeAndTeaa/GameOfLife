// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Simulation",
    platforms: [
        .iOS(.v14),
    ],
    products: [
        .library(
            name: "Simulation",
            targets: ["Simulation"]
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
            name: "Simulation",
            dependencies: [
                "Grid",
                "Theming",
                "GameOfLife",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]
        ),
        .testTarget(
            name: "SimulationTests",
            dependencies: ["Simulation"]
        ),
    ]
)
