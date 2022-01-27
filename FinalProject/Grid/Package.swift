// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "Grid",
    platforms: [
        .iOS(.v14),
    ],
    products: [
        .library(
            name: "Grid",
            targets: ["Grid"]),
    ],
    dependencies: [
        .package(path: "../GameOfLife"),
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", .upToNextMajor(from: "0.28.1"))
    ],
    targets: [
        .target(
            name: "Grid",
            dependencies: [
                "GameOfLife",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]
        ),
        .testTarget(
            name: "GridTests",
            dependencies: ["Grid"]),
    ]
)
