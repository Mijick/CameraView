//
//  AVCaptureVideoOrientation++.swift of MijickCamera
//
//  Created by Tomasz Kurylik. Sending ❤️ from Kraków!
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//    - Medium: https://medium.com/@mijick
//
//  Copyright ©2024 Mijick. All rights reserved.


import SwiftUI
import AVKit

// MARK: - To Angle
extension AVCaptureVideoOrientation {
    func getAngle() -> Angle { switch self {
        case .portrait: .degrees(0)
        case .landscapeLeft: .degrees(-90)
        case .landscapeRight: .degrees(90)
        case .portraitUpsideDown: .degrees(180)
        default: .degrees(0)
    }}
}

// MARK: - To UIImage.Orientation
extension AVCaptureVideoOrientation {
    func toImageOrientation() -> UIImage.Orientation { switch self {
        case .portrait: .downMirrored
        case .landscapeLeft: .leftMirrored
        case .landscapeRight: .rightMirrored
        case .portraitUpsideDown: .upMirrored
        default: .up
    }}
}

// MARK: - To UIDeviceOrientation
extension AVCaptureVideoOrientation {
    func toDeviceOrientation() -> UIDeviceOrientation { switch self {
        case .portrait: .portrait
        case .portraitUpsideDown: .portraitUpsideDown
        case .landscapeLeft: .landscapeLeft
        case .landscapeRight: .landscapeRight
        default: .portrait
    }}
}
