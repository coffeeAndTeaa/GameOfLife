// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "Statistics",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "Statistics",
            targets: ["Statistics"]
        ),
    ],
    dependencies: [
        .package(path: "../GameOfLife"),
        .package(path: "../Theming"),
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", .upToNextMajor(from: "0.28.1"))
    ],
    targets: [
        .target(
            name: "Statistics",
            dependencies: [
                "GameOfLife",
                "Theming",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]
        ),
        .testTarget(
            name: "StatisticsTests",
            dependencies: ["Statistics"]
        ),
    ]
)
