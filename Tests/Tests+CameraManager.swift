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
    var cameraManager: MockedCameraManager = .init()
}

// MARK: Setup
extension CameraManagerTests {
    @Test("Setup with default attributes") func setupWithDefaultAttributes() async {
        cameraManager.setup(in: .init())

        #expect(!cameraManager.isRunning)
        #expect(cameraManager.captureSession.isRunning)
        #expect(cameraManager.captureSession.outputs.count == 3)
        #expect(cameraManager.captureSession.deviceInputs.count == 2)
        #expect(cameraManager.motionManager.accelerometerUpdateInterval > 0)

        await Task.sleep(seconds: 2)

        #expect(cameraManager.isRunning)
    }
    @Test("Setup with custom attributes") func setupWithCustomAttributes() {
    }


    // sprawdzić czy się inicjalizuje z customowymi wartościami
}





extension Task where Success == Never, Failure == Never {
    static func sleep(seconds: CGFloat) async {
        try! await Task.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
    }
}
