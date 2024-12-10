//
//  CaptureDevice+MockCaptureDevice.swift of MijickCamera
//
//  Created by Tomasz Kurylik. Sending ❤️ from Kraków!
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//    - Medium: https://medium.com/@mijick
//
//  Copyright ©2024 Mijick. All rights reserved.


import AVKit

class MockCaptureDevice: NSObject, CaptureDevice {
    // MARK: Getters
    var uniqueID: String = UUID().uuidString
    var exposureDuration: CMTime { _exposureDuration }
    var exposureTargetBias: Float { _exposureTargetBias }
    var iso: Float { _iso }
    var minAvailableVideoZoomFactor: CGFloat { 1 }
    var maxAvailableVideoZoomFactor: CGFloat { 3.876 }
    


    // MARK: Setters



    // MARK: Methods


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


    let hasFlash: Bool = true
    let hasTorch: Bool = true





    var focusMode: AVCaptureDevice.FocusMode = .autoFocus
    var lightMode: CameraLightMode = .off
    var exposureMode: AVCaptureDevice.ExposureMode = .continuousAutoExposure
    var hdrMode: CameraHDRMode = .auto
    var focusPointOfInterest: CGPoint = .zero
    var exposurePointOfInterest: CGPoint = .zero
    var videoZoomFactor: CGFloat = 1
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
