//  Copyright © 2015 Indragie Karunaratne. All rights reserved.

import Cocoa
import Chip8Kit
import SpriteKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    private var windowController: NSWindowController!

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        windowController = NSWindowController(window: window)
        windowController.contentViewController = ViewController(nibName: nil, bundle: nil)
        windowController.showWindow(nil)
    }
}
