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
    @Test("Setup") func setup() {
        cameraManager.setup(in: .init())

        #expect(cameraManager.captureSession.isRunning)
        #expect(cameraManager.captureSession.outputs.count == 3)
    }
}
