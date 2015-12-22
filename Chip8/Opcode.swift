//  Copyright © 2015 Indragie Karunaratne. All rights reserved.

import Foundation

// From https://en.wikipedia.org/wiki/CHIP-8
public enum Opcode {
    public typealias Address = UInt16
    public typealias Register = UInt8
    public typealias Constant = UInt8
    public typealias RawOpcode = UInt16
    public typealias Instruction = (UInt8, UInt8)
    
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
    case Add(x: Register, y: Register)                      // 8XY4
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
    
    public var rawOpcode: RawOpcode {
        switch self {
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
        case .Add(x: let x, y: let y):
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
}