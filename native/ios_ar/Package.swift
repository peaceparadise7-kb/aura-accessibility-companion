// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "AuraNativeAR",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "AuraNativeAR",
            targets: ["AuraNativeAR"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "AuraNativeAR",
            dependencies: []
        ),
        .testTarget(
            name: "AuraNativeARTests",
            dependencies: ["AuraNativeAR"]
        ),
    ]
)
