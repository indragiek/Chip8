//  Copyright © 2015 Indragie Karunaratne. All rights reserved.

import Cocoa
import Chip8Kit

class ViewController: NSViewController {
    
    @IBOutlet weak var chip8View: Chip8View!

    override func viewDidLoad() {
        super.viewDidLoad()
        chip8View.showsFPS = true
    }
    
    // MARK: Actions
    
    @IBAction func load(_: AnyObject) {
        chip8View.paused = true
        
        let panel = NSOpenPanel()
        panel.beginWithCompletionHandler { returnCode in
            defer { self.chip8View.paused = false }
            guard returnCode == NSFileHandlingPanelOKButton else { return }
            
            if let URL = panel.URL, path = URL.path {
                do {
                    self.chip8View.loadROM(try ROM(path: path))
                } catch let error {
                    print("Error loading ROM: \(error)")
                }
            }
        }
    }
    
    @IBAction func reset(_: AnyObject) {
        chip8View.reset()
    }
    
    @IBAction func pauseResume(sender: NSButton) {
        chip8View.paused = !chip8View.paused
        sender.title = chip8View.paused ? "Resume" : "Pause"
    }
    
    @IBAction func changedClockRate(sender: NSSlider) {
        chip8View.clockRate = sender.doubleValue
    }
}
