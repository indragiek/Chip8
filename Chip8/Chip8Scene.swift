//  Copyright © 2015 Indragie Karunaratne. All rights reserved.

import SpriteKit
import Chip8Kit

final class Chip8Scene: SKScene {
    private let emulator: Emulator
    private let sprites: [SKSpriteNode]
    
    init(size: CGSize, emulator: Emulator) {
        print(size)
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
        self.sprites = sprites
        self.emulator = emulator
        
        super.init(size: size)
        
        for sprite in sprites {
            addChild(sprite)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(currentTime: NSTimeInterval) {
        do {
            let state = try emulator.emulateCycle()
            if state.redraw {
                let rows = Emulator.Hardware.ScreenRows
                let columns = Emulator.Hardware.ScreenColumns
                
                for y in 0..<rows {
                    for x in 0..<columns {
                        let index = (y * columns) + x
                        let pixel = state.screen[index]
                        let sprite = sprites[index]
                        sprite.color = (pixel == 1) ? .whiteColor() : .blackColor()
                    }
                }
            }
            if state.beep {
                NSBeep()
            }
        } catch let error {
            fatalError("Emulation error: \(error)")
        }
    }
}
