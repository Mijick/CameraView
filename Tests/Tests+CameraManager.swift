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
    var cameraManager: MockCameraManager = .init()
}

// MARK: Setup
extension CameraManagerTests {
    @Test("Setup: Default Attributes") func setupWithDefaultAttributes() async {
        cameraManager.setup(in: .init())

        #expect(cameraManager.captureSession.isRunning)
        #expect(cameraManager.captureSession.outputs.count == 3)
        #expect(cameraManager.captureSession.deviceInputs.count == 2)
        #expect(cameraManager.motionManager.accelerometerUpdateInterval > 0)
    }
    @Test("Setup: Custom Attributes (1)") func setupWithCustomAttributes_1() {
    }
    @Test("Setup: Custom Attributes (2)") func setupWithCustomAttributes_2() {
    }

    // co się stanei gdy audio source nie jest dostępne?
}









class MockCameraManager: CameraManager {
    init() { super.init(
        captureSession: MockCaptureSession(),
        fontCameraInput: MockDeviceInput.get(mediaType: .video, position: .front),
        backCameraInput: MockDeviceInput.get(mediaType: .video, position: .back),
        audioInput: MockDeviceInput.get(mediaType: .audio, position: .unspecified)
    )}
}
