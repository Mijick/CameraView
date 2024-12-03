//
//  CameraManager.swift of MijickCameraView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2024 Mijick. Licensed under MIT License.


import SwiftUI
import AVKit

@MainActor public class CameraManager: NSObject, ObservableObject {
    @Published var attributes: CameraManagerAttributes = .init()

    // MARK: Input
    private(set) var captureSession: any CaptureSession
    private(set) var frontCameraInput: (any CaptureDeviceInput)?
    private(set) var backCameraInput: (any CaptureDeviceInput)?
    private(set) var audioInput: (any CaptureDeviceInput)?

    // MARK: Output
    private(set) var photoOutput: CameraManagerPhoto = .init()
    private(set) var videoOutput: CameraManagerVideo = .init()

    // MARK: UI Elements
    private(set) var cameraLayer: AVCaptureVideoPreviewLayer = .init()
    private(set) var cameraMetalView: CameraMetalView = .init()
    private(set) var cameraGridView: GridView = .init()

    // MARK: Others
    private(set) var permissionsManager: CameraManagerPermissionsManager = .init()
    private(set) var motionManager: CameraManagerMotionManager = .init()
    private(set) var notificationCenterManager: CameraManagerNotificationCenter = .init()

    // MARK: Initializer
    init<CS: CaptureSession, CDI: CaptureDeviceInput>(captureSession: CS, fontCameraInput: CDI?, backCameraInput: CDI?, audioInput: CDI?) {
        self.captureSession = captureSession
        self.frontCameraInput = fontCameraInput
        self.backCameraInput = backCameraInput
        self.audioInput = audioInput
    }
}

// MARK: Setup
extension CameraManager {
    func setup(in cameraView: UIView) async throws {
        await permissionsManager.requestAccess(parent: self)

        setupCameraLayer(cameraView)
        try setupDeviceInputs()
        try setupDeviceOutput()
        try setupFrameRecorder()
        notificationCenterManager.setup(parent: self)
        motionManager.setup(parent: self)
        try cameraMetalView.setup(parent: self)
        cameraGridView.setup(parent: self)

        Task {
            try await startSession()
            cameraMetalView.performCameraEntranceAnimation()
        }
    }
}
private extension CameraManager {
    func setupCameraLayer(_ cameraView: UIView) {
        captureSession.sessionPreset = attributes.resolution

        cameraLayer.session = captureSession as? AVCaptureSession
        cameraLayer.videoGravity = .resizeAspectFill
        cameraLayer.isHidden = true
        cameraView.layer.addSublayer(cameraLayer)
    }
    func setupDeviceInputs() throws {
        try captureSession.add(input: getCameraInput())
        if attributes.isAudioSourceAvailable { try captureSession.add(input: audioInput) }
    }
    func setupDeviceOutput() throws {
        try photoOutput.setup(parent: self)
        try videoOutput.setup(parent: self)
    }
    func setupFrameRecorder() throws {
        let captureVideoOutput = AVCaptureVideoDataOutput()
        captureVideoOutput.setSampleBufferDelegate(cameraMetalView, queue: DispatchQueue.main)

        try captureSession.add(output: captureVideoOutput)
    }
    nonisolated func startSession() async throws {
        await captureSession.startRunning()
        try await setupDevice()
    }
}
private extension CameraManager {
    func setupDevice() throws {
        guard let device = getCameraInput()?.device else { return }

        try device.lockForConfiguration()
        try device.setExposureMode(attributes.cameraExposure.mode, duration: attributes.cameraExposure.duration, iso: attributes.cameraExposure.iso)
        try device.setExposureTargetBias(attributes.cameraExposure.targetBias)
        try device.setFrameRate(attributes.frameRate)
        try device.setZoomFactor(attributes.zoomFactor)
        device.torchMode = attributes.torchMode.get()
        device.hdrMode = attributes.hdrMode
        device.unlockForConfiguration()
    }
}

// MARK: Cancel
extension CameraManager {
    func cancel() {
        captureSession = captureSession.stopRunningAndReturnNewInstance()
        motionManager.reset()
        videoOutput.reset()
        notificationCenterManager.reset()
    }
}


// MARK: - LIVE ACTIONS



// MARK: Capture Output
extension CameraManager {
    func captureOutput() {
        guard !isChanging else { return }

        switch attributes.outputType {
            case .photo: photoOutput.capture()
            case .video: videoOutput.toggleRecording()
        }
    }
}

// MARK: Set Camera Output
extension CameraManager {
    func setOutputType(_ outputType: CameraOutputType) {
        guard outputType != attributes.outputType, !isChanging else { return }
        attributes.outputType = outputType
    }
}

// MARK: Set Camera Position
extension CameraManager {
    func setCameraPosition(_ position: CameraPosition) async throws {
        guard position != attributes.cameraPosition, !isChanging else { return }

        await cameraMetalView.beginCameraFlipAnimation()
        try changeCameraInput(position)
        resetAttributesWhenChangingCamera(position)
        cameraMetalView.finishCameraFlipAnimation()
    }
}
private extension CameraManager {
    func changeCameraInput(_ position: CameraPosition) throws {
        if let input = getCameraInput() { captureSession.remove(input: input) }
        try captureSession.add(input: getCameraInput(position))
    }
    func resetAttributesWhenChangingCamera(_ position: CameraPosition) {
        attributes.cameraPosition = position
        attributes.zoomFactor = 1
        attributes.torchMode = .off
    }
}

// MARK: Set Camera Zoom
extension CameraManager {
    func setCameraZoomFactor(_ factor: CGFloat) throws {
        guard let device = getCameraInput()?.device, !isChanging else { return }

        try setDeviceZoomFactor(factor, device)
        attributes.zoomFactor = factor
    }
}
private extension CameraManager {
    func setDeviceZoomFactor(_ factor: CGFloat, _ device: any CaptureDevice) throws {
        try device.lockForConfiguration()
        try device.setZoomFactor(factor)
        device.unlockForConfiguration()
    }
}

// MARK: Set Camera Focus
extension CameraManager {
    func setCameraFocus(at touchPoint: CGPoint) throws {
        guard let device = getCameraInput()?.device, !isChanging else { return }

        let focusPoint = convertTouchPointToFocusPoint(touchPoint)
        try setDeviceCameraFocus(focusPoint, device)
        cameraMetalView.performCameraFocusAnimation(touchPoint: touchPoint)
    }
}
private extension CameraManager {
    func convertTouchPointToFocusPoint(_ touchPoint: CGPoint) -> CGPoint { .init(
        x: touchPoint.y / cameraView.frame.height,
        y: 1 - touchPoint.x / cameraView.frame.width
    )}
    func setDeviceCameraFocus(_ focusPoint: CGPoint, _ device: any CaptureDevice) throws {
        try device.lockForConfiguration()
        try device.setFocusPointOfInterest(focusPoint)
        try device.setExposurePointOfInterest(focusPoint)
        device.unlockForConfiguration()
    }
}

// MARK: Set Filters
extension CameraManager {
    func setCameraFilters(_ cameraFilters: [CIFilter]) {
        guard cameraFilters != attributes.cameraFilters, !isChanging else { return }
        attributes.cameraFilters = cameraFilters
    }
}

// MARK: Set Flash Mode
extension CameraManager {
    func setFlashMode(_ mode: CameraFlashMode) {
        guard let device = getCameraInput()?.device, device.hasFlash, !isChanging else { return }
        attributes.flashMode = mode
    }
}

// MARK: Set Torch Mode
extension CameraManager {
    func setTorchMode(_ mode: CameraTorchMode) throws {
        guard let device = getCameraInput()?.device, device.hasTorch, !isChanging else { return }

        try setDeviceTorchMode(device, mode)
        attributes.torchMode = mode
    }
}
private extension CameraManager {
    func setDeviceTorchMode(_ device: any CaptureDevice, _ mode: CameraTorchMode) throws {
        try device.lockForConfiguration()
        device.torchMode = mode.get()
        device.unlockForConfiguration()
    }
}

// MARK: Set Exposure Mode
extension CameraManager {
    func changeExposureMode(_ exposureMode: AVCaptureDevice.ExposureMode) throws {
        guard let device = getCameraInput()?.device, exposureMode != attributes.cameraExposure.mode, !isChanging else { return }

        try setDeviceExposureMode(exposureMode, device)
        attributes.cameraExposure.mode = exposureMode
    }
}
private extension CameraManager {
    func setDeviceExposureMode(_ exposureMode: AVCaptureDevice.ExposureMode, _ device: any CaptureDevice) throws {
        try device.lockForConfiguration()
        try device.setExposureMode(exposureMode, duration: attributes.cameraExposure.duration, iso: attributes.cameraExposure.iso)
        device.unlockForConfiguration()
    }
}

// MARK: Set Exposure Duration
extension CameraManager {

}
private extension CameraManager {

}
private extension CameraManager {

}

// MARK: Set ISO
extension CameraManager {

}
private extension CameraManager {

}
private extension CameraManager {

}

// MARK: Set Exposure Target Bias
extension CameraManager {

}
private extension CameraManager {

}
private extension CameraManager {

}

// MARK: Set HDR Mode
extension CameraManager {

}
private extension CameraManager {

}
private extension CameraManager {

}

// MARK: Set Resolution
extension CameraManager {

}
private extension CameraManager {

}
private extension CameraManager {

}

// MARK: Set Frame Rate
extension CameraManager {

}
private extension CameraManager {

}
private extension CameraManager {

}

// MARK: Set Mirror Mode
extension CameraManager {

}
private extension CameraManager {

}
private extension CameraManager {

}

// MARK: Set Grid Mode
extension CameraManager {

}
private extension CameraManager {

}
private extension CameraManager {

}






// MARK: - Changing Exposure Duration
extension CameraManager {
    func changeExposureDuration(_ newExposureDuration: CMTime) throws { if let device = getCameraInput()?.device, newExposureDuration != attributes.cameraExposure.duration {
        try changeExposureDuration(newExposureDuration, device)
        updateExposureDuration(newExposureDuration)
    }}
}
private extension CameraManager {
    func changeExposureDuration(_ newExposureDuration: CMTime, _ device: any CaptureDevice) throws {
        try device.lockForConfiguration()
        try device.setExposureMode(.custom, duration: newExposureDuration, iso: attributes.cameraExposure.iso)
        device.unlockForConfiguration()
    }
    func updateExposureDuration(_ newExposureDuration: CMTime) {
        attributes.cameraExposure.duration = newExposureDuration
    }
}

// MARK: - Changing ISO
extension CameraManager {
    func changeISO(_ newISO: Float) throws { if let device = getCameraInput()?.device, newISO != attributes.cameraExposure.iso {
        try changeISO(newISO, device)
        updateISO(newISO)
    }}
}
private extension CameraManager {
    func changeISO(_ newISO: Float, _ device: any CaptureDevice) throws {
        try device.lockForConfiguration()
        try device.setExposureMode(.custom, duration: attributes.cameraExposure.duration, iso: newISO)
        device.unlockForConfiguration()
    }
    func updateISO(_ newISO: Float) {
        attributes.cameraExposure.iso = newISO
    }
}

// MARK: - Changing Exposure Target Bias
extension CameraManager {
    func changeExposureTargetBias(_ newExposureTargetBias: Float) throws { if let device = getCameraInput()?.device, newExposureTargetBias != attributes.cameraExposure.targetBias {
        try changeExposureTargetBias(newExposureTargetBias, device)
        updateExposureTargetBias(newExposureTargetBias)
    }}
}
private extension CameraManager {
    func changeExposureTargetBias(_ newExposureTargetBias: Float, _ device: any CaptureDevice) throws {
        try device.lockForConfiguration()
        try device.setExposureTargetBias(newExposureTargetBias)
        device.unlockForConfiguration()
    }
    func updateExposureTargetBias(_ newExposureTargetBias: Float) {
        attributes.cameraExposure.targetBias = newExposureTargetBias
    }
}

// MARK: - Changing Camera HDR Mode
extension CameraManager {
    func changeHDRMode(_ newHDRMode: CameraHDRMode) throws { if let device = getCameraInput()?.device, newHDRMode != attributes.hdrMode {
        try changeHDRMode(newHDRMode, device)
        updateHDRMode(newHDRMode)
    }}
}
private extension CameraManager {
    func changeHDRMode(_ newHDRMode: CameraHDRMode, _ device: any CaptureDevice) throws {
        try device.lockForConfiguration()
        device.hdrMode = newHDRMode
        device.unlockForConfiguration()
    }
    func updateHDRMode(_ newHDRMode: CameraHDRMode) {
        attributes.hdrMode = newHDRMode
    }
}

// MARK: - Changing Camera Resolution
extension CameraManager {
    func changeResolution(_ newResolution: AVCaptureSession.Preset) throws { if newResolution != attributes.resolution {
        captureSession.sessionPreset = newResolution
        attributes.resolution = newResolution
    }}
}

// MARK: - Changing Frame Rate
extension CameraManager {
    func changeFrameRate(_ newFrameRate: Int32) throws { if let device = getCameraInput()?.device, newFrameRate != attributes.frameRate {
        try updateFrameRate(newFrameRate, device)
        updateFrameRate(newFrameRate)
    }}
}
private extension CameraManager {
    func updateFrameRate(_ newFrameRate: Int32, _ device: any CaptureDevice) throws {
        try device.lockForConfiguration()
        try device.setFrameRate(newFrameRate)
        device.unlockForConfiguration()
    }
    func updateFrameRate(_ newFrameRate: Int32) {
        attributes.frameRate = newFrameRate
    }
}

// MARK: - Changing Mirror Mode
extension CameraManager {
    func changeMirrorMode(_ shouldMirror: Bool) { if !isChanging {
        attributes.mirrorOutput = shouldMirror
    }}
}

// MARK: - Changing Grid Mode
extension CameraManager {
    func changeGridVisibility(_ shouldShowGrid: Bool) { if !isChanging {
        cameraGridView.changeVisibility(shouldShowGrid)
    }}
}

// MARK: - Capturing Output
extension CameraManager {

}

// MARK: - Modifiers
extension CameraManager {
    var hasFlash: Bool { getCameraInput()?.device.hasFlash ?? false }
    var hasTorch: Bool { getCameraInput()?.device.hasTorch ?? false }
}

// MARK: - Helpers
extension CameraManager {
    func getCameraInput(_ position: CameraPosition? = nil) -> (any CaptureDeviceInput)? { switch position ?? attributes.cameraPosition {
        case .front: frontCameraInput
        case .back: backCameraInput
    }}
    var cameraView: UIView { cameraLayer.superview ?? .init() }
    var isChanging: Bool { cameraMetalView.isAnimating }
}


// MARK: - Errors
public enum MijickCameraError: Error {
    case microphonePermissionsNotGranted, cameraPermissionsNotGranted
    case cannotSetupInput, cannotSetupOutput
    case cannotCreateMetalDevice
}
