//
//  CameraHDRMode++.swift of MijickCameraView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2024 Mijick. Licensed under MIT License.


import AVKit

// MARK: - Initialiser
extension CameraHDRMode {
    init(device: AVCaptureDevice) {
        if device.automaticallyAdjustsVideoHDREnabled { self = .auto }
        else if device.isVideoHDREnabled { self = .on }
        else { self = .off }
    }
}

// MARK: - Modifying Device
extension CameraHDRMode {
    func modify(_ device: AVCaptureDevice) {
        device.automaticallyAdjustsVideoHDREnabled = self == .auto
        if self != .auto { device.isVideoHDREnabled = self == .on }
    }
}
