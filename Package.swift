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
        .package(url: "https://github.com/MeAndRaw-E/LoggingTime", from: "1.0.0"),
        .package(url: "https://github.com/MeAndRaw-E/Swifter", from: "1.0.0"),
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
