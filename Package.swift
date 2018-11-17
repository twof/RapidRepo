// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "RapidRepo",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "RapidRepo",
            targets: ["Repository"]),
    ],
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0"),

        // 🔵 Swift ORM (queries, models, relations, etc) built on SQLite 3.
        .package(url: "https://github.com/vapor/fluent-sqlite.git", from: "3.0.0")
    ],
    targets: [
        .target(name: "Repository", dependencies: ["FluentSQLite", "Vapor"]),
        .testTarget(name: "RepositoryTests", dependencies: ["Repository"]),
        .target(name: "ExampleApp", dependencies: ["FluentSQLite", "Vapor", "Repository"]),
        .target(name: "ExampleRun", dependencies: ["ExampleApp"]),

    ]
)

