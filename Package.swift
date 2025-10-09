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
        .package(url: "https://github.com/MeAndRaw-E/LoggingTime", branch: "master"),
        .package(url: "https://github.com/MeAndRaw-E/Swifter", branch: "master"),
    ],
    targets: [
        .target(
            name: "APITime",
            dependencies: [
                .product(name: "LoggingTime", package: "LoggingTime"),
                .product(name: "Swifter", package: "Swifter"),
            ],
            path: "Sources"
        )
    ]
)
