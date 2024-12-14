//
//  CameraExposure.swift of MijickCamera
//
//  Created by Tomasz Kurylik. Sending ❤️ from Kraków!
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//    - Medium: https://medium.com/@mijick
//
//  Copyright ©2024 Mijick. All rights reserved.


import AVKit

struct CameraExposure {
    var duration: CMTime = .zero
    var targetBias: Float = 0
    var iso: Float = 0
    var mode: AVCaptureDevice.ExposureMode = .autoExpose
}
