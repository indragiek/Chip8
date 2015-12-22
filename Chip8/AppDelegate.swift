//
//  AppDelegate.swift
//  Chip8
//
//  Created by Indragie on 12/22/15.
//  Copyright © 2015 Indragie Karunaratne. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!


    func applicationDidFinishLaunching(aNotification: NSNotification) {
        let opcode = Opcode(rawOpcode: UInt16(bigEndian: 0x1234))
        print(opcode?.textualDescription)
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }


}

