//  Copyright © 2015 Indragie Karunaratne. All rights reserved.

public struct Disassembler {
    public enum Error: ErrorType {
        case UnrecognizedOpcode(UInt16)
    }
    
    public static func disassemble(rom: ROM) throws -> [Opcode] {
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
    
    public static func printDisassembly(rom: ROM) throws {
        let opcodes = try disassemble(rom)
        
        print("ADDR  OP    DESCRIPTION")
        print("----  ----  -----------")
        for (index, opcode) in opcodes.enumerate() {
            let opaddr = hex(index * 2).zeroPrefix(4)
            let rawOpcode = hex(opcode.rawOpcode).zeroPrefix(4)
            print("\(opaddr)  \(rawOpcode)  \(opcode.textualDescription)")
        }
    }
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
