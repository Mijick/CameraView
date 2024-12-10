//
//  CaptureDeviceInput+MockDeviceInput.swift of MijickCamera
//
//  Created by Tomasz Kurylik. Sending ❤️ from Kraków!
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//    - Medium: https://medium.com/@mijick
//
//  Copyright ©2024 Mijick. All rights reserved.


import AVKit

class MockDeviceInput: NSObject, CaptureDeviceInput { required override init() {}
    static func get(mediaType: AVMediaType, position: AVCaptureDevice.Position?) -> Self? {
        .init()
    }

    var device: MockCaptureDevice = .init()
}
extension MockDeviceInput {
    static func == (lhs: MockDeviceInput, rhs: MockDeviceInput) -> Bool {
        lhs.device.uniqueID == rhs.device.uniqueID
    }
}
