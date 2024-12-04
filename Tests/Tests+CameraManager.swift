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
        try await cameraManager.setup(in: .init())
        await Task.sleep(seconds: 0.1)

        #expect(cameraManager.captureSession.isRunning)
        #expect(cameraManager.captureSession.deviceInputs.count == 2)
        #expect(cameraManager.photoOutput.parent != nil)
        #expect(cameraManager.videoOutput.parent != nil)
        #expect(cameraManager.captureSession.outputs.count == 3)
        #expect(cameraManager.cameraLayer.isHidden)
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

        try await cameraManager.setup(in: .init())
        await Task.sleep(seconds: 0.1)

        let device = cameraManager.getCameraInput()!.device

        #expect(device.uniqueID == cameraManager.frontCameraInput?.device.uniqueID)
        #expect(device.videoZoomFactor == 3.1)
        #expect(device.torchMode == .on)
        #expect(cameraManager.captureSession.sessionPreset == .hd1280x720)
        #expect(device.activeVideoMinFrameDuration == .init(value: 1, timescale: 60))
        #expect(device.activeVideoMaxFrameDuration == .init(value: 1, timescale: 60))
        #expect(device.exposureDuration == .init(value: 1, timescale: 10))
        #expect(device.exposureTargetBias == 0.66)
        #expect(device.iso == 0.5)
        #expect(device.exposureMode == .custom)
        #expect(device.hdrMode == .off)
        #expect(cameraManager.cameraGridView.alpha == 0)
    }
    @Test("Setup: Audio Source Unavailable") func setupWithAudioSourceUnavailable() async throws {
        cameraManager.attributes.isAudioSourceAvailable = false

        try await cameraManager.setup(in: .init())
        await Task.sleep(seconds: 0.1)

        #expect(cameraManager.captureSession.deviceInputs.count == 1)
    }

    // że nie przyznano uprawnień
    // potem akcje konkretne i sprawdzic wyniki
}
