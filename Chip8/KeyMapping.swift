//  Copyright © 2015 Indragie Karunaratne. All rights reserved.

import Chip8Kit
import Carbon

typealias KeyMapping = Int -> Emulator.Key?

func defaultKeyMapping(code: Int) -> Emulator.Key? {
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
