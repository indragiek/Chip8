//  Copyright © 2015 Indragie Karunaratne. All rights reserved.

import Cocoa
import Chip8Kit
import SpriteKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var chip8View: Chip8View!

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        do {
            let rom = try ROM(path: "/Users/Karunaratne/Downloads/c8games/BRIX")
            chip8View.loadROM(rom)
            chip8View.showsFPS = true
        } catch let error {
            print(error)
        }
    }
}
