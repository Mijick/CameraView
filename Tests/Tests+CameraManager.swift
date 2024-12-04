//
//  Tests+CameraManager.swift of MijickCamera
//
//  Created by Tomasz Kurylik. Sending ❤️ from Kraków!
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//    - Medium: https://medium.com/@mijick
//
//  Copyright ©2024 Mijick. All rights reserved.


import Testing
import SwiftUI
@testable import MijickCamera

@MainActor @Suite("Camera Manager Tests") struct CameraManagerTests {
    var cameraManager: CameraManager = .init(
        captureSession: MockCaptureSession(),
        fontCameraInput: MockDeviceInput.get(mediaType: .video, position: .front),
        backCameraInput: MockDeviceInput.get(mediaType: .video, position: .back),
        audioInput: MockDeviceInput.get(mediaType: .audio, position: .unspecified)
    )
}

// MARK: Setup
extension CameraManagerTests {
    @Test("Setup: Default Attributes") func setupWithDefaultAttributes() async throws {
        try await setupCamera()

        #expect(cameraManager.captureSession.isRunning == true)
        #expect(cameraManager.captureSession.deviceInputs.count == 2)
        #expect(cameraManager.photoOutput.parent != nil)
        #expect(cameraManager.videoOutput.parent != nil)
        #expect(cameraManager.captureSession.outputs.count == 3)
        #expect(cameraManager.cameraView != nil)
        #expect(cameraManager.cameraLayer.isHidden == true)
        #expect(cameraManager.cameraMetalView.parent != nil)
        #expect(cameraManager.cameraGridView.parent != nil)
        #expect(cameraManager.motionManager.manager.accelerometerUpdateInterval > 0)
        #expect(cameraManager.notificationCenterManager.parent != nil)
    }
    @Test("Setup: Custom Attributes") func setupWithCustomAttributes() async throws {
        cameraManager.attributes.cameraPosition = .front
        cameraManager.attributes.zoomFactor = 3.1
        cameraManager.attributes.torchMode = .on
        cameraManager.attributes.resolution = .hd1280x720
        cameraManager.attributes.frameRate = 60
        cameraManager.attributes.cameraExposure.duration = .init(value: 1, timescale: 10)
        cameraManager.attributes.cameraExposure.targetBias = 0.66
        cameraManager.attributes.cameraExposure.iso = 0.5
        cameraManager.attributes.cameraExposure.mode = .custom
        cameraManager.attributes.hdrMode = .off
        cameraManager.attributes.isGridVisible = false

        try await setupCamera()

        #expect(currentDevice.uniqueID == cameraManager.frontCameraInput?.device.uniqueID)
        #expect(currentDevice.videoZoomFactor == 3.1)
        #expect(currentDevice.torchMode == .on)
        #expect(cameraManager.captureSession.sessionPreset == .hd1280x720)
        #expect(currentDevice.activeVideoMinFrameDuration == .init(value: 1, timescale: 60))
        #expect(currentDevice.activeVideoMaxFrameDuration == .init(value: 1, timescale: 60))
        #expect(currentDevice.exposureDuration == .init(value: 1, timescale: 10))
        #expect(currentDevice.exposureTargetBias == 0.66)
        #expect(currentDevice.iso == 0.5)
        #expect(currentDevice.exposureMode == .custom)
        #expect(currentDevice.hdrMode == .off)
        #expect(cameraManager.cameraGridView.alpha == 0)

        // TODO: Sprawdzić jeszcze czy Attributes zostały poprawnie zmienione
    }
    @Test("Setup: Audio Source Unavailable") func setupWithAudioSourceUnavailable() async throws {
        cameraManager.attributes.isAudioSourceAvailable = false
        try await setupCamera()

        #expect(cameraManager.captureSession.deviceInputs.count == 1)
    }
}

// MARK: Cancel
extension CameraManagerTests {
    @Test("Cancel Camera Session") func cancelCameraSession() async throws {
        try await setupCamera()
        cameraManager.cancel()

        #expect(cameraManager.captureSession.isRunning == false)
        #expect(cameraManager.captureSession.deviceInputs.count == 0)
        #expect(cameraManager.captureSession.outputs.count == 0)
    }
}

// MARK: Set Camera Output
extension CameraManagerTests {
    @Test("Set Camera Output") func setCameraOutput() async throws {
        try await setupCamera()

        cameraManager.setOutputType(.photo)
        #expect(cameraManager.attributes.outputType == .photo)

        cameraManager.setOutputType(.video)
        #expect(cameraManager.attributes.outputType == .video)
    }
}

// MARK: Set Camera Position
extension CameraManagerTests {
    @Test("Set Camera Position") func setCameraPosition() async throws {
        try await setupCamera()

        try await cameraManager.setCameraPosition(.front)
        #expect(cameraManager.captureSession.deviceInputs.count == 2)
        #expect(currentDevice.uniqueID == cameraManager.frontCameraInput?.device.uniqueID)
        #expect(cameraManager.attributes.cameraPosition == .front)

        await Task.sleep(seconds: 0.5)

        try await cameraManager.setCameraPosition(.back)
        #expect(cameraManager.captureSession.deviceInputs.count == 2)
        #expect(currentDevice.uniqueID == cameraManager.backCameraInput?.device.uniqueID)
        #expect(cameraManager.attributes.cameraPosition == .back)
    }
}

// MARK: Set Camera Zoom
extension CameraManagerTests {
    @Test("Set Camera Zoom") func setCameraZoom() async throws {
        try await setupCamera()

        try cameraManager.setCameraZoomFactor(2.137)
        #expect(currentDevice.videoZoomFactor == 2.137)
        #expect(cameraManager.attributes.zoomFactor == 2.137)

        try cameraManager.setCameraZoomFactor(0.2137)
        #expect(currentDevice.videoZoomFactor == currentDevice.minAvailableVideoZoomFactor)
        #expect(cameraManager.attributes.zoomFactor == currentDevice.minAvailableVideoZoomFactor)

        try cameraManager.setCameraZoomFactor(213.7)
        #expect(currentDevice.videoZoomFactor == currentDevice.maxAvailableVideoZoomFactor)
        #expect(cameraManager.attributes.zoomFactor == currentDevice.maxAvailableVideoZoomFactor)
    }
}

// MARK: Set Camera Focus
extension CameraManagerTests {
    @Test("Set Camera Focus") func setCameraFocus() async throws {
        try await setupCamera()

        let point = CGPoint(x: 213.7, y: 21.37)
        let expectedPoint = CGPoint(x: point.y / cameraManager.cameraView.frame.height, y: 1 - point.x / cameraManager.cameraView.frame.width)

        try cameraManager.setCameraFocus(at: point)
        #expect(currentDevice.focusPointOfInterest == expectedPoint)
        #expect(currentDevice.exposurePointOfInterest == expectedPoint)
        #expect(currentDevice.focusMode == .autoFocus)
        #expect(currentDevice.exposureMode == .autoExpose)
        #expect(cameraManager.cameraView.subviews.filter { $0.tag == .focusIndicatorTag }.count == 1)
    }
}

// MARK: Set Flash Mode
extension CameraManagerTests {
    @Test("Set Flash Mode") func setFlashMode() async throws {
        try await setupCamera()

        cameraManager.setFlashMode(.on)
        #expect(cameraManager.attributes.flashMode == .on)

        cameraManager.setFlashMode(.auto)
        #expect(cameraManager.attributes.flashMode == .auto)

        cameraManager.setFlashMode(.off)
        #expect(cameraManager.attributes.flashMode == .off)
    }
}

// MARK: Set Torch Mode
extension CameraManagerTests {
    @Test("Set Torch Mode") func setTorchMode() async throws {
        try await setupCamera()

        try cameraManager.setTorchMode(.on)
        #expect(currentDevice.torchMode == .on)
        #expect(cameraManager.attributes.torchMode == .on)

        try cameraManager.setTorchMode(.off)
        #expect(currentDevice.torchMode == .off)
        #expect(cameraManager.attributes.torchMode == .off)
    }
}

// MARK: Set Mirror Output
extension CameraManagerTests {
    @Test("Set Mirror Output") func setMirrorOutput() async throws {
        try await setupCamera()

        cameraManager.setMirrorOutput(true)
        #expect(cameraManager.attributes.mirrorOutput == true)

        cameraManager.setMirrorOutput(false)
        #expect(cameraManager.attributes.mirrorOutput == false)
    }
}

// MARK: Set Grid Visibility
extension CameraManagerTests {
    @Test("Set Grid Visibility") func setGridVisibility() async throws {
        try await setupCamera()

        cameraManager.setGridVisibility(true)
        #expect(cameraManager.cameraGridView.alpha == 1)
        #expect(cameraManager.attributes.isGridVisible == true)

        cameraManager.setGridVisibility(false)
        #expect(cameraManager.cameraGridView.alpha == 0)
        #expect(cameraManager.attributes.isGridVisible == false)
    }
}

// MARK: Set Camera Filters
extension CameraManagerTests {
    @Test("Set Camera Filters") func setCameraFilters() async throws {
        try await setupCamera()

        cameraManager.setCameraFilters([.init(name: "CISepiaTone")!])
        #expect(cameraManager.attributes.cameraFilters.count == 1)
    }
}

// MARK: Set Exposure Mode
extension CameraManagerTests {
    @Test("Set Exposure Mode") func setExposureMode() async throws {
    }
}

// MARK: Set Exposure Duration
extension CameraManagerTests {
    @Test("Set Exposure Duration") func setExposureDuration() async throws {
    }
}

// MARK: Set ISO
extension CameraManagerTests {
    @Test("Set ISO") func setISO() async throws {
    }
}

// MARK: Set Exposure Target Bias
extension CameraManagerTests {
    @Test("Set Exposure Target Bias") func setExposureTargetBias() async throws {
    }
}

// MARK: Set HDR Mode
extension CameraManagerTests {
    @Test("Set HDR Mode") func setHDRMode() async throws {
    }
}

// MARK: Set Resolution
extension CameraManagerTests {
    @Test("Set Resolution") func setResolution() async throws {

    }
}

// MARK: Set Frame Rate
extension CameraManagerTests {
    @Test("Set Frame Rate") func setFrameRate() async throws {
    }
}


// MARK: Helpers
private extension CameraManagerTests {
    func setupCamera() async throws {
        let cameraView = UIView(frame: .init(origin: .zero, size: .init(width: 1000, height: 1000)))

        try await cameraManager.setup(in: cameraView)
        await Task.sleep(seconds: 0.15)
    }
}
private extension CameraManagerTests {
    var currentDevice: any CaptureDevice { cameraManager.getCameraInput()!.device }
}




extension Int {
    static var blurViewTag: Int { 2137 }
    static var focusIndicatorTag: Int { 29 }
}
