//  Copyright © 2015 Indragie Karunaratne. All rights reserved.

public final class Disassembler {
    public enum Error: ErrorType {
        case UnrecognizedOpcode(UInt16)
    }
    
    private let bytes: [UInt8]
    
    public init(bytes: [UInt8]) {
        self.bytes = bytes
    }
    
    public func disassemble() throws -> [Opcode] {
        var opcodes = [Opcode]()
        for i in 0..<(bytes.count - 1) {
            let rawOpcode = UInt16(bigEndian: UInt16(bytes[i]) << 8) | UInt16(bytes[i + 1])
            if let opcode = Opcode(rawOpcode: rawOpcode) {
                opcodes.append(opcode)
            } else {
                throw Error.UnrecognizedOpcode(rawOpcode)
            }
        }
        return opcodes
    }
}
