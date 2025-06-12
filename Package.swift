// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Serialization",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Serialization",
            targets: ["Serialization"]),
    ],
    dependencies: [
        .package(url: "https://github.com/awxkee/jxl-coder-swift", .upToNextMajor(from: "1.7.3")),
        .package(url: "https://github.com/AppliedRecognition/Ver-ID-Common-Types-Apple.git", .upToNextMajor(from: "2.0.0")),
        .package(url: "https://github.com/apple/swift-protobuf.git", from: "1.28.2")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Serialization",
            dependencies: [
                .product(name: "VerIDCommonTypes", package: "Ver-ID-Common-Types-Apple"),
                .product(name: "JxlCoder", package: "jxl-coder-swift"),
                .product(name: "SwiftProtobuf", package: "swift-protobuf")
            ]),
        .testTarget(
            name: "SerializationTests",
            dependencies: ["Serialization"],
            resources: [
                .copy("Resources/image.bin")
            ]),
    ]
)
