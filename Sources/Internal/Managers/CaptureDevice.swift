//
//  CaptureDevice.swift of MijickCamera
//
//  Created by Tomasz Kurylik. Sending ❤️ from Kraków!
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//    - Medium: https://medium.com/@mijick
//
//  Copyright ©2024 Mijick. All rights reserved.


import AVKit

protocol CaptureDevice: NSObject {
    var uniqueID: String { get }
    var hasFlash: Bool { get }
    var hasTorch: Bool { get }
    var exposureDuration: CMTime { get }
    var videoZoomFactor: CGFloat { get set }
    var iso: Float { get }
    var exposureTargetBias: Float { get }
    var exposureMode: AVCaptureDevice.ExposureMode { get set }
    var hdrMode: CameraHDRMode { get set }
    var maxExposureTargetBias: Float { get }
    var minExposureTargetBias: Float { get }
    var activeVideoMinFrameDuration: CMTime { get set }
    var activeVideoMaxFrameDuration: CMTime { get set }
    var torchMode: AVCaptureDevice.TorchMode { get set }
    var isFocusPointOfInterestSupported: Bool { get }
    var isExposurePointOfInterestSupported: Bool { get }
    var focusMode: AVCaptureDevice.FocusMode { get set }
    var minAvailableVideoZoomFactor: CGFloat { get }
    var maxAvailableVideoZoomFactor: CGFloat { get }

    var videoSupportedFrameRateRanges: [AVFrameRateRange] { get }
    var minISO: Float { get }
    var maxISO: Float { get }
    var minExposureDuration: CMTime { get }
    var maxExposureDuration: CMTime { get }

    var focusPointOfInterest: CGPoint { get set }
    var exposurePointOfInterest: CGPoint { get set }

    func setExposureTargetBias(_ bias: Float) async -> CMTime

    func isExposureModeSupported(_ exposureMode: AVCaptureDevice.ExposureMode) -> Bool
    func setExposureModeCustom(duration: CMTime, iso: Float) async -> CMTime


    func lockForConfiguration() throws
    func unlockForConfiguration()
}


// MARK: REAL
extension AVCaptureDevice: CaptureDevice {
    var videoSupportedFrameRateRanges: [AVFrameRateRange] {
        activeFormat.videoSupportedFrameRateRanges
    }
    var maxISO: Float { activeFormat.maxISO }
    var minISO: Float { activeFormat.minISO }

    var minExposureDuration: CMTime { activeFormat.minExposureDuration }
    var maxExposureDuration: CMTime { activeFormat.maxExposureDuration }
}


// MARK: MOCK
class MockCaptureDevice: CaptureDevice {
    var maxExposureTargetBias: Float { 0 }

    var minExposureTargetBias: Float { 0 }

    func isExposureModeSupported(_ exposureMode: AVCaptureDevice.ExposureMode) -> Bool {
        true
    }
    
    var hdrMode: CameraHDRMode = .auto

    var exposureMode: AVCaptureDevice.ExposureMode { .autoExpose }

    var exposureTargetBias: Float { 0 }

    var iso: Float { 0 }

    var videoZoomFactor: CGFloat = 0

    func lockForConfiguration() throws {
        return
    }
    func unlockForConfiguration() {
        return
    }

    var hasFlash: Bool { true }
    var hasTorch: Bool { true }

    var uniqueID: String
    var exposureDuration: CMTime { .init() }

    func setExposureTargetBias(_ bias: Float) async -> CMTime {
        .init()
    }


    init(uniqueID: String) {
        self.uniqueID = uniqueID
    }
}
