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
        cameraManager.attributes.zoomFactor = 2137
        cameraManager.attributes.lightMode = .on
        cameraManager.attributes.resolution = .hd1280x720
        cameraManager.attributes.frameRate = 666
        cameraManager.attributes.cameraExposure.duration = .init(value: 1, timescale: 10)
        cameraManager.attributes.cameraExposure.targetBias = 0.66
        cameraManager.attributes.cameraExposure.iso = 2000
        cameraManager.attributes.cameraExposure.mode = .custom
        cameraManager.attributes.hdrMode = .off
        cameraManager.attributes.isGridVisible = false

        try await setupCamera()

        #expect(currentDevice.uniqueID == cameraManager.frontCameraInput?.device.uniqueID)
        #expect(currentDevice.videoZoomFactor == currentDevice.maxAvailableVideoZoomFactor)
        #expect(currentDevice.lightMode == .on)
        #expect(cameraManager.captureSession.sessionPreset == .hd1280x720)
        #expect(currentDevice.activeVideoMinFrameDuration == .init(value: 1, timescale: Int32(currentDevice.maxFrameRate!)))
        #expect(currentDevice.activeVideoMaxFrameDuration == .init(value: 1, timescale: Int32(currentDevice.maxFrameRate!)))
        #expect(currentDevice.exposureDuration == .init(value: 1, timescale: 10))
        #expect(currentDevice.exposureTargetBias == 0.66)
        #expect(currentDevice.iso == currentDevice.maxISO)
        #expect(currentDevice.exposureMode == .custom)
        #expect(currentDevice.hdrMode == .off)
        #expect(cameraManager.cameraGridView.alpha == 0)

        #expect(cameraManager.attributes.zoomFactor == currentDevice.maxAvailableVideoZoomFactor)
        #expect(cameraManager.attributes.frameRate == Int32(currentDevice.maxFrameRate!))
        #expect(cameraManager.attributes.cameraExposure.iso == currentDevice.maxISO)
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

        await Task.sleep(seconds: 0.5)

        try cameraManager.setCameraZoomFactor(3.2)
        try await cameraManager.setCameraPosition(.front)
        #expect(currentDevice.videoZoomFactor == 1)
        #expect(cameraManager.attributes.zoomFactor == 1)
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

// MARK: Set Light Mode
extension CameraManagerTests {
    @Test("Set Light Mode") func setLightMode() async throws {
        try await setupCamera()

        try cameraManager.setLightMode(.on)
        #expect(currentDevice.lightMode == .on)
        #expect(cameraManager.attributes.lightMode == .on)

        try cameraManager.setLightMode(.off)
        #expect(currentDevice.lightMode == .off)
        #expect(cameraManager.attributes.lightMode == .off)
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
        try await setupCamera()

        try cameraManager.setExposureMode(.continuousAutoExposure)
        #expect(currentDevice.exposureMode == .continuousAutoExposure)
        #expect(cameraManager.attributes.cameraExposure.mode == .continuousAutoExposure)

        try cameraManager.setExposureMode(.autoExpose)
        #expect(currentDevice.exposureMode == .autoExpose)
        #expect(cameraManager.attributes.cameraExposure.mode == .autoExpose)

        try cameraManager.setExposureMode(.custom)
        #expect(currentDevice.exposureMode == .custom)
        #expect(cameraManager.attributes.cameraExposure.mode == .custom)
    }
}

// MARK: Set Exposure Duration
extension CameraManagerTests {
    @Test("Set Exposure Duration") func setExposureDuration() async throws {
        try await setupCamera()

        try cameraManager.setExposureDuration(.init(value: 1, timescale: 33))
        #expect(currentDevice.exposureDuration == .init(value: 1, timescale: 33))
        #expect(currentDevice.exposureMode == .custom)
        #expect(cameraManager.attributes.cameraExposure.duration == .init(value: 1, timescale: 33))

        try cameraManager.setExposureDuration(.init(value: 1, timescale: 100000))
        #expect(currentDevice.exposureDuration == currentDevice.minExposureDuration)
        #expect(currentDevice.exposureMode == .custom)
        #expect(cameraManager.attributes.cameraExposure.duration == currentDevice.minExposureDuration)

        try cameraManager.setExposureDuration(.init(value: 1, timescale: 2))
        #expect(currentDevice.exposureDuration == currentDevice.maxExposureDuration)
        #expect(currentDevice.exposureMode == .custom)
        #expect(cameraManager.attributes.cameraExposure.duration == currentDevice.maxExposureDuration)
    }
}

// MARK: Set ISO
extension CameraManagerTests {
    @Test("Set ISO") func setISO() async throws {
        try await setupCamera()

        try cameraManager.setISO(1)
        #expect(currentDevice.iso == 1)
        #expect(currentDevice.exposureMode == .custom)
        #expect(cameraManager.attributes.cameraExposure.iso == 1)

        try cameraManager.setISO(-2137)
        #expect(currentDevice.iso == currentDevice.minISO)
        #expect(currentDevice.exposureMode == .custom)
        #expect(cameraManager.attributes.cameraExposure.iso == currentDevice.minISO)

        try cameraManager.setISO(2137)
        #expect(currentDevice.iso == currentDevice.maxISO)
        #expect(currentDevice.exposureMode == .custom)
        #expect(cameraManager.attributes.cameraExposure.iso == currentDevice.maxISO)
    }
}

// MARK: Set Exposure Target Bias
extension CameraManagerTests {
    @Test("Set Exposure Target Bias") func setExposureTargetBias() async throws {
        try await setupCamera()

        try cameraManager.setExposureTargetBias(1)
        #expect(currentDevice.exposureTargetBias == 1)
        #expect(cameraManager.attributes.cameraExposure.targetBias == 1)

        try cameraManager.setExposureTargetBias(-2137)
        #expect(currentDevice.exposureTargetBias == currentDevice.minExposureTargetBias)
        #expect(cameraManager.attributes.cameraExposure.targetBias == currentDevice.minExposureTargetBias)

        try cameraManager.setExposureTargetBias(2137)
        #expect(currentDevice.exposureTargetBias == currentDevice.maxExposureTargetBias)
        #expect(cameraManager.attributes.cameraExposure.targetBias == currentDevice.maxExposureTargetBias)
    }
}

// MARK: Set HDR Mode
extension CameraManagerTests {
    @Test("Set HDR Mode") func setHDRMode() async throws {
        try await setupCamera()

        try cameraManager.setHDRMode(.on)
        #expect(currentDevice.hdrMode == .on)
        #expect(cameraManager.attributes.hdrMode == .on)

        try cameraManager.setHDRMode(.off)
        #expect(currentDevice.hdrMode == .off)
        #expect(cameraManager.attributes.hdrMode == .off)

        try cameraManager.setHDRMode(.auto)
        #expect(currentDevice.hdrMode == .auto)
        #expect(cameraManager.attributes.hdrMode == .auto)
    }
}

// MARK: Set Resolution
extension CameraManagerTests {
    @Test("Set Resolution") func setResolution() async throws {
        try await setupCamera()

        cameraManager.setResolution(.hd1280x720)
        #expect(cameraManager.captureSession.sessionPreset == .hd1280x720)
        #expect(cameraManager.attributes.resolution == .hd1280x720)

        cameraManager.setResolution(.hd1920x1080)
        #expect(cameraManager.captureSession.sessionPreset == .hd1920x1080)
        #expect(cameraManager.attributes.resolution == .hd1920x1080)

        cameraManager.setResolution(.cif352x288)
        #expect(cameraManager.captureSession.sessionPreset == .cif352x288)
        #expect(cameraManager.attributes.resolution == .cif352x288)
    }
}

// MARK: Set Frame Rate
extension CameraManagerTests {
    @Test("Set Frame Rate") func setFrameRate() async throws {
        try await setupCamera()

        try cameraManager.setFrameRate(45)
        #expect(currentDevice.activeVideoMinFrameDuration == .init(value: 1, timescale: 45))
        #expect(currentDevice.activeVideoMaxFrameDuration == .init(value: 1, timescale: 45))
        #expect(cameraManager.attributes.frameRate == 45)

        try cameraManager.setFrameRate(10)
        #expect(currentDevice.activeVideoMinFrameDuration.timescale == Int32(currentDevice.minFrameRate!))
        #expect(currentDevice.activeVideoMaxFrameDuration.timescale == Int32(currentDevice.minFrameRate!))
        #expect(cameraManager.attributes.frameRate == Int32(currentDevice.minFrameRate!))

        try cameraManager.setFrameRate(100)
        #expect(currentDevice.activeVideoMinFrameDuration.timescale == Int32(currentDevice.maxFrameRate!))
        #expect(currentDevice.activeVideoMaxFrameDuration.timescale == Int32(currentDevice.maxFrameRate!))
        #expect(cameraManager.attributes.frameRate == Int32(currentDevice.maxFrameRate!))
    }
}


// MARK: Helpers
private extension CameraManagerTests {
    func setupCamera() async throws {
        let cameraView = UIView(frame: .init(origin: .zero, size: .init(width: 1000, height: 1000)))

        cameraManager.initialize(in: cameraView)
        try await cameraManager.setup()
        await Task.sleep(seconds: 1.5)
    }
}
private extension CameraManagerTests {
    var currentDevice: any CaptureDevice { cameraManager.getCameraInput()!.device }
}
