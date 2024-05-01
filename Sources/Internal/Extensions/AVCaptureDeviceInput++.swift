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
    convenience init?(_ device: AVCaptureDevice?) {
        if let device { try? self.init(device: device) }
        else { return nil }
    }
}
