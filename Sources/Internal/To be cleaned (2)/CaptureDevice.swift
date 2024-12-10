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
    // MARK: Gettters
    var uniqueID: String { get }
    var hasFlash: Bool { get }
    var hasTorch: Bool { get }
    var exposureDuration: CMTime { get }
    var exposureTargetBias: Float { get }
    var iso: Float { get }
    var minAvailableVideoZoomFactor: CGFloat { get }
    var maxAvailableVideoZoomFactor: CGFloat { get }
    var minExposureDuration: CMTime { get }
    var maxExposureDuration: CMTime { get }
    var minISO: Float { get }
    var maxISO: Float { get }
    var minExposureTargetBias: Float { get }
    var maxExposureTargetBias: Float { get }
    var minFrameRate: Float64? { get }
    var maxFrameRate: Float64? { get }
    var isExposurePointOfInterestSupported: Bool { get }
    var isFocusPointOfInterestSupported: Bool { get }

    // MARK: Gettters & Setters
    var focusMode: AVCaptureDevice.FocusMode { get set }
    var lightMode: CameraLightMode { get set }
    var exposureMode: AVCaptureDevice.ExposureMode { get set }
    var hdrMode: CameraHDRMode { get set }
    var focusPointOfInterest: CGPoint { get set }
    var exposurePointOfInterest: CGPoint { get set }
    var videoZoomFactor: CGFloat { get set }
    var activeVideoMinFrameDuration: CMTime { get set }
    var activeVideoMaxFrameDuration: CMTime { get set }

    // MARK: Methods
    func lockForConfiguration() throws
    func unlockForConfiguration()
    func isExposureModeSupported(_ exposureMode: AVCaptureDevice.ExposureMode) -> Bool
    func setExposureModeCustom(duration: CMTime, iso: Float, completionHandler: ((CMTime) -> Void)?)
    func setExposureTargetBias(_ bias: Float, completionHandler handler: ((CMTime) -> ())?)
}


// MARK: - METHODS



// MARK: Set Zoom Factor
extension CaptureDevice {

}

// MARK: Set Exposure Mode
extension CaptureDevice {

}

// MARK: Set Exposure Target Bias
extension CaptureDevice {

}

// MARK: Set Frame Rate
extension CaptureDevice {
}

// MARK: Set Exposure Point Of Interest
extension CaptureDevice {

}

// MARK: Set Focus Point Of Interest
extension CaptureDevice {
}

// MARK: Set Light Mode
extension CaptureDevice {

}






extension CaptureDevice {
    func setZoomFactor(_ factor: CGFloat) {
        let factor = max(min(factor, min(maxAvailableVideoZoomFactor, 5)), minAvailableVideoZoomFactor)
        videoZoomFactor = factor
    }
    func setExposureMode(_ mode: AVCaptureDevice.ExposureMode, duration: CMTime, iso: Float) {
        guard isExposureModeSupported(mode) else { return }

        exposureMode = mode

        guard mode == .custom else { return }

        let duration = max(min(duration, maxExposureDuration), minExposureDuration)
        let iso = max(min(iso, maxISO), minISO)

        setExposureModeCustom(duration: duration, iso: iso, completionHandler: nil)
    }
    func setExposureTargetBias(_ bias: Float) {
        guard isExposureModeSupported(.custom) else { return }

        let bias = max(min(bias, maxExposureTargetBias), minExposureTargetBias)
        setExposureTargetBias(bias, completionHandler: nil)
    }
    func setFrameRate(_ frameRate: Int32) {
        guard let minFrameRate, let maxFrameRate else { return }

        let frameRate = max(min(frameRate, Int32(maxFrameRate)), Int32(minFrameRate))

        activeVideoMinFrameDuration = CMTime(value: 1, timescale: frameRate)
        activeVideoMaxFrameDuration = CMTime(value: 1, timescale: frameRate)
    }
    func setExposurePointOfInterest(_ point: CGPoint) {
        guard isExposurePointOfInterestSupported else { return }

        exposurePointOfInterest = point
        exposureMode = .autoExpose
    }
    func setFocusPointOfInterest(_ point: CGPoint) {
        guard isFocusPointOfInterestSupported else { return }

        focusPointOfInterest = point
        focusMode = .autoFocus
    }
    func setLightMode(_ mode: CameraLightMode) {
        guard hasTorch else { return }
        lightMode = mode
    }
}
