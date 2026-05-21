// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "TintAudit",
    platforms: [.macOS(.v10_15)],
    products: [
        .executable(name: "TintAudit", targets: ["TintAudit"])
    ],
    dependencies: [
        .package(url: "https://github.com/TokamakUI/Tokamak.git", from: "0.12.0"),
        .package(url: "https://github.com/swiftwasm/JavaScriptKit.git", from: "0.19.0"),
    ],
    targets: [
        .executableTarget(
            name: "TintAudit",
            dependencies: [
                .product(name: "TokamakShim", package: "Tokamak"),
                .product(name: "JavaScriptKit", package: "JavaScriptKit"),
            ]
        )
    ]
)
