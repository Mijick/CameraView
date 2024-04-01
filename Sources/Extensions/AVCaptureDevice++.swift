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

// MARK: - Camera Torch
extension AVCaptureDevice.TorchMode: CaseIterable {
    public static var allCases: [AVCaptureDevice.TorchMode] { [.off, .on] }
}

// MARK: - Camera Flash
extension AVCaptureDevice.FlashMode: CaseIterable {
    public static var allCases: [AVCaptureDevice.FlashMode] { [.off, .auto, .on] }
}

// MARK: - Camera Position
extension AVCaptureDevice.Position: CaseIterable {
    public static var allCases: [AVCaptureDevice.Position] { [.back, .front] }
}
