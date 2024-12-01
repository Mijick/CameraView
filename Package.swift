// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MijickCamera",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(name: "MijickCamera", targets: ["MijickCamera"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Mijick/Timer", .branch("patch-2.0.0"))
    ],
    targets: [
        .target(name: "MijickCamera", dependencies: [.product(name: "MijickTimer", package: "Timer")], path: "Sources"),
        .testTarget(name: "MijickCameraTests", dependencies: ["MijickCamera"], path: "Tests")
    ],
    swiftLanguageModes: [.v6]
)
