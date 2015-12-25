//  Copyright © 2015 Indragie Karunaratne. All rights reserved.

import Cocoa

protocol Sound {
    func playSound()
}

struct NSBeepSound: Sound {
    func playSound() {
        NSBeep()
    }
}

extension NSSound: Sound {
    func playSound() {
        play()
    }
}
