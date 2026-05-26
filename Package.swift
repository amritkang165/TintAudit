// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "TintAudit",
    platforms: [.macOS(.v13)],
    products: [
        .executable(name: "TintAudit", targets: ["TintAudit"])
    ],
    dependencies: [
        .package(url: "https://github.com/TokamakUI/Tokamak.git", exact: "0.11.1"),
        .package(url: "https://github.com/swiftwasm/JavaScriptKit.git", exact: "0.19.0"),
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
