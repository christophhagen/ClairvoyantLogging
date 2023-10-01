// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "ClairvoyantLogging",
    platforms: [.macOS(.v12), .iOS(.v14), .watchOS(.v9)],
    products: [
        .library(
            name: "ClairvoyantLogging",
            targets: ["ClairvoyantLogging"]),
    ],
    dependencies: [
        .package(url: "https://github.com/christophhagen/Clairvoyant", from: "0.11.2"),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.5.0"),

    ],
    targets: [
        .target(
            name: "ClairvoyantLogging",
            dependencies: [
                .product(name: "Clairvoyant", package: "Clairvoyant"),
                .product(name: "Logging", package: "swift-log"),
            ]),
        .testTarget(
            name: "ClairvoyantLoggingTests",
            dependencies: ["ClairvoyantLogging"]),
    ]
)
