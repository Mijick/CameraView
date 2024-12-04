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
    // MARK: Read Only
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

    // MARK: Changable
    var focusMode: AVCaptureDevice.FocusMode { get set }
    var torchMode: AVCaptureDevice.TorchMode { get set }
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
}


// MARK: REAL
extension AVCaptureDevice: CaptureDevice {
    var minExposureDuration: CMTime { activeFormat.minExposureDuration }
    var maxExposureDuration: CMTime { activeFormat.maxExposureDuration }
    var minISO: Float { activeFormat.minISO }
    var maxISO: Float { activeFormat.maxISO }
    var minFrameRate: Float64? { activeFormat.videoSupportedFrameRateRanges.first?.minFrameRate }
    var maxFrameRate: Float64? { activeFormat.videoSupportedFrameRateRanges.first?.maxFrameRate }
}


// MARK: MOCK
class MockCaptureDevice: NSObject, CaptureDevice {
    let minExposureDuration: CMTime = .init(value: 1, timescale: 1000)
    let maxExposureDuration: CMTime = .init(value: 1, timescale: 5)
    let minISO: Float = 1
    let maxISO: Float = 10
    let minExposureTargetBias: Float = 0.1
    let maxExposureTargetBias: Float = 199
    let minFrameRate: Float64? = 15
    let maxFrameRate: Float64? = 60
    let isExposurePointOfInterestSupported: Bool = true
    let isFocusPointOfInterestSupported: Bool = true

    func isExposureModeSupported(_ exposureMode: AVCaptureDevice.ExposureMode) -> Bool { true }

    func setExposureModeCustom(duration: CMTime, iso: Float, completionHandler: ((CMTime) -> Void)?) {
        _exposureDuration = duration
        _iso = iso
    }
    
    let uniqueID: String = UUID().uuidString
    let hasFlash: Bool = true
    let hasTorch: Bool = true
    var exposureDuration: CMTime { _exposureDuration }
    var exposureTargetBias: Float { _exposureTargetBias }
    var iso: Float { _iso }
    var minAvailableVideoZoomFactor: CGFloat = 1
    var maxAvailableVideoZoomFactor: CGFloat = 3.876

    var focusMode: AVCaptureDevice.FocusMode = .autoFocus
    var torchMode: AVCaptureDevice.TorchMode = .auto
    var exposureMode: AVCaptureDevice.ExposureMode = .continuousAutoExposure
    var hdrMode: CameraHDRMode = .auto
    var focusPointOfInterest: CGPoint = .zero
    var exposurePointOfInterest: CGPoint = .zero
    var videoZoomFactor: CGFloat = 0
    var activeVideoMinFrameDuration: CMTime = .init()
    var activeVideoMaxFrameDuration: CMTime = .init()

    func lockForConfiguration() throws { return }
    func unlockForConfiguration() { return }
    func setExposureTargetBias(_ bias: Float, completionHandler handler: ((CMTime) -> ())?) {
        _exposureTargetBias = bias
    }



    private var _exposureDuration: CMTime = .init()
    private var _exposureTargetBias: Float = 0
    private var _iso: Float = 0
}
