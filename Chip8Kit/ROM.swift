//  Copyright © 2015 Indragie Karunaratne. All rights reserved.

#if os(Linux)
    import Glibc
#else
    import Foundation
#endif

/// ROM (Read Only Memory) data to be loaded into an emulator.
public struct ROM {
    public enum Error: ErrorType {
        case FileOpenFailed(path: String)
        case FileReadFailed(path: String)
    }
    
    public let bytes: [UInt8]
    
    /// Initializes the receiver using a byte array.
    public init(bytes: [UInt8]) {
        self.bytes = bytes
    }
    
    /// Initializes the receiver using a file path.
    ///
    /// Throws `Error.FileOpenFailed` if the file cannot be opened, and throws
    /// `Error.FileReadFailed` if the file cannot be read.
    public init(path: String) throws {
        let file = fopen(path, "rb")
        if file == nil {
            bytes = []
            throw Error.FileOpenFailed(path: path)
        }
        defer { fclose(file) }
        
        fseek(file, 0, SEEK_END)
        let fileSize = ftell(file)
        rewind(file)
        
        var buffer = [UInt8](count: fileSize, repeatedValue: 0)
        let readSize = fread(&buffer, sizeof(UInt8), fileSize, file)
        if readSize != fileSize {
            bytes = []
            throw Error.FileReadFailed(path: path)
        }
        
        self.bytes = buffer
    }
    
    /// Initializes the receiver using an `NSData` object.
    #if os(iOS) || os(OSX)
    public init(data: NSData) {
        let bytesPtr = unsafeBitCast(data.bytes, UnsafePointer<UInt8>.self)
        let bytesBufferPtr = UnsafeBufferPointer(start: bytesPtr, count: data.length)
        self.bytes = Array(bytesBufferPtr)
    }
    #endif
}
