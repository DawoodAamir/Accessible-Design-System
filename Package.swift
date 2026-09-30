// swift-tools-version: 5.7
import PackageDescription
let package = Package(name: "AccessibleDesignKit", platforms: [.iOS(.v15), .macOS(.v12)], products: [.library(name: "AccessibleDesignKit", targets: ["AccessibleDesignKit"])], targets: [.target(name: "AccessibleDesignKit", path: "Sources/Core"), .testTarget(name: "AccessibleDesignKitTests", dependencies: ["AccessibleDesignKit"], path: "Tests/Core")])
