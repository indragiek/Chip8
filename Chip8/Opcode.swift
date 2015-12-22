//  Copyright © 2015 Indragie Karunaratne. All rights reserved.

import Foundation

// From https://en.wikipedia.org/wiki/CHIP-8
public enum Opcode {
    public typealias Address = Int16
    public typealias Register = Int8
    public typealias Constant = Int8
    
    case ClearScreen                                        // 00E0
    case Return(address: Address)                           // 00EE
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
}