//
//  AppDelegate.swift
//  Chip8
//
//  Created by Indragie on 12/22/15.
//  Copyright © 2015 Indragie Karunaratne. All rights reserved.
//

import Cocoa
import Chip8Kit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var chip8View: Chip8View!

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        if let data = NSData(contentsOfFile: "/Users/Karunaratne/Downloads/c8games/INVADERS") {
            chip8View.loadROM(data)
        }
    }
}

