//
//  CameraUtilities++.swift of MijickCameraView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2024 Mijick. Licensed under MIT License.


import AVKit

// MARK: Camera Flash Mode
extension CameraFlashMode {
    func get() -> AVCaptureDevice.FlashMode { switch self {
        case .off: .off
        case .on: .on
        case .auto: .auto
    }}
}
