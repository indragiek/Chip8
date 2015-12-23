//  Copyright © 2015 Indragie Karunaratne. All rights reserved.

protocol DisplayTimer {
    func start()
    func stop()
    var isSynchronizedWithDisplay: Bool { get }
}
