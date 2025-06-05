// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "AsahiCore",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .library(name: "AsahiCore", targets: ["AsahiCore"]),
    ],
    targets: [
        .target(
            name: "AsahiCore",
            path: "Sources",
            exclude: [
                "App",
                "ViewModels",
                "Views",
                "Models/GenerationHistory.swift"
            ],
            sources: ["Extensions", "Models", "Services"]
        ),
        .testTarget(
            name: "AsahiCoreTests",
            dependencies: ["AsahiCore"],
            path: "Tests"
        )
    ]
)
