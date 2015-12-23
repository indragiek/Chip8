//  Copyright © 2015 Indragie Karunaratne. All rights reserved.

import Cocoa
import CoreVideo
import Chip8Kit

public final class Chip8View: NSView {
    private var state: Emulator.State?
    private var timer: DisplayTimer?
    private let emulator: Emulator?
    
    public func loadROM(ROM: [UInt8]) {
    
    }
}

private extension NSData {
    var byteArray: [UInt8] {
        let bytesPtr = unsafeBitCast(bytes, UnsafePointer<UInt8>.self)
        let bytesBufferPtr = UnsafeBufferPointer(start: bytesPtr, count: length)
        return Array(bytesBufferPtr)
    }
}

private extension NSScreen {
    var displayID: CGDirectDisplayID? {
        return (deviceDescription["NSScreenNumber"] as? NSNumber).flatMap({ CGDirectDisplayID($0.intValue) })
    }
    
    var has60FpsRefreshRate: Bool {
        if let displayID = displayID {
            let mode = CGDisplayCopyDisplayMode(displayID)
            let refreshRate = CGDisplayModeGetRefreshRate(mode)
            return (refreshRate <= 0.0) || (abs(refreshRate - 60.0) < DBL_EPSILON)
        } else {
            return false
        }
    }
}
