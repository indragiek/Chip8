//  Copyright © 2015 Indragie Karunaratne. All rights reserved.

import SpriteKit
import Chip8Kit

final class Chip8Scene: SKScene {
    private let runner: Chip8Runner
    private let sprites: [SKSpriteNode]
    
    var keyMapping: KeyMapping
    var beepSound: Sound
    
    // MARK: Initialization
    
    init(size: CGSize, runner: Chip8Runner, keyMapping: KeyMapping = defaultKeyMapping, beepSound: Sound = NSBeepSound()) {
        let rows = Emulator.Hardware.ScreenRows
        let columns = Emulator.Hardware.ScreenColumns
        let pixelDim = floor(size.width / CGFloat(columns))
        let pixelSize = CGSize(width: pixelDim, height: pixelDim)
        var sprites = [SKSpriteNode]()
        for y in 0..<rows {
            for x in 0..<columns {
                let node = SKSpriteNode(color: .blackColor(), size: pixelSize)
                node.position = CGPoint(
                    x: (CGFloat(x) * pixelDim) + (pixelDim / 2),
                    y: size.height - (pixelDim * CGFloat(y + 1)) + (pixelDim / 2)
                )
                sprites.append(node)
            }
        }
        self.runner = runner
        self.sprites = sprites
        self.keyMapping = keyMapping
        self.beepSound = beepSound
        
        super.init(size: size)
        
        for sprite in sprites {
            addChild(sprite)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Rendering
    
    override func update(currentTime: NSTimeInterval) {
        if let screen = runner.screen where runner.redraw {
            let rows = Emulator.Hardware.ScreenRows
            let columns = Emulator.Hardware.ScreenColumns
            
            for y in 0..<rows {
                for x in 0..<columns {
                    let index = (y * columns) + x
                    let pixel = screen[index]
                    let sprite = sprites[index]
                    sprite.color = (pixel == 1) ? .whiteColor() : .blackColor()
                }
            }
            runner.redraw = false
        }
        if runner.playBeep {
            self.beepSound.playSound()
            runner.playBeep = false
        }
    }
    
    // MARK: Keyboard Events
    
    override func keyDown(theEvent: NSEvent) {
        handleKeyEvent(theEvent, pressed: true)
    }
    
    override func keyUp(theEvent: NSEvent) {
        handleKeyEvent(theEvent, pressed: false)
    }
    
    private func handleKeyEvent(event: NSEvent, pressed: Bool) {
        if let key = keyMapping(Int(event.keyCode)) {
            runner.setState(pressed, forKey: key)
        }
    }
}
