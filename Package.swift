// swift-tools-version: 5.10

import PackageDescription

let package = Package(
  name: "swift-led-strip",
  products: [
    .library(name: "SwiftLedStrip", targets: ["SwiftLedStrip"]),
  ],
  targets: [
    .target(name: "SwiftLedStrip")
  ])
