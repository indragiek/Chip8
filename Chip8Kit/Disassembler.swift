//  Copyright © 2015 Indragie Karunaratne. All rights reserved.

public final class Disassembler {
    public enum Error: ErrorType {
        case UnrecognizedOpcode(UInt16)
    }
    
    private let rom: ROM
    
    public init(rom: ROM) {
        self.rom = rom
    }
    
    public func disassemble() throws -> [Opcode] {
        var opcodes = [Opcode]()
        for i in 0.stride(to: rom.bytes.count - 1, by: 2) {
            let rawOpcode = (UInt16(rom.bytes[i]) << 8) | UInt16(rom.bytes[i + 1])
            if let opcode = Opcode(rawOpcode: rawOpcode) {
                opcodes.append(opcode)
            } else {
                throw Error.UnrecognizedOpcode(rawOpcode)
            }
        }
        return opcodes
    }
}
