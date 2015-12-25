//  Copyright © 2015 Indragie Karunaratne. All rights reserved.

import Dispatch

final class GCDTimer {
    private let timer: dispatch_source_t
    private var suspended = true
    
    /// The interval in seconds for the timer to fire on. This can be changed
    /// while the timer is running.
    var interval: Double {
        didSet { setTimer() }
    }
    
    /// Initializes a timer that calls `handler` on `queue` every `interval`
    /// seconds.
    init(interval: Double, queue: dispatch_queue_t, handler: dispatch_block_t) {
        timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue)
        dispatch_source_set_event_handler(timer, handler)
        self.interval = interval
    }
    
    /// Resumes the timer. Does nothing if the timer is already running.
    func resume() {
        guard suspended else { return }
        
        setTimer()
        dispatch_resume(timer)
        suspended = false
    }
    
    /// Suspends the timer. Does nothing if the timer is already suspended.
    func suspend() {
        guard !suspended else { return }
        
        dispatch_suspend(timer)
        suspended = true
    }
    
    private func setTimer() {
        let nsec = Int64(interval * Double(NSEC_PER_SEC))
        dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, nsec), UInt64(nsec), 0)
    }
    
    deinit {
        dispatch_source_cancel(timer)
        // Timers need to be resumed before deallocating.
        if suspended { resume() }
    }
}
