// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MijickCameraView",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(name: "MijickCameraView", targets: ["MijickCameraView"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Mijick/Timer", branch: "main")
    ],
    targets: [
        .target(name: "MijickCameraView", dependencies: [.product(name: "MijickTimer", package: "Timer")], path: "Sources"),
        .testTarget(name: "MijickCameraViewTests", dependencies: ["MijickCameraView"], path: "Tests"),
    ]
)
