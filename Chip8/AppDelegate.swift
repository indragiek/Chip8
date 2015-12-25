//  Copyright © 2015 Indragie Karunaratne. All rights reserved.

import Cocoa
import Chip8Kit
import SpriteKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var chip8View: SKView!

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        if let data = NSData(contentsOfFile: "/Users/Karunaratne/Downloads/c8games/BRIX") {
            let emulator = Emulator(romData: data.byteArray)
            let runner = Chip8Runner(emulator: emulator)
            let scene = Chip8Scene(size: chip8View.bounds.size, runner: runner)
            chip8View.showsFPS = true
            chip8View.presentScene(scene)
        }
    }
}

