//  Copyright © 2015 Indragie Karunaratne. All rights reserved.

import CoreVideo

final class CVDisplayLinkTimer: DisplayTimer {
    enum Error: ErrorType {
        case CoreVideoError(CVReturn)
    }
    
    private let callback: Void -> Void
    private var displayLink: CVDisplayLinkRef!
    
    var isSynchronizedWithDisplay: Bool { return true }
    
    init(displayID: CGDirectDisplayID, callback: Void -> Void) throws {
        self.callback = callback
        
        var displayLink: CVDisplayLinkRef?
        let returnCode = CVDisplayLinkCreateWithCGDisplay(displayID, &displayLink)
        
        if let displayLink = displayLink {
            CVDisplayLinkSetOutputCallback(displayLink, { (_, _, _, _, _, context) in
                let timer = unsafeBitCast(context, CVDisplayLinkTimer.self)
                timer.callback()
                return kCVReturnSuccess
                }, UnsafeMutablePointer<Void>(unsafeAddressOf(self)))
            self.displayLink = displayLink
        } else {
            throw Error.CoreVideoError(returnCode)
        }
    }
    
    func start() {
        CVDisplayLinkStart(displayLink)
    }
    
    func stop() {
        CVDisplayLinkStop(displayLink)
    }
}
