// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NMapsUploader",
    products: [
        .executable(name: "nmaps-uploader", targets: ["NmapsUploader"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.2.0"),
        .package(url: "https://github.com/pointfreeco/swift-custom-dump", from: "1.1.2")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "NmapsUploader",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                "GPXCore",
                "YandexDiskClient"
            ]
        ),
        .target(
            name: "GPXCore"
        ),
        .testTarget(
            name: "GPXCoreTests",
            dependencies: [
                "GPXCore",
                .product(name: "CustomDump", package: "swift-custom-dump")
            ]
        ),
        .target(
            name: "Network"
        ),
        .target(
            name: "YandexDiskClient",
            dependencies: [
                "Network"
            ]
        )
    ]
)
