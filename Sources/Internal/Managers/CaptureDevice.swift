//
//  CaptureDevice.swift of MijickCamera
//
//  Created by Tomasz Kurylik. Sending ❤️ from Kraków!
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//    - Medium: https://medium.com/@mijick
//
//  Copyright ©2024 Mijick. All rights reserved.


import AVKit

protocol CaptureDevice {
    var uniqueID: String { get }
    var hasFlash: Bool { get }
    var hasTorch: Bool { get }
    var exposureDuration: CMTime { get }
}


// MARK: REAL
extension AVCaptureDevice: CaptureDevice {
}


// MARK: MOCK
class MockCaptureDevice: CaptureDevice {
    var hasFlash: Bool { true }
    var hasTorch: Bool { true }

    var uniqueID: String
    var exposureDuration: CMTime { .init() }


    init(uniqueID: String) {
        self.uniqueID = uniqueID
    }
}
