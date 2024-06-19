//
//  AVCaptureDevice++.swift of MijickCameraView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2024 Mijick. Licensed under MIT License.


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
}
