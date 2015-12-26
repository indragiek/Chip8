//  Copyright © 2015 Indragie Karunaratne. All rights reserved.

/// Represents an opcode for the CHIP-8 virtual machine
/// Based on the opcode table from: https://en.wikipedia.org/wiki/CHIP-8
public enum Opcode: CustomStringConvertible {
    public typealias Address = UInt16
    public typealias Register = Int
    public typealias Constant = UInt8
    
    case CallMachineLanguageSubroutine(address: Address)    // 0NNN
    case ClearScreen                                        // 00E0
    case Return                                             // 00EE
    case JumpAbsolute(address: Address)                     // 1NNN
    case CallSubroutine(address: Address)                   // 2NNN
    case SkipIfEqualValue(x: Register, value: Constant)     // 3XNN
    case SkipIfNotEqualValue(x: Register, value: Constant)  // 4XNN
    case SkipIfEqualRegister(x: Register, y: Register)      // 5XY0
    case SetValue(x: Register, value: Constant)             // 6XNN
    case AddValue(x: Register, value: Constant)             // 7XNN
    case SetRegister(x: Register, y: Register)              // 8XY0
    case Or(x: Register, y: Register)                       // 8XY1
    case And(x: Register, y: Register)                      // 8XY2
    case Xor(x: Register, y: Register)                      // 8XY3
    case AddRegister(x: Register, y: Register)              // 8XY4
    case SubtractYFromX(x: Register, y: Register)           // 8XY5
    case ShiftRight(x: Register, y: Register)               // 8XY6
    case SubtractXFromY(x: Register, y: Register)           // 8XY7
    case ShiftLeft(x: Register, y: Register)                // 8XYE
    case SkipIfNotEqualRegister(x: Register, y: Register)   // 9XY0
    case SetIndex(address: Address)                         // ANNN
    case JumpRelative(address: Address)                     // BNNN
    case AndRandom(x: Register, value: Constant)            // CXNN
    case Draw(x: Register, y: Register, rows: Constant)     // DXYN
    case SkipIfKeyPressed(x: Register)                      // EX9E
    case SkipIfKeyNotPressed(x: Register)                   // EXA1
    case StoreDelayTimer(x: Register)                       // FX07
    case AwaitKeyPress(x: Register)                         // FX0A
    case SetDelayTimer(x: Register)                         // FX15
    case SetSoundTimer(x: Register)                         // FX18
    case AddIndex(x: Register)                              // FX1E
    case SetIndexFontCharacter(x: Register)                 // FX29
    case StoreBCD(x: Register)                              // FX33
    case WriteMemory(x: Register)                           // FX55
    case ReadMemory(x: Register)                            // FX65
    
    /// Returns the raw opcode value in big-endian byte order.
    public var rawOpcode: UInt16 {
        switch self {
        case let .CallMachineLanguageSubroutine(address):
            return address
        case .ClearScreen:
            return 0x00E0
        case .Return:
            return 0x00EE
        case let .JumpAbsolute(address):
            return (0x1 << 12) | address
        case let .CallSubroutine(address):
            return (0x2 << 12) | address
        case let .SkipIfEqualValue(x, value):
            return (0x3 << 12) | (UInt16(x) << 8) | UInt16(value)
        case let .SkipIfNotEqualValue(x, value):
            return (0x4 << 12) | (UInt16(x) << 8) | UInt16(value)
        case let .SkipIfEqualRegister(x, y):
            return (0x5 << 12) | (UInt16(x) << 8) | (UInt16(y) << 4)
        case let .SetValue(x, value):
            return (0x6 << 12) | (UInt16(x) << 8) | UInt16(value)
        case let .AddValue(x, value):
            return (0x7 << 12) | (UInt16(x) << 8) | UInt16(value)
        case let .SetRegister(x, y):
            return (0x8 << 12) | (UInt16(x) << 8) | (UInt16(y) << 8)
        case let .Or(x, y):
            return (0x8 << 12) | (UInt16(x) << 8) | (UInt16(y) << 8) | 0x1
        case let .And(x, y):
            return (0x8 << 12) | (UInt16(x) << 8) | (UInt16(y) << 8) | 0x2
        case let .Xor(x, y):
            return (0x8 << 12) | (UInt16(x) << 8) | (UInt16(y) << 8) | 0x3
        case let .AddRegister(x, y):
            return (0x8 << 12) | (UInt16(x) << 8) | (UInt16(y) << 8) | 0x4
        case let .SubtractYFromX(x, y):
            return (0x8 << 12) | (UInt16(x) << 8) | (UInt16(y) << 8) | 0x5
        case let .ShiftRight(x, y):
            return (0x8 << 12) | (UInt16(x) << 8) | (UInt16(y) << 8) | 0x6
        case let .SubtractXFromY(x, y):
            return (0x8 << 12) | (UInt16(x) << 8) | (UInt16(y) << 8) | 0x7
        case let .ShiftLeft(x, y):
            return (0x8 << 12) | (UInt16(x) << 8) | (UInt16(y) << 8) | 0xE
        case let .SkipIfNotEqualRegister(x, y):
            return (0x9 << 12) | (UInt16(x) << 8) | (UInt16(y) << 8)
        case let .SetIndex(address):
            return (0xA << 12) | address
        case let .JumpRelative(address):
            return (0xB << 12) | address
        case let .AndRandom(x, value):
            return (0xC << 12) | (UInt16(x) << 8) | UInt16(value)
        case let .Draw(x, y, rows):
            return (0xD << 12) | (UInt16(x) << 8) | (UInt16(y) << 8) | UInt16(rows)
        case let .SkipIfKeyPressed(x):
            return (0xE << 12) | (UInt16(x) << 8) | 0x9E
        case let .SkipIfKeyNotPressed(x):
            return (0xE << 12) | (UInt16(x) << 8) | 0xA1
        case let .StoreDelayTimer(x):
            return (0xF << 12) | (UInt16(x) << 8) | 0x7
        case let .AwaitKeyPress(x):
            return (0xF << 12) | (UInt16(x) << 8) | 0xA
        case let .SetDelayTimer(x):
            return (0xF << 12) | (UInt16(x) << 8) | 0x15
        case let .SetSoundTimer(x):
            return (0xF << 12) | (UInt16(x) << 8) | 0x18
        case let .AddIndex(x):
            return (0xF << 12) | (UInt16(x) << 8) | 0x1E
        case let .SetIndexFontCharacter(x):
            return (0xF << 12) | (UInt16(x) << 8) | 0x29
        case let .StoreBCD(x):
            return (0xF << 12) | (UInt16(x) << 8) | 0x33
        case let .WriteMemory(x):
            return (0xF << 12) | (UInt16(x) << 8) | 0x55
        case let .ReadMemory(x):
            return (0xF << 12) | (UInt16(x) << 8) | 0x65
        }
    }
    
    /// Returns an human readable English description of the instruction 
    /// associated with the opcode.
    public var textualDescription: String {
        switch self {
        case let .CallMachineLanguageSubroutine(address):
            return "Calls the machine language subroutine at 0x\(hex(address))"
        case .ClearScreen:
            return "Clears the screen"
        case .Return:
            return "Returns from a subroutine"
        case let .JumpAbsolute(address):
            return "Jumps to address 0x\(hex(address))"
        case let .CallSubroutine(address):
            return "Calls subroutine at 0x\(hex(address))"
        case let .SkipIfEqualValue(x, value):
            return "Skips the next rawOpcode if V\(hex(x)) equals \(value)"
        case let .SkipIfNotEqualValue(x, value):
            return "Skips the next rawOpcode if V\(hex(x)) doesn't equal \(value)"
        case let .SkipIfEqualRegister(x, y):
            return "Skips the next rawOpcode if V\(hex(x)) equals V\(hex(y))"
        case let .SetValue(x, value):
            return "Sets V\(hex(x)) to \(value)"
        case let .AddValue(x, value):
            return "Adds \(value) to V\(hex(x))"
        case let .SetRegister(x, y):
            return "Sets V\(hex(x)) to the value of V\(hex(y))"
        case let .Or(x, y):
            return "Sets V\(hex(x)) to V\(hex(x)) OR V\(hex(y))"
        case let .And(x, y):
            return "Sets V\(hex(x)) to V\(hex(x)) AND V\(hex(y))"
        case let .Xor(x, y):
            return "Sets V\(hex(x)) to V\(hex(x)) XOR V\(hex(y))"
        case let .AddRegister(x, y):
            return "Adds V\(hex(y)) to V\(hex(x)). VF = carry bit"
        case let .SubtractYFromX(x, y):
            return "Set V\(hex(x)) to V\(hex(x)) - V\(hex(y)). VF = borrow bit"
        case let .ShiftRight(x, y: _):
            return "Shift V\(hex(x)) right by 1. VF = LSB of V\(hex(x)) before shift"
        case let .SubtractXFromY(x, y):
            return "Set V\(hex(x)) to V\(hex(y)) - V\(hex(x)). VF = borrow bit"
        case let .ShiftLeft(x, y: _):
            return "Shift V\(hex(x)) left by 1. VF = MSB of V\(hex(x)) before shift"
        case let .SkipIfNotEqualRegister(x, y):
            return "Skips the next rawOpcode if V\(hex(x)) doesn't equal V\(hex(y))"
        case let .SetIndex(address):
            return "Sets I to the address 0x\(hex(address))"
        case let .JumpRelative(address):
            return "Jumps to the address 0x\(hex(address)) + V0"
        case let .AndRandom(x, value):
            return "Sets V\(hex(x)) to <random number> AND \(value)"
        case let .Draw(x, y, rows):
            return "Draws sprites starting at (V\(hex(x)), V\(hex(y))) for \(rows) rows"
        case let .SkipIfKeyPressed(x):
            return "Skips the next rawOpcode if the key stored in V\(hex(x)) is pressed"
        case let .SkipIfKeyNotPressed(x):
            return "Skips the next rawOpcode if the key stored in V\(hex(x)) is not pressed"
        case let .StoreDelayTimer(x):
            return "Stores the value of the delay timer in V\(hex(x))"
        case let .AwaitKeyPress(x):
            return "Await a key press and store it in V\(hex(x))"
        case let .SetDelayTimer(x):
            return "Sets the delay timer to V\(hex(x))"
        case let .SetSoundTimer(x):
            return "Sets the sound timer to V\(hex(x))"
        case let .AddIndex(x):
            return "Adds V\(hex(x)) to I"
        case let .SetIndexFontCharacter(x):
            return "Sets I to the location of the sprite for the character in V\(hex(x))"
        case let .StoreBCD(x):
            return "Store the Binary-coded decimal representation of V\(hex(x)) in V\(hex(x))"
        case let .WriteMemory(x):
            return "Stores V0 to V\(hex(x)) in memory starting at address I"
        case let .ReadMemory(x):
            return "Fills V0 to V\(hex(x)) with values from memory starting at address I"
        }
    }
    
    public var description: String {
        return "Opcode{code=0x\(hex(rawOpcode)), description=\(textualDescription)}"
    }
    
    /// Initializes the receiver with a raw opcode in big-endian byte order.
    public init?(rawOpcode: UInt16) {
        let nib1 = UInt8((rawOpcode & 0xF000) >> 12)
        let nib2 = UInt8((rawOpcode & 0x0F00) >> 8)
        let nib3 = UInt8((rawOpcode & 0x00F0) >> 4)
        let nib4 = UInt8(rawOpcode & 0x000F)
        
        switch (nib1, nib2, nib3, nib4) {
        case (0x0, 0x0, 0xE, 0x0):
            self = .ClearScreen
        case (0x0, 0x0, 0xE, 0xE):
            self = .Return
        case (0x0, _, _, _):
            self = .CallMachineLanguageSubroutine(address: rawOpcode & 0xFFF)
        case (0x1, _, _, _):
            self = .JumpAbsolute(address: rawOpcode & 0xFFF)
        case (0x2, _, _, _):
            self = .CallSubroutine(address: rawOpcode & 0xFFF)
        case let (0x3, x, _, _):
            self = .SkipIfEqualValue(x: Int(x), value: UInt8(rawOpcode & 0xFF))
        case let (0x4, x, _, _):
            self = .SkipIfNotEqualValue(x: Int(x), value: UInt8(rawOpcode & 0xFF))
        case let (0x5, x, y, 0x0):
            self = .SkipIfEqualRegister(x: Int(x), y: Int(y))
        case let (0x6, x, _, _):
            self = .SetValue(x: Int(x), value: UInt8(rawOpcode & 0xFF))
        case let (0x7, x, _, _):
            self = .AddValue(x: Int(x), value: UInt8(rawOpcode & 0xFF))
        case let (0x8, x, y, 0x0):
            self = .SetRegister(x: Int(x), y: Int(y))
        case let (0x8, x, y, 0x1):
            self = .Or(x: Int(x), y: Int(y))
        case let (0x8, x, y, 0x2):
            self = .And(x: Int(x), y: Int(y))
        case let (0x8, x, y, 0x3):
            self = .Xor(x: Int(x), y: Int(y))
        case let (0x8, x, y, 0x4):
            self = .AddRegister(x: Int(x), y: Int(y))
        case let (0x8, x, y, 0x5):
            self = .SubtractYFromX(x: Int(x), y: Int(y))
        case let (0x8, x, y, 0x6):
            self = .ShiftRight(x: Int(x), y: Int(y))
        case let (0x8, x, y, 0x7):
            self = .SubtractXFromY(x: Int(x), y: Int(y))
        case let (0x8, x, y, 0xE):
            self = .ShiftLeft(x: Int(x), y: Int(y))
        case let (0x9, x, y, 0x0):
            self = .SkipIfNotEqualRegister(x: Int(x), y: Int(y))
        case (0xA, _, _, _):
            self = .SetIndex(address: rawOpcode & 0xFFF)
        case (0xB, _, _, _):
            self = .JumpRelative(address: rawOpcode & 0xFFF)
        case let (0xC, x, _, _):
            self = .AndRandom(x: Int(x), value: UInt8(rawOpcode & 0xFF))
        case let (0xD, x, y, rows):
            self = .Draw(x: Int(x), y: Int(y), rows: rows)
        case let (0xE, x, 0x9, 0xE):
            self = .SkipIfKeyPressed(x: Int(x))
        case let (0xE, x, 0xA, 0x1):
            self = .SkipIfKeyNotPressed(x: Int(x))
        case let (0xF, x, 0x0, 0x7):
            self = .StoreDelayTimer(x: Int(x))
        case let (0xF, x, 0x0, 0xA):
            self = .AwaitKeyPress(x: Int(x))
        case let (0xF, x, 0x1, 0x5):
            self = .SetDelayTimer(x: Int(x))
        case let (0xF, x, 0x1, 0x8):
            self = .SetSoundTimer(x: Int(x))
        case let (0xF, x, 0x1, 0xE):
            self = .AddIndex(x: Int(x))
        case let (0xF, x, 0x2, 0x9):
            self = .SetIndexFontCharacter(x: Int(x))
        case let (0xF, x, 0x3, 0x3):
            self = .StoreBCD(x: Int(x))
        case let (0xF, x, 0x5, 0x5):
            self = .WriteMemory(x: Int(x))
        case let (0xF, x, 0x6, 0x5):
            self = .ReadMemory(x: Int(x))
        default:
            return nil
        }
    }
}
