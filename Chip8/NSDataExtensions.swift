//  Copyright © 2015 Indragie Karunaratne. All rights reserved.

import Foundation

extension NSData {
    var byteArray: [UInt8] {
        let bytesPtr = unsafeBitCast(bytes, UnsafePointer<UInt8>.self)
        let bytesBufferPtr = UnsafeBufferPointer(start: bytesPtr, count: length)
        return Array(bytesBufferPtr)
    }
}