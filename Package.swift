// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Siwf",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "Siwf",
            targets: ["Siwf"]),
    ],
    targets: [
        .target(
            name: "Siwf",
            dependencies: []
        ),
        .testTarget(
            name: "SiwfTests",
            dependencies: ["Siwf"]),
    ]
)
