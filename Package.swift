import PackageDescription

let package = Package(
    name: "Chip8",
    targets: [Target(name: "Chip8Kit")],
    exclude: ["Chip8"]
)
