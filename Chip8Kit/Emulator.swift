//  Copyright © 2015 Indragie Karunaratne. All rights reserved.

#if os(Linux)
    import Glibc
#else
    import Darwin
#endif

// From http://www.multigesture.net/articles/how-to-write-an-emulator-chip-8-interpreter/
private let FontSet: [UInt8] = [
    0xF0, 0x90, 0x90, 0x90, 0xF0, // 0
    0x20, 0x60, 0x20, 0x20, 0x70, // 1
    0xF0, 0x10, 0xF0, 0x80, 0xF0, // 2
    0xF0, 0x10, 0xF0, 0x10, 0xF0, // 3
    0x90, 0x90, 0xF0, 0x10, 0x10, // 4
    0xF0, 0x80, 0xF0, 0x10, 0xF0, // 5
    0xF0, 0x80, 0xF0, 0x90, 0xF0, // 6
    0xF0, 0x10, 0x20, 0x40, 0x40, // 7
    0xF0, 0x90, 0xF0, 0x90, 0xF0, // 8
    0xF0, 0x90, 0xF0, 0x10, 0xF0, // 9
    0xF0, 0x90, 0xF0, 0x90, 0x90, // A
    0xE0, 0x90, 0xE0, 0x90, 0xE0, // B
    0xF0, 0x80, 0x80, 0x80, 0xF0, // C
    0xE0, 0x90, 0x90, 0x90, 0xE0, // D
    0xF0, 0x80, 0xF0, 0x80, 0xF0, // E
    0xF0, 0x80, 0xF0, 0x80, 0x80  // F
]

/// Emulates the CHIP-8 virtual machine.
public final class Emulator {
    public enum Error: ErrorType {
        case UnrecognizedOpcode(UInt16)
    }
    
    public struct Hardware {
        static let MemorySize = 4096
        static let NumberOfRegisters = 16
        static let StackSize = 16
        static let ProgramAddress: UInt16 = 0x200
        static let NumberOfKeys = 16
        
        public static let ScreenRows = 32
        public static let ScreenColumns = 64
        public static let ScreenSize = ScreenRows * ScreenColumns
        public static let TimerClockRate = 60.0
    }
    
    public struct State {
        public let screen: [UInt8]
        public let redraw: Bool
    }
    
    // Default keypad layout:
    // From http://devernay.free.fr/hacks/chip8/C8TECH10.HTM#keyboard
    // -----------------
    // | 1 | 2 | 3 | C |
    // -----------------
    // | 4 | 5 | 6 | D |
    // -----------------
    // | 7 | 8 | 9 | E |
    // -----------------
    // | A | 0 | B | F |
    // -----------------
    public enum Key: UInt8 {
        case Num0 = 0x0
        case Num1 = 0x1
        case Num2 = 0x2
        case Num3 = 0x3
        case Num4 = 0x4
        case Num5 = 0x5
        case Num6 = 0x6
        case Num7 = 0x7
        case Num8 = 0x8
        case Num9 = 0x9
        case A = 0xA
        case B = 0xB
        case C = 0xC
        case D = 0xD
        case E = 0xE
        case F = 0xF
    }
    
    private var memory: [UInt8] = {
        var memory = [UInt8](count: Hardware.MemorySize, repeatedValue: 0)
        memory.replaceRange(0..<FontSet.count, with: FontSet)
        return memory
    }()
    
    private var stack = [UInt16](count: Hardware.StackSize, repeatedValue: 0)
    private var V = [UInt8](count: Hardware.NumberOfRegisters, repeatedValue: 0)
    private var screen = [UInt8](count: Hardware.ScreenSize, repeatedValue: 0)
    private var I: UInt16 = 0                 // Index register
    private var sp = 0                        // Stack pointer
    private var pc = Hardware.ProgramAddress  // Program counter
    private var delayTimer: UInt8 = 0
    private var soundTimer: UInt8 = 0
    private var keypad = [Bool](count: Hardware.NumberOfKeys, repeatedValue: false)
    private var lastPressedKey: Key?
    
    /// Designated initializer. Initializes the receiver with the ROM
    /// containing the program to emulate.
    public init(rom: ROM) {
        memory.replaceRange(Int(pc)..<(Int(pc) + rom.bytes.count), with: rom.bytes)
    }
    
    /// Sets the pressed state for a key on the keypad.
    public func setState(pressed: Bool, forKey key: Key) {
        keypad[Int(key.rawValue)] = pressed
        if pressed {
            lastPressedKey = key
        }
    }
    
    /// Emulates a single clock cycle. This method should typically be called
    /// at a rate of 500Hz, according to: 
    /// https://github.com/AfBu/haxe-chip-8-emulator/wiki/(Super)CHIP-8-Secrets
    public func emulateCycle() throws -> State {
        let rawOpcode = (UInt16(memory[Int(pc)]) << 8) | UInt16(memory[Int(pc) + 1])
        guard let opcode = Opcode(rawOpcode: rawOpcode) else {
            throw Error.UnrecognizedOpcode(rawOpcode)
        }
        
        var incrementPC = true
        var redraw = false
        
        switch opcode {
        case .CallMachineLanguageSubroutine(address: _):
            // Not implemented
            break
        case .ClearScreen:
            screen = [UInt8](count: Hardware.ScreenSize, repeatedValue: 0)
            redraw = true
        case .Return:
            sp -= 1
            pc = stack[sp]
        case let .JumpAbsolute(address):
            pc = address
            incrementPC = false
        case let .CallSubroutine(address):
            stack[sp] = pc
            sp += 1
            pc = address
            incrementPC = false
        case let .SkipIfEqualValue(x, value):
            if V[x] == value { pc += 2 }
        case let .SkipIfNotEqualValue(x, value):
            if V[x] != value { pc += 2 }
        case let .SkipIfEqualRegister(x, y):
            if V[x] == V[y] { pc += 2 }
        case let .SetValue(x, value):
            V[x] = value
        case let .AddValue(x, value):
            V[x] = V[x] &+ value
        case let .SetRegister(x, y):
            V[x] = V[y]
        case let .Or(x, y):
            V[x] |= V[y]
        case let .And(x, y):
            V[x] &= V[y]
        case let .Xor(x, y):
            V[x] ^= V[y]
        case let .AddRegister(x, y):
            V[0xF] = (Int(V[x]) + Int(V[y]) > Int(UInt8.max)) ? 1 : 0
            V[x] = V[x] &+ V[y]
        case let .SubtractYFromX(x, y):
            V[0xF] = (V[x] < V[y]) ? 0 : 1
            V[x] = V[x] &- V[y]
        case let .ShiftRight(x, _):
            V[0xf] = V[x] & 1
            V[x] >>= 1
        case let .SubtractXFromY(x, y):
            V[0xF] = (V[y] < V[x]) ? 0 : 1
            V[x] = V[y] &- V[x]
        case let .ShiftLeft(x, _):
            V[0xF] = (V[x] & 0x80) >> 7
            V[x] <<= 1
        case let .SkipIfNotEqualRegister(x, y):
            if V[x] != V[y] { pc += 2 }
        case let .SetIndex(address):
            I = address
        case let .JumpRelative(address):
            pc = address + UInt16(V[0])
            incrementPC = false
        case let .AndRandom(x, value):
            V[x] = UInt8(rand() % UINT8_MAX) & value
        case let .Draw(x, y, rows):
            draw(xRegister: x, yRegister: y, rows: rows)
            redraw = true
        case let .SkipIfKeyPressed(x):
            if keypad[Int(V[x])] { pc += 2 }
        case let .SkipIfKeyNotPressed(x):
            if !keypad[Int(V[x])] { pc += 2 }
        case let .StoreDelayTimer(x):
            V[x] = delayTimer
        case let .AwaitKeyPress(x):
            if let key = lastPressedKey {
                V[x] = key.rawValue
                lastPressedKey = nil
            } else {
                return State(screen: screen, redraw: false)
            }
        case let .SetDelayTimer(x):
            delayTimer = V[x]
        case let .SetSoundTimer(x):
            soundTimer = V[x]
        case let .AddIndex(x):
            let value = UInt16(V[x])
            V[0xF] = ((value + I) > UInt16(0xFFF)) ? 1 : 0
            I += value
        case let .SetIndexFontCharacter(x):
            I = UInt16(V[x] * 5)
        case let .StoreBCD(x):
            storeBCD(x)
        case let .WriteMemory(x):
            for xi in 0...Int(x) {
                memory[Int(I) + xi] = V[xi]
            }
        case let .ReadMemory(x):
            for xi in 0...Int(x) {
                V[xi] = memory[Int(I) + xi]
            }
        }
        
        if incrementPC {
            pc += 2
        }
        return State(screen: screen, redraw: redraw)
    }
    
    /// Emulates a single timer tick. This should always be called at a rate
    /// of 60Hz regardless of the master clock rate.
    public func emulateTimerTick() -> Bool {
        if delayTimer > 0 {
            delayTimer -= 1
        }
        
        var beep = false
        if soundTimer > 0 {
            beep = soundTimer == 1
            soundTimer -= 1
        }
        return beep
    }
    
    private func draw(xRegister xRegister: Opcode.Register, yRegister: Opcode.Register, rows: Opcode.Constant) {
        let startX = Int(V[xRegister])
        let startY = Int(V[yRegister])
        
        V[0xF] = 0
        for y in 0..<Int(rows) {
            var pixelRow = memory[Int(I) + y]
            for x in 0..<8 {
                if (pixelRow & 0x80) != 0 {
                    let screenY = (startY + y) % Hardware.ScreenRows
                    let screenX = (startX + x) % Hardware.ScreenColumns
                    let screenIndex = (screenY * Hardware.ScreenColumns) + screenX
                    if screen[screenIndex] == 1 {
                        V[0xF] = 1
                    }
                    screen[screenIndex] ^= 1
                }
                pixelRow <<= 1
            }
        }
    }
    
    private func storeBCD(xRegister: Opcode.Register) {
        let x = V[xRegister]
        let address = Int(I)
        // From http://www.multigesture.net/wp-content/uploads/mirror/goldroad/chip8.shtml
        memory[address] = x / 100
        memory[address + 1] = (x / 10) % 10
        memory[address + 2] = (x % 100) % 10
    }
}
