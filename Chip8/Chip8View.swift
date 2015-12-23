//  Copyright © 2015 Indragie Karunaratne. All rights reserved.

import Cocoa
import CoreVideo
import Chip8Kit

public final class Chip8View: NSView {
    private var state: Emulator.State?
    private var timer: DisplayTimer?
    private var emulator: Emulator?
    
    public func loadROM(romData: NSData) {
        timer?.stop()
        emulator = Emulator(romData: romData.byteArray)
        if window != nil {
            timer?.start()
        }
    }
    
    // MARK: Rendering
    
    public override func drawRect(dirtyRect: NSRect) {
        guard let screen = state?.screen else { return }
        
        let rows = Emulator.Hardware.ScreenRows
        let columns = Emulator.Hardware.ScreenColumns
        let pixelDim = floor(bounds.width / CGFloat(columns))
        
        for y in 0..<rows {
            for x in 0..<columns {
                let pixel = screen[(y * columns) + x]
                let color: NSColor = (pixel == 1) ? .whiteColor() : .blackColor()
                let rect = NSRect(
                    x: CGFloat(x) * pixelDim,
                    y: CGFloat(y) * pixelDim,
                    width: pixelDim,
                    height: pixelDim
                )
                color.set()
                NSRectFill(rect)
            }
        }
    }
    
    public override var flipped: Bool {
        return true
    }
    
    private func render() {
        guard let emulator = emulator else { return }
        do {
            let state = try emulator.emulateCycle()
            self.state = state
            
            if state.redraw {
                display()
            }
            if state.beep {
                NSBeep()
            }
        } catch let error {
            fatalError("Emulation error: \(error)")
        }
    }
    
    // MARK: Display Timer
    
    public override func viewWillMoveToWindow(newWindow: NSWindow?) {
        super.viewWillMoveToWindow(newWindow)
        
        let nc = NSNotificationCenter.defaultCenter()
        if let window = window {
            nc.removeObserver(self, name: NSWindowDidChangeScreenNotification, object: window)
        }
        
        timer?.stop()
        
        if let newWindow = newWindow {
            nc.addObserver(self, selector: "windowChangedScreen:", name: NSWindowDidChangeScreenNotification, object: newWindow)
            if let screen = newWindow.screen {
                setupTimerForScreen(screen)
            }
        }
    }
    
    public override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        
        if window != nil {
            timer?.start()
        }
    }
    
    private func setupTimerForScreen(screen: NSScreen) {
        if let displayID = screen.displayID where displayID.has60FpsRefreshRate {
            do {
                try setupCVDisplayLinkTimer(displayID: displayID)
            } catch _ {
                setupGCDTimer()
            }
        } else {
            setupGCDTimer()
        }
    }
    
    private func setupCVDisplayLinkTimer(displayID displayID: CGDirectDisplayID) throws {
        timer = try CVDisplayLinkTimer(displayID: displayID) {
            dispatch_async(dispatch_get_main_queue()) {
                self.render()
            }
        }
    }
    
    private func setupGCDTimer() {
        timer = GCDDisplayTimer(refreshRate: Emulator.Hardware.RefreshRate) {
            self.render()
        }
    }
    
    @objc private func windowChangedScreen(notification: NSNotification) {
        timer?.stop()
        if let screen = window?.screen {
            setupTimerForScreen(screen)
            timer?.start()
        }
    }
}

private extension CGDirectDisplayID {
    var has60FpsRefreshRate: Bool {
        let mode = CGDisplayCopyDisplayMode(self)
        let refreshRate = CGDisplayModeGetRefreshRate(mode)
        return (refreshRate <= 0.0) || (abs(refreshRate - 60.0) < DBL_EPSILON)
    }
}

private extension NSScreen {
    var displayID: CGDirectDisplayID? {
        return (deviceDescription["NSScreenNumber"] as? NSNumber).flatMap({ CGDirectDisplayID($0.intValue) })
    }
}
