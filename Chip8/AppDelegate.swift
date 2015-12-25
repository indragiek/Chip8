//
//  AppDelegate.swift
//  Chip8
//
//  Created by Indragie on 12/22/15.
//  Copyright © 2015 Indragie Karunaratne. All rights reserved.
//

import Cocoa
import Chip8Kit
import SpriteKit
import Carbon

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var chip8View: SKView!

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        if let data = NSData(contentsOfFile: "/Users/Karunaratne/Downloads/c8games/INVADERS") {
            let emulator = Emulator(romData: data.byteArray)
            let scene = Chip8Scene(size: chip8View.bounds.size, emulator: emulator)
            chip8View.showsFPS = true
            chip8View.presentScene(scene)
        }
    }
}

