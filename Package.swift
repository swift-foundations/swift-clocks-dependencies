// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-clocks-dependencies",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [

        .library(
            name: "Clocks Dependencies",
            targets: ["Clocks Dependencies"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-foundations/swift-dependencies.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-primitives/swift-clock-primitives.git",
            branch: "main"
        ),
    ],
    targets: [
        .target(
            name: "Clocks Dependencies",
            dependencies: [
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "Clock Primitives", package: "swift-clock-primitives"),
            ]
        ),
        .testTarget(
            name: "Clocks Dependencies Tests",
            dependencies: [
                "Clocks Dependencies",
                .product(name: "Dependencies Test Support", package: "swift-dependencies"),
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
