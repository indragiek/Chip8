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

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        do {
            if let data = NSData(contentsOfFile: "/Users/Karunaratne/Downloads/c8games/PONG") {
                let disassembler = Disassembler(bytes: data.byteArray)
                try disassembler.disassemble().printDisassembly()
            }
        } catch let error {
            print(error)
        }
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }


}

