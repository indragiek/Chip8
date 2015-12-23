//  Copyright © 2015 Indragie Karunaratne. All rights reserved.

import Foundation

public extension Disassembler {
    public convenience init?(data: NSData) {
        let bytesVoidPtr = data.bytes
        if bytesVoidPtr == nil {
            return nil
        } else {
            let bytesPtr = unsafeBitCast(bytesVoidPtr, UnsafePointer<UInt8>.self)
            let bytesBufferPtr = UnsafeBufferPointer(start: bytesPtr, count: data.length)
            self.init(bytes: Array(bytesBufferPtr))
        }
    }
}
