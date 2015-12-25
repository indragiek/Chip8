//  Copyright © 2015 Indragie Karunaratne. All rights reserved.

import Cocoa
import SpriteKit
import Chip8Kit

final class Chip8View: NSView {
    private let sceneView = SKView(frame: NSZeroRect)
    private var scene: Chip8Scene?
    private var rom: ROM?
    private var runner: Chip8Runner?
    
    // MARK: API
    
    var clockRate: Double = 500.0 {
        didSet { runner?.clockRate = clockRate }
    }
    
    var keyMapping: KeyMapping = defaultKeyMapping {
        didSet { scene?.keyMapping = keyMapping }
    }
    
    var beepSound: Sound = NSBeepSound() {
        didSet { scene?.beepSound = beepSound }
    }
    
    var showsFPS: Bool {
        get { return sceneView.showsFPS }
        set { sceneView.showsFPS = newValue }
    }
    
    var paused: Bool {
        get { return sceneView.paused }
        set {
            if paused == newValue { return }
            sceneView.paused = newValue
            if newValue {
                runner?.suspend()
            } else {
                runner?.resume()
            }
        }
    }
    
    func loadROM(rom: ROM) {
        self.rom = rom
        reset()
    }
    
    func reset() {
        guard let rom = rom else { return }
        
        let emulator = Emulator(rom: rom)
        let runner = Chip8Runner(emulator: emulator, clockRate: clockRate)
        let scene = Chip8Scene(size: bounds.size, runner: runner, keyMapping: keyMapping, beepSound: beepSound)
        
        sceneView.presentScene(scene)
        runner.resume()
        
        self.runner = runner
        self.scene = scene
    }
    
    // MARK: NSView
    
    override var acceptsFirstResponder: Bool { return true }
    
    override func becomeFirstResponder() -> Bool {
        window?.makeFirstResponder(sceneView)
        return false
    }
    
    // MARK: Initialization
    
    private func commonInit() {
        addSubview(sceneView)
        
        sceneView.translatesAutoresizingMaskIntoConstraints = false
        sceneView.leadingAnchor.constraintEqualToAnchor(leadingAnchor).active = true
        sceneView.trailingAnchor.constraintEqualToAnchor(trailingAnchor).active = true
        sceneView.topAnchor.constraintEqualToAnchor(topAnchor).active = true
        sceneView.bottomAnchor.constraintEqualToAnchor(bottomAnchor).active = true
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
}
