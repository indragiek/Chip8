//  Copyright © 2015 Indragie Karunaratne. All rights reserved.

import Cocoa
import SpriteKit
import Chip8Kit

/// A view that provides a simple interface for running the CHIP-8 emulator
/// and handling rendering and keyboard input.
final class Chip8View: NSView {
    private let sceneView = SKView(frame: NSZeroRect)
    private var scene: Chip8Scene?
    private var rom: ROM?
    private var runner: Chip8Runner?
    
    // MARK: API
    
    /// The clock rate for the emulator to run at, in Hz. The default clock rate
    /// is 500Hz and is suitable for most games, according to:
    /// https://github.com/AfBu/haxe-chip-8-emulator/wiki/(Super)CHIP-8-Secrets
    var clockRate: Double = 500.0 {
        didSet { runner?.clockRate = clockRate }
    }
    
    /// The mapping from keyboard keys to the keys on the keypad of the CHIP-8
    ///
    /// A key mapping is simply a function that takes a key code and returns
    /// the corresponding CHIP-8 key (defined using the type `Chip8Kit.Emulator.Key`)
    /// if it exists.
    ///
    /// The default key mapping can be found in `KeyMapping.swift`.
    var keyMapping: KeyMapping = defaultKeyMapping {
        didSet { scene?.keyMapping = keyMapping }
    }
    
    /// The beep sound to play when the CHIP-8 sound timer hits 0.
    ///
    /// Defaults to the system beep sound (`NSBeep()`)
    var beepSound: Sound = NSBeepSound() {
        didSet { scene?.beepSound = beepSound }
    }
    
    /// Whether to show an FPS counter on the screen. Defaults to `false`
    var showsFPS: Bool {
        get { return sceneView.showsFPS }
        set { sceneView.showsFPS = newValue }
    }
    
    /// Whether the emulator is paused. Defaults to `false`.
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
    
    /// Loads a new `ROM`. If the emulator is already running, it will
    /// be aborted.
    func loadROM(rom: ROM) {
        self.rom = rom
        reset()
    }
    
    /// Resets the emulator. Does nothing if there is no ROM loaded.
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
    
    override func keyDown(theEvent: NSEvent) {
        sceneView.keyDown(theEvent)
    }
    
    override func keyUp(theEvent: NSEvent) {
        sceneView.keyUp(theEvent)
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
