// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LoopAlgorithm",
    platforms: [
        .macOS(.v13),
        .iOS(.v15),
        .tvOS(.v15),
        .watchOS(.v8)
    ],
    products: [
        .library(
            name: "LoopAlgorithm",
            targets: ["LoopAlgorithm"]
        ),

        // .executable(
        //     name: "LoopAlgorithmRunner",
        //     targets: ["LoopAlgorithmRunner"]
        // ),

        .executable(
            name: "LoopWasm",
            targets: ["LoopWasm"]
        )
    ],

    targets: [
        .target(
            name: "LoopAlgorithm"
        ),

        // .executableTarget(
        //     name: "LoopAlgorithmRunner",
        //     dependencies: ["LoopAlgorithm"]
        // ),

        .executableTarget(
            name: "LoopWasm",
            dependencies: ["LoopAlgorithm"]
        ),
    ],

    swiftLanguageModes: [.v6]
)