//  Copyright © 2015 Indragie Karunaratne. All rights reserved.

import SpriteKit
import Chip8Kit
import Carbon

final class Chip8Scene: SKScene {
    typealias KeyMapping = Int -> Emulator.Key?
    
    private let emulator: Emulator
    private let sprites: [SKSpriteNode]
    private let keyMapping: KeyMapping
    
    // MARK: Initialization
    
    init(size: CGSize, emulator: Emulator, keyMapping: KeyMapping = defaultKeyMapping) {
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
        self.keyMapping = keyMapping
        
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
    
    // MARK: Keyboard Events
    
    override func keyDown(theEvent: NSEvent) {
        handleKeyEvent(theEvent, pressed: true)
    }
    
    override func keyUp(theEvent: NSEvent) {
        handleKeyEvent(theEvent, pressed: false)
    }
    
    private func handleKeyEvent(event: NSEvent, pressed: Bool) {
        if let key = keyMapping(Int(event.keyCode)) {
            emulator.setState(pressed, forKey: key)
        }
    }
}

private func defaultKeyMapping(code: Int) -> Emulator.Key? {
    switch code {
    case kVK_ANSI_1:
        return .Num1
    case kVK_ANSI_2:
        return .Num2
    case kVK_ANSI_3:
        return .Num3
    case kVK_ANSI_4:
        return .C
    case kVK_ANSI_Q:
        return .Num4
    case kVK_ANSI_W:
        return .Num5
    case kVK_ANSI_E:
        return .Num6
    case kVK_ANSI_R:
        return .D
    case kVK_ANSI_A:
        return .Num7
    case kVK_ANSI_S:
        return .Num8
    case kVK_ANSI_D:
        return .Num9
    case kVK_ANSI_F:
        return .E
    case kVK_ANSI_Z:
        return .A
    case kVK_ANSI_X:
        return .Num0
    case kVK_ANSI_C:
        return .B
    case kVK_ANSI_V:
        return .F
    default:
        return nil
    }
}
