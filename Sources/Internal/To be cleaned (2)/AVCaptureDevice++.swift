//
//  AVCaptureDevice++.swift of MijickCamera
//
//  Created by Tomasz Kurylik. Sending ❤️ from Kraków!
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//    - Medium: https://medium.com/@mijick
//
//  Copyright ©2024 Mijick. All rights reserved.


import AVKit

extension AVCaptureDevice {
    var hdrMode: CameraHDRMode {
        get {
            if automaticallyAdjustsVideoHDREnabled { return .auto }
            else if isVideoHDREnabled { return .on }
            else { return .off }
        }
        set {
            automaticallyAdjustsVideoHDREnabled = newValue == .auto
            if newValue != .auto { isVideoHDREnabled = newValue == .on }
        }
    }
    var lightMode: CameraLightMode {
        get { torchMode == .off ? .off : .on }
        set { torchMode = newValue == .off ? .off : .on }
    }
}
