//  Copyright © 2015 Indragie Karunaratne. All rights reserved.

func hex<T: UnsignedIntegerType>(value: T) -> String {
    return String(value, radix: 16).uppercaseString
}

func hex<T: SignedIntegerType>(value: T) -> String {
    return String(value, radix: 16).uppercaseString
}
