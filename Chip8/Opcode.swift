//  Copyright © 2015 Indragie Karunaratne. All rights reserved.

public protocol OpcodeType {
    var rawOpcode: UInt16 { get }
    var textualDescription: String { get }
}

// From https://en.wikipedia.org/wiki/CHIP-8
public enum Opcode: OpcodeType, CustomStringConvertible {
    public typealias Address = UInt16
    public typealias Register = UInt8
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
    
    public var rawOpcode: UInt16 {
        switch self {
        case CallMachineLanguageSubroutine(address: let addr):
            return addr
        case .ClearScreen:
            return 0x00E0
        case .Return:
            return 0x00EE
        case .JumpAbsolute(address: let addr):
            return (0x1 << 12) | addr
        case .CallSubroutine(address: let addr):
            return (0x2 << 12) | addr
        case .SkipIfEqualValue(x: let x, value: let value):
            return (0x3 << 12) | (UInt16(x) << 8) | UInt16(value)
        case .SkipIfNotEqualValue(x: let x, value: let value):
            return (0x4 << 12) | (UInt16(x) << 8) | UInt16(value)
        case .SkipIfEqualRegister(x: let x, y: let y):
            return (0x5 << 12) | (UInt16(x) << 8) | (UInt16(y) << 4)
        case .SetValue(x: let x, value: let value):
            return (0x6 << 12) | (UInt16(x) << 8) | UInt16(value)
        case .AddValue(x: let x, value: let value):
            return (0x7 << 12) | (UInt16(x) << 8) | UInt16(value)
        case .SetRegister(x: let x, y: let y):
            return (0x8 << 12) | (UInt16(x) << 8) | (UInt16(y) << 8)
        case .Or(x: let x, y: let y):
            return (0x8 << 12) | (UInt16(x) << 8) | (UInt16(y) << 8) | 0x1
        case .And(x: let x, y: let y):
            return (0x8 << 12) | (UInt16(x) << 8) | (UInt16(y) << 8) | 0x2
        case .Xor(x: let x, y: let y):
            return (0x8 << 12) | (UInt16(x) << 8) | (UInt16(y) << 8) | 0x3
        case .AddRegister(x: let x, y: let y):
            return (0x8 << 12) | (UInt16(x) << 8) | (UInt16(y) << 8) | 0x4
        case .SubtractYFromX(x: let x, y: let y):
            return (0x8 << 12) | (UInt16(x) << 8) | (UInt16(y) << 8) | 0x5
        case .ShiftRight(x: let x, y: let y):
            return (0x8 << 12) | (UInt16(x) << 8) | (UInt16(y) << 8) | 0x6
        case .SubtractXFromY(x: let x, y: let y):
            return (0x8 << 12) | (UInt16(x) << 8) | (UInt16(y) << 8) | 0x7
        case .ShiftLeft(x: let x, y: let y):
            return (0x8 << 12) | (UInt16(x) << 8) | (UInt16(y) << 8) | 0xE
        case .SkipIfNotEqualRegister(x: let x, y: let y):
            return (0x9 << 12) | (UInt16(x) << 8) | (UInt16(y) << 8)
        case .SetIndex(address: let addr):
            return (0xA << 12) | addr
        case .JumpRelative(address: let addr):
            return (0xB << 12) | addr
        case .AndRandom(x: let x, value: let value):
            return (0xC << 12) | (UInt16(x) << 8) | UInt16(value)
        case .Draw(x: let x, y: let y, rows: let rows):
            return (0xD << 12) | (UInt16(x) << 8) | (UInt16(y) << 8) | UInt16(rows)
        case .SkipIfKeyPressed(x: let x):
            return (0xE << 12) | (UInt16(x) << 8) | 0x9E
        case .SkipIfKeyNotPressed(x: let x):
            return (0xE << 12) | (UInt16(x) << 8) | 0xA1
        case .StoreDelayTimer(x: let x):
            return (0xF << 12) | (UInt16(x) << 8) | 0x7
        case .AwaitKeyPress(x: let x):
            return (0xF << 12) | (UInt16(x) << 8) | 0xA
        case .SetDelayTimer(x: let x):
            return (0xF << 12) | (UInt16(x) << 8) | 0x15
        case .SetSoundTimer(x: let x):
            return (0xF << 12) | (UInt16(x) << 8) | 0x18
        case .AddIndex(x: let x):
            return (0xF << 12) | (UInt16(x) << 8) | 0x1E
        case .SetIndexFontCharacter(x: let x):
            return (0xF << 12) | (UInt16(x) << 8) | 0x29
        case .StoreBCD(x: let x):
            return (0xF << 12) | (UInt16(x) << 8) | 0x33
        case .WriteMemory(x: let x):
            return (0xF << 12) | (UInt16(x) << 8) | 0x55
        case .ReadMemory(x: let x):
            return (0xF << 12) | (UInt16(x) << 8) | 0x65
        }
    }
    
    public var textualDescription: String {
        switch self {
        case CallMachineLanguageSubroutine(address: let addr):
            return "Calls the machine language subroutine at 0x\(hex(addr))"
        case .ClearScreen:
            return "Clears the screen"
        case .Return:
            return "Returns from a subroutine"
        case .JumpAbsolute(address: let addr):
            return "Jumps to address 0x\(hex(addr))"
        case .CallSubroutine(address: let addr):
            return "Calls subroutine at 0x\(hex(addr))"
        case .SkipIfEqualValue(x: let x, value: let value):
            return "Skips the next rawOpcode if V\(hex(x)) equals \(value)"
        case .SkipIfNotEqualValue(x: let x, value: let value):
            return "Skips the next rawOpcode if V\(hex(x)) doesn't equal \(value)"
        case .SkipIfEqualRegister(x: let x, y: let y):
            return "Skips the next rawOpcode if V\(hex(x)) equals V\(hex(y))"
        case .SetValue(x: let x, value: let value):
            return "Sets V\(hex(x)) to \(value)"
        case .AddValue(x: let x, value: let value):
            return "Adds \(value) to V\(hex(x))"
        case .SetRegister(x: let x, y: let y):
            return "Sets V\(hex(x)) to the value of V\(hex(y))"
        case .Or(x: let x, y: let y):
            return "Sets V\(hex(x)) to V\(hex(x)) OR V\(hex(y))"
        case .And(x: let x, y: let y):
            return "Sets V\(hex(x)) to V\(hex(x)) AND V\(hex(y))"
        case .Xor(x: let x, y: let y):
            return "Sets V\(hex(x)) to V\(hex(x)) XOR V\(hex(y))"
        case .AddRegister(x: let x, y: let y):
            return "Adds V\(hex(y)) to V\(hex(x)). VF = carry bit"
        case .SubtractYFromX(x: let x, y: let y):
            return "Set V\(hex(x)) to V\(hex(x)) - V\(hex(y)). VF = borrow bit"
        case .ShiftRight(x: let x, y: _):
            return "Shift V\(hex(x)) right by 1. VF = LSB of V\(hex(x)) before shift"
        case .SubtractXFromY(x: let x, y: let y):
            return "Set V\(hex(x)) to V\(hex(y)) - V\(hex(x)). VF = borrow bit"
        case .ShiftLeft(x: let x, y: _):
            return "Shift V\(hex(x)) left by 1. VF = MSB of V\(hex(x)) before shift"
        case .SkipIfNotEqualRegister(x: let x, y: let y):
            return "Skips the next rawOpcode if V\(hex(x)) doesn't equal V\(hex(y))"
        case .SetIndex(address: let addr):
            return "Sets I to the address 0x\(hex(addr))"
        case .JumpRelative(address: let addr):
            return "Jumps to the address 0x\(hex(addr)) + V0"
        case .AndRandom(x: let x, value: let value):
            return "Sets V\(hex(x)) to <random number> AND \(value)"
        case .Draw(x: let x, y: let y, rows: let rows):
            return "Draws sprites starting at (V\(hex(x)), V\(hex(y))) for \(rows) rows"
        case .SkipIfKeyPressed(x: let x):
            return "Skips the next rawOpcode if the key stored in V\(hex(x)) is pressed"
        case .SkipIfKeyNotPressed(x: let x):
            return "Skips the next rawOpcode if the key stored in V\(hex(x)) is not pressed"
        case .StoreDelayTimer(x: let x):
            return "Stores the value of the delay timer in V\(hex(x))"
        case .AwaitKeyPress(x: let x):
            return "Await a key press and store it in V\(hex(x))"
        case .SetDelayTimer(x: let x):
            return "Sets the delay timer to V\(hex(x))"
        case .SetSoundTimer(x: let x):
            return "Sets the sound timer to V\(hex(x))"
        case .AddIndex(x: let x):
            return "Adds V\(hex(x)) to I"
        case .SetIndexFontCharacter(x: let x):
            return "Sets I to the location of the sprite for the character in V\(hex(x))"
        case .StoreBCD(x: let x):
            return "Store the Binary-coded decimal representation of V\(hex(x)) in V\(hex(x))"
        case .WriteMemory(x: let x):
            return "Stores V0 to V\(hex(x)) in memory starting at address I"
        case .ReadMemory(x: let x):
            return "Fills V0 to V\(hex(x)) with values from memory starting at address I"
        }
    }
    
    public var description: String {
        return "Opcode{code=0x\(hex(rawOpcode)), description=\(textualDescription)}"
    }
    
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
        case (0x3, let x, _, _):
            self = .SkipIfEqualValue(x: x, value: UInt8(rawOpcode & 0xFF))
        case (0x4, let x, _, _):
            self = .SkipIfNotEqualValue(x: x, value: UInt8(rawOpcode & 0xFF))
        case (0x5, let x, let y, 0x0):
            self = .SkipIfEqualRegister(x: x, y: y)
        case (0x6, let x, _, _):
            self = .SetValue(x: x, value: UInt8(rawOpcode & 0xFF))
        case (0x7, let x, _, _):
            self = .AddValue(x: x, value: UInt8(rawOpcode & 0xFF))
        case (0x8, let x, let y, 0x0):
            self = .SetRegister(x: x, y: y)
        case (0x8, let x, let y, 0x1):
            self = .Or(x: x, y: y)
        case (0x8, let x, let y, 0x2):
            self = .And(x: x, y: y)
        case (0x8, let x, let y, 0x3):
            self = .Xor(x: x, y: y)
        case (0x8, let x, let y, 0x4):
            self = .AddRegister(x: x, y: y)
        case (0x8, let x, let y, 0x5):
            self = .SubtractYFromX(x: x, y: y)
        case (0x8, let x, let y, 0x6):
            self = .ShiftRight(x: x, y: y)
        case (0x8, let x, let y, 0x7):
            self = .SubtractXFromY(x: x, y: y)
        case (0x8, let x, let y, 0xE):
            self = .ShiftLeft(x: x, y: y)
        case (0x9, let x, let y, 0x0):
            self = .SkipIfNotEqualRegister(x: x, y: y)
        case (0xA, _, _, _):
            self = .SetIndex(address: rawOpcode & 0xFFF)
        case (0xB, _, _, _):
            self = .JumpRelative(address: rawOpcode & 0xFFF)
        case (0xC, let x, _, _):
            self = .AndRandom(x: x, value: UInt8(rawOpcode & 0xFF))
        case (0xD, let x, let y, let rows):
            self = .Draw(x: x, y: y, rows: rows)
        case (0xE, let x, 0x9, 0xE):
            self = .SkipIfKeyPressed(x: x)
        case (0xE, let x, 0xA, 0x1):
            self = .SkipIfKeyNotPressed(x: x)
        case (0xF, let x, 0x0, 0x7):
            self = .StoreDelayTimer(x: x)
        case (0xF, let x, 0x0, 0xA):
            self = .AwaitKeyPress(x: x)
        case (0xF, let x, 0x1, 0x5):
            self = .SetDelayTimer(x: x)
        case (0xF, let x, 0x1, 0x8):
            self = .SetSoundTimer(x: x)
        case (0xF, let x, 0x1, 0xE):
            self = .AddIndex(x: x)
        case (0xF, let x, 0x2, 0x9):
            self = .SetIndexFontCharacter(x: x)
        case (0xF, let x, 0x3, 0x3):
            self = .StoreBCD(x: x)
        case (0xF, let x, 0x5, 0x5):
            self = .WriteMemory(x: x)
        case (0xF, let x, 0x6, 0x5):
            self = .ReadMemory(x: x)
        default:
            return nil
        }
    }
}

private func hex<T: UnsignedIntegerType>(value: T) -> String {
    return String(value, radix: 16).uppercaseString
}

private func hex<T: SignedIntegerType>(value: T) -> String {
    return String(value, radix: 16).uppercaseString
}

private extension String {
    func zeroPrefix(length: Int) -> String {
        let delta = length - characters.count
        if delta <= 0 {
            return self 
        } else {
            return (0..<delta).reduce("") { (str, _) in str + "0" } + self
        }
    }
}

extension SequenceType where Generator.Element: OpcodeType {
    public func printDisassembly() {
        var address: Int32 = 0
        print("ADDR  OP    DESCRIPTION")
        print("----  ----  -----------")
        for opcode in self {
            let opaddr = hex(address).zeroPrefix(4)
            let rawOpcode = hex(opcode.rawOpcode).zeroPrefix(4)
            print("\(opaddr)  \(rawOpcode)  \(opcode.textualDescription)")
            address += 2
        }
    }
}
