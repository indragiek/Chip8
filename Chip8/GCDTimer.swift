//  Copyright © 2015 Indragie Karunaratne. All rights reserved.

import Dispatch

final class GCDTimer {
    private let timer: dispatch_source_t
    private let interval: Int64
    
    init(interval: Double, queue: dispatch_queue_t, handler: dispatch_block_t) {
        timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue)
        self.interval = Int64(interval * Double(NSEC_PER_SEC))
        dispatch_source_set_event_handler(timer, handler)
    }
    
    func resume() {
        dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, interval), UInt64(interval), 0)
        dispatch_resume(timer)
    }
    
    func suspend() {
        dispatch_suspend(timer)
    }
    
    deinit {
        dispatch_source_cancel(timer)
    }
}
