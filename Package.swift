// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "EFBKit",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "EFBKit", targets: ["EFBKit"]),
    ],
    targets: [
        .target(name: "EFBKit"),
    ]
)
