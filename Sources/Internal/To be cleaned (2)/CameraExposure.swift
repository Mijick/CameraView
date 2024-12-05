//
//  CameraExposure.swift of MijickCameraView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2024 Mijick. Licensed under MIT License.


import AVKit

struct CameraExposure {
    var duration: CMTime = .invalid
    var targetBias: Float = 0
    var iso: Float = 0
    var mode: AVCaptureDevice.ExposureMode = .autoExpose
}
