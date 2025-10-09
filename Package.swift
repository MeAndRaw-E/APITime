// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "APITime",
    platforms: [
        .macOS(.v14),
        .iOS(.v17),
    ],
    products: [
        .library(
            name: "APITime",
            targets: ["APITime"]
        )
    ],
    dependencies: [
        .package(path: "/Users/Raw-E/Desktop/Projects/Useful Swift Things/My Packages/Logging Time"),
        .package(path: "/Users/Raw-E/Desktop/Projects/Useful Swift Things/My Packages/Swifter"),
    ],
    targets: [
        .target(
            name: "APITime",
            dependencies: [
                .product(name: "LoggingTime", package: "Logging Time"),
                .product(name: "Swifter", package: "Swifter"),
            ],
            path: "Sources"
        )
    ]
)
