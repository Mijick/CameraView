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
    func setExposureMode(_ mode: AVCaptureDevice.ExposureMode, duration: CMTime, iso: Float) throws
    func setExposureTargetBias(_ bias: Float) throws
    func setFrameRate(_ frameRate: Int32) throws
    func setZoomFactor(_ factor: CGFloat) throws
    func setFocusPointOfInterest(_ point: CGPoint) throws
    func setExposurePointOfInterest(_ point: CGPoint) throws
}

extension CaptureDevice {
    func setZoomFactor(_ factor: CGFloat) {
        let factor = max(min(factor, min(maxAvailableVideoZoomFactor, 5)), minAvailableVideoZoomFactor)
        videoZoomFactor = factor
    }
}


// MARK: REAL
extension AVCaptureDevice: CaptureDevice {
    func setExposureMode(_ mode: AVCaptureDevice.ExposureMode, duration: CMTime, iso: Float) {
        guard isExposureModeSupported(mode) else { return }

        exposureMode = mode

        guard mode == .custom else { return }

        let duration = max(min(duration, activeFormat.maxExposureDuration), activeFormat.minExposureDuration)
        let iso = max(min(iso, activeFormat.maxISO), activeFormat.minISO)

        setExposureModeCustom(duration: duration, iso: iso, completionHandler: nil)
    }
    func setExposureTargetBias(_ bias: Float) {
        guard isExposureModeSupported(.custom) else { return }

        let bias = max(min(bias, maxExposureTargetBias), minExposureTargetBias)
        setExposureTargetBias(bias, completionHandler: nil)
    }
    func setFrameRate(_ frameRate: Int32) {
        guard let range = activeFormat.videoSupportedFrameRateRanges.first,
              frameRate > Int32(range.minFrameRate), frameRate < Int32(range.maxFrameRate)
        else { return }

        activeVideoMinFrameDuration = CMTime(value: 1, timescale: frameRate)
        activeVideoMaxFrameDuration = CMTime(value: 1, timescale: frameRate)
    }
    func setFocusPointOfInterest(_ point: CGPoint) {
        guard isFocusPointOfInterestSupported else { return }
        
        focusPointOfInterest = point
        focusMode = .autoFocus
    }
    func setExposurePointOfInterest(_ point: CGPoint) {
        guard isExposurePointOfInterestSupported else { return }

        exposurePointOfInterest = point
        exposureMode = .autoExpose
    }
}


// MARK: MOCK
class MockCaptureDevice: NSObject, CaptureDevice {
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
    func setExposureMode(_ mode: AVCaptureDevice.ExposureMode, duration: CMTime, iso: Float) {
        exposureMode = mode
        _exposureDuration = duration
        _iso = iso
    }
    func setExposureTargetBias(_ bias: Float) {
        _exposureTargetBias = bias
    }
    func setFrameRate(_ frameRate: Int32) {
        activeVideoMinFrameDuration = CMTime(value: 1, timescale: frameRate)
        activeVideoMaxFrameDuration = CMTime(value: 1, timescale: frameRate)
    }
    func setFocusPointOfInterest(_ point: CGPoint) throws {
        focusPointOfInterest = point
    }
    func setExposurePointOfInterest(_ point: CGPoint) throws {
        exposurePointOfInterest = point
    }



    private var _exposureDuration: CMTime = .init()
    private var _exposureTargetBias: Float = 0
    private var _iso: Float = 0
}
