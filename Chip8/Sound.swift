//  Copyright © 2015 Indragie Karunaratne. All rights reserved.

import Cocoa

/// A sound clip that can be played.
protocol Sound {
    func playSound()
}

/// The system beep sound (configurable via System Preferences)
struct NSBeepSound: Sound {
    func playSound() {
        NSBeep()
    }
}

/// `NSSound` can be used to load audio from data or a file.
extension NSSound: Sound {
    func playSound() {
        play()
    }
}
