// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Liwl",
    platforms: [
        .iOS(.v15),
        .macOS(.v11)
    ],
    products: [
        .library(
            name: "Liwl",
            targets: ["Liwl", "Helpers", "Models"]),
    ],
    targets: [
        .target(
            name: "Liwl",
            dependencies: ["Helpers", "Models"]
        ),
        .target(
            name: "Helpers"
        ),
        .target(
            name: "Models"
        ),
        .testTarget(
            name: "LiwlTests",
            dependencies: ["Liwl"]),
    ]
)
