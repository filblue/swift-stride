// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Stride",
    products: [
        .library(
            name: "Stride",
            targets: ["Stride"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Stride",
            dependencies: []),
        .testTarget(
            name: "StrideTests",
            dependencies: ["Stride"]),
    ]
)
