// swift-tools-version: 5.9
import PackageDescription

let dependencies: [Target.Dependency] = [
  .product(name: "Algorithms", package: "swift-algorithms"),
  .product(name: "ArgumentParser", package: "swift-argument-parser"),
  .product(name: "BTree", package: "BTree"),
  .product(name: "Collections", package: "swift-collections"),
  .product(name: "CustomDump", package: "swift-custom-dump"),
  .product(name: "Parsing", package: "swift-parsing"),
]

let package = Package(
  name: "AdventOfCode",
  platforms: [.macOS(.v13)],
  dependencies: [
    .package(url: "https://github.com/apple/swift-algorithms.git", .upToNextMajor(from: "1.2.0")),
    .package(url: "https://github.com/apple/swift-argument-parser.git", .upToNextMajor(from: "1.2.0")),
    .package(url: "https://github.com/apple/swift-collections.git", .upToNextMajor(from: "1.0.0")),
    .package(url: "https://github.com/apple/swift-format.git", .upToNextMajor(from: "509.0.0")),
    .package(url: "https://github.com/attaswift/BTree", from: "4.1.0"),
    .package(url: "https://github.com/pointfreeco/swift-custom-dump", from: "1.1.2"),
    .package(url: "https://github.com/pointfreeco/swift-parsing", from: "0.13.0"),
  ],
  targets: [
    .executableTarget(
      name: "AdventOfCode",
      dependencies: dependencies,
      resources: [.copy("Data")],
      swiftSettings: [
        .unsafeFlags([
          "-enable-bare-slash-regex",
        ])
      ]
    ),
    .testTarget(
      name: "AdventOfCodeTests",
      dependencies: ["AdventOfCode"] + dependencies
    )
  ]
)
