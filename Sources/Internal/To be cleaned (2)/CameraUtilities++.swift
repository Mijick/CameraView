//
//  CameraUtilities++.swift of MijickCamera
//
//  Created by Tomasz Kurylik. Sending ❤️ from Kraków!
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//    - Medium: https://medium.com/@mijick
//
//  Copyright ©2024 Mijick. All rights reserved.


import AVKit

// MARK: Camera Flash Mode
extension CameraFlashMode {
    func get() -> AVCaptureDevice.FlashMode { switch self {
        case .off: .off
        case .on: .on
        case .auto: .auto
    }}
}
