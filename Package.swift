// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "TintAudit",
    platforms: [.macOS(.v13)],
    products: [
        .executable(name: "TintAudit", targets: ["TintAudit"])
    ],
    dependencies: [
        .package(url: "https://github.com/swiftwasm/JavaScriptKit.git", exact: "0.56.1"),
    ],
    targets: [
        .executableTarget(
            name: "TintAudit",
            dependencies: [
                .product(name: "JavaScriptKit", package: "JavaScriptKit"),
            ]
        )
    ]
)
