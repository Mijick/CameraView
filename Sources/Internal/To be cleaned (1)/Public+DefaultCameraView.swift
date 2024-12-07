//
//  Public+DefaultCameraScreen.swift of MijickCameraView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2024 Mijick. Licensed under MIT License.


import SwiftUI

// MARK: - Initialiser
public extension DefaultCameraScreen {
    init(cameraManager: CameraManager, namespace: Namespace.ID, closeControllerAction: @escaping () -> Void) {
        self.init(cameraManager: cameraManager, namespace: namespace, closeControllerAction: closeControllerAction, config: .init())
    }
}

// MARK: - Customising View
public extension DefaultCameraScreen {
    func outputTypePickerVisible(_ value: Bool) -> Self { config.cameraOutputSwitchAllowed = value; return self }
    func lightButtonVisible(_ value: Bool) -> Self { config.lightButtonAllowed = value; return self }
    func captureButtonVisible(_ value: Bool) -> Self { config.captureButtonAllowed = value; return self }
    func cameraPositionButtonVisible(_ value: Bool) -> Self { config.cameraPositionButtonAllowed = value; return self }
    func gridButtonVisible(_ value: Bool) -> Self { config.gridButtonAllowed = value; return self }
    func flipButtonVisible(_ value: Bool) -> Self { config.flipButtonAllowed = value; return self }
    func flashButtonVisible(_ value: Bool) -> Self { config.flashButtonAllowed = value; return self }
}



@MainActor public struct MController {
    let cameraController: MCameraController
}


public extension MController {
    func closeController() {
        cameraController.config.closeCameraControllerAction()
    }
    func back() {
        cameraController.cameraManager.attributes.capturedMedia = nil
    }
}
