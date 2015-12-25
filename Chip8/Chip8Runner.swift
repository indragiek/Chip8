//  Copyright © 2015 Indragie Karunaratne. All rights reserved.

import Chip8Kit

final class Chip8Runner {
    private var _screen: [UInt8]?
    var screen: [UInt8]? {
        return get { self._screen }
    }
    
    private var _redraw = false
    var redraw: Bool {
        get { return get { self._redraw } }
        set { set { self._redraw = newValue } }
    }
    
    private var _playBeep = false
    var playBeep: Bool {
        get { return get { self._playBeep } }
        set { set { self._playBeep = newValue } }
    }
    
    private func get<T>(block: Void -> T) -> T {
        var value: T?
        dispatch_sync(queue) {
            value = block()
        }
        return value!
    }
    
    private func set(block: Void -> Void) {
        dispatch_async(queue, block)
    }
    
    private let queue = dispatch_queue_create("com.indragie.Chip8.Chip8Runner", DISPATCH_QUEUE_SERIAL)
    private let emulator: Emulator
    
    private lazy var CPUTimer: GCDTimer = {
        GCDTimer(interval: 1 / self.clockRate, queue: self.queue) { [weak self] in
            guard let strongSelf = self else { return }
            do {
                let state = try strongSelf.emulator.emulateCycle()
                if state.redraw {
                    strongSelf._redraw = true
                }
                strongSelf._screen = state.screen
            } catch let error {
                fatalError("Emulation error: \(error)")
            }
        }
    }()
    private lazy var timerTimer: GCDTimer = {
        GCDTimer(interval: 1 / Emulator.Hardware.TimerClockRate, queue: self.queue) { [weak self] in
            guard let strongSelf = self else { return }
            
            if strongSelf.emulator.emulateTimerTick() {
                strongSelf._playBeep = true
            }
        }
    }()
    
    var clockRate: Double {
        didSet { self.CPUTimer.interval = 1 / clockRate }
    }
    
    // https://github.com/AfBu/haxe-chip-8-emulator/wiki/(Super)CHIP-8-Secrets
    init(emulator: Emulator, clockRate: Double = 500) {
        self.emulator = emulator
        self.clockRate = clockRate
    }
    
    func resume() {
        self.CPUTimer.resume()
        self.timerTimer.resume()
    }
    
    func suspend() {
        self.CPUTimer.suspend()
        self.timerTimer.suspend()
    }
    
    func setState(pressed: Bool, forKey key: Emulator.Key) {
        dispatch_async(queue) {
            self.emulator.setState(pressed, forKey: key)
        }
    }
}
