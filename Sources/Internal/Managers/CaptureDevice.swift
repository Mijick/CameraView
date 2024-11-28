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
    var minExposureDuration: CMTime { get }
    var maxExposureDuration: CMTime { get }
    var exposureTargetBias: Float { get }
    var minExposureTargetBias: Float { get }
    var maxExposureTargetBias: Float { get }
    var iso: Float { get }
    var minISO: Float { get }
    var maxISO: Float { get }
    var isExposurePointOfInterestSupported: Bool { get }
    var isFocusPointOfInterestSupported: Bool { get }
    var minAvailableVideoZoomFactor: CGFloat { get }
    var maxAvailableVideoZoomFactor: CGFloat { get }
    var videoSupportedFrameRateRanges: [AVFrameRateRange] { get }

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
    func setExposureModeCustom(duration: CMTime, iso: Float, completionHandler: ((CMTime) -> ())?)
    func setExposureTargetBias(_ bias: Float, completionHandler: ((CMTime) -> ())?)
}


// MARK: REAL
extension AVCaptureDevice: CaptureDevice {
    var minExposureDuration: CMTime { activeFormat.minExposureDuration }
    var maxExposureDuration: CMTime { activeFormat.maxExposureDuration }
    var minISO: Float { activeFormat.minISO }
    var maxISO: Float { activeFormat.maxISO }
    var videoSupportedFrameRateRanges: [AVFrameRateRange] { activeFormat.videoSupportedFrameRateRanges }
}


// MARK: MOCK
class MockCaptureDevice: CaptureDevice {
    var uniqueID: String
    let hasFlash: Bool = true
    let hasTorch: Bool = true
    let exposureDuration: CMTime = .init()
    let minExposureDuration: CMTime = .init()
    let maxExposureDuration: CMTime = .init()
    let exposureTargetBias: Float = 0
    let minExposureTargetBias: Float = 0
    let maxExposureTargetBias: Float = 0
    let iso: Float = 0
    let minISO: Float = 0
    let maxISO: Float = 0
    let isExposurePointOfInterestSupported: Bool = true
    let isFocusPointOfInterestSupported: Bool = true
    let minAvailableVideoZoomFactor: CGFloat = 0
    let maxAvailableVideoZoomFactor: CGFloat = 0
    let videoSupportedFrameRateRanges: [AVFrameRateRange] = []

    
    var hdrMode: CameraHDRMode
    
    var videoZoomFactor: CGFloat
    
    func lockForConfiguration() throws {
        <#code#>
    }
    
    func unlockForConfiguration() {
        <#code#>
    }
    
    func isExposureModeSupported(_ exposureMode: AVCaptureDevice.ExposureMode) -> Bool {
        <#code#>
    }
    



    






    var focusMode: AVCaptureDevice.FocusMode
    
    var torchMode: AVCaptureDevice.TorchMode
    
    var exposureMode: AVCaptureDevice.ExposureMode
    
    var focusPointOfInterest: CGPoint
    
    var exposurePointOfInterest: CGPoint
    
    var activeVideoMinFrameDuration: CMTime
    
    var activeVideoMaxFrameDuration: CMTime
    
    func setExposureModeCustom(duration: CMTime, iso: Float, completionHandler: ((CMTime) -> ())?) {
        <#code#>
    }
    
    func setExposureTargetBias(_ bias: Float, completionHandler: ((CMTime) -> ())?) {
        <#code#>
    }
    

    







    init(uniqueID: String) { self.uniqueID = uniqueID }
}
