//
//  AVCaptureDeviceInput++.swift of MijickCameraView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2024 Mijick. Licensed under MIT License.


import AVKit

extension AVCaptureDeviceInput {
    static func get(for mediaType: AVMediaType, position: AVCaptureDevice.Position? = nil, _ deviceType: AVCaptureDevice.DeviceType? = nil) -> AVCaptureDeviceInput? {
        guard let device = AVCaptureDevice.get(mediaType: mediaType, deviceType: deviceType, position: position) else { return nil }

        let deviceInput = try? AVCaptureDeviceInput(device: device)
        return deviceInput
    }
}






fileprivate extension AVCaptureDevice {
    static func get(mediaType: AVMediaType, deviceType: AVCaptureDevice.DeviceType?, position: AVCaptureDevice.Position?) -> AVCaptureDevice? {
        guard let deviceType, let position else { return .default(for: mediaType) }
        return .default(deviceType, for: mediaType, position: position)
    }
}
