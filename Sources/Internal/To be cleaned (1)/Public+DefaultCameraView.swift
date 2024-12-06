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
    func outputTypePickerVisible(_ value: Bool) -> Self { setAndReturnSelf { $0.config.cameraOutputSwitchAllowed = value } }
    func lightButtonVisible(_ value: Bool) -> Self { setAndReturnSelf { $0.config.lightButtonAllowed = value } }
    func captureButtonVisible(_ value: Bool) -> Self { setAndReturnSelf { $0.config.captureButtonAllowed = value } }
    func cameraPositionButtonVisible(_ value: Bool) -> Self { setAndReturnSelf { $0.config.cameraPositionButtonAllowed = value } }
    func gridButtonVisible(_ value: Bool) -> Self { setAndReturnSelf { $0.config.gridButtonAllowed = value } }
    func flipButtonVisible(_ value: Bool) -> Self { setAndReturnSelf { $0.config.flipButtonAllowed = value } }
    func flashButtonVisible(_ value: Bool) -> Self { setAndReturnSelf { $0.config.flashButtonAllowed = value } }
}
