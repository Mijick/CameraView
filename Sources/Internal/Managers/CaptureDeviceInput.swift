//
//  CaptureDeviceInput.swift of MijickCamera
//
//  Created by Tomasz Kurylik. Sending ❤️ from Kraków!
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//    - Medium: https://medium.com/@mijick
//
//  Copyright ©2024 Mijick. All rights reserved.


import AVKit

protocol CaptureDeviceInput: NSObject {
    var device: AVCaptureDevice { get }

    //associatedtype S: CaptureDevice
    //var device: S { get }


    static func get(mediaType: AVMediaType, position: AVCaptureDevice.Position?) -> Self?
}


// MARK: REAL
extension AVCaptureDeviceInput: CaptureDeviceInput {
    static func get(mediaType: AVMediaType, position: AVCaptureDevice.Position?) -> Self? {
        let device = { switch mediaType {
            case .audio: AVCaptureDevice.default(for: .audio)
            case .video where position == .front: AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
            case .video where position == .back: AVCaptureDevice.default(for: .video)
            default: fatalError()
        }}()

        if let device, let deviceInput = try? Self(device: device) { return deviceInput }
        else { return nil }
    }
}




// MARK: MOCK
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
