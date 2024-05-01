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

// MARK: Camera Position
extension CameraPosition {
    func get() -> AVCaptureDevice.Position { switch self {
        case .back: .back
        case .front: .front
    }}
}

// MARK: Camera Flash Mode
extension CameraFlashMode {
    func get() -> AVCaptureDevice.FlashMode { switch self {
        case .off: .off
        case .on: .on
        case .auto: .auto
    }}
}

// MARK: Camera Torch Mode
extension CameraTorchMode {
    func get() -> AVCaptureDevice.TorchMode { switch self {
        case .off: .off
        case .on: .on
    }}
}
