//  Copyright © 2015 Indragie Karunaratne. All rights reserved.

import Foundation

final class GCDDisplayTimer: DisplayTimer {
    private let timer: dispatch_source_t
    
    var isSynchronizedWithDisplay: Bool { return false }
    
    init(refreshRate: Double, queue: dispatch_queue_t = dispatch_get_main_queue(), callback: Void -> Void) {
        timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue)
        let interval = Int64((1 / refreshRate) * Double(NSEC_PER_SEC))
        dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, interval), UInt64(interval), 0)
        dispatch_source_set_event_handler(timer, callback)
    }
    
    func start() {
        dispatch_resume(timer)
    }
    
    func stop() {
        dispatch_suspend(timer)
    }
}
