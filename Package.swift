// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LoopAlgorithm",
    platforms: [
        .macOS(.v13),
        .iOS(.v15),
        .tvOS(.v15),
        .watchOS(.v8),
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
        ),
    ],

    // dependencies: [
    //     .package(url: "https://github.com/google/flatbuffers", exact: "24.3.25")
    // ],

    targets: [
        .target(
            name: "LoopAlgorithm"
        ),
        // .target(
        //     name: "LoopAlgorithmFBS",
        //     dependencies: [
        //         "LoopAlgorithm",
        //         .product(name: "FlatBuffers", package: "flatbuffers"),
        //     ]
        // ),
        .target(
            name: "FoundationShim"
        ),

        .executableTarget(
            name: "LoopWasm",
            dependencies: [
                "LoopAlgorithm",
                "FoundationShim",
                // "LoopAlgorithmFBS",
                // .product(name: "FlatBuffers", package: "flatbuffers"),
            ]
        ),
    ],

    swiftLanguageModes: [.v6]
)
