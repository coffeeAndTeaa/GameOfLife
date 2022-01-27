// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GameOfLife",
    platforms: [
        .iOS(.v14),
    ],
    products: [
        .library(
            name: "GameOfLife",
            targets: ["GameOfLife"]
        ),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "GameOfLife",
            dependencies: [ ]
        ),
        .testTarget(
            name: "GameOfLifeTests",
            dependencies: ["GameOfLife"]
        ),
    ]
)
