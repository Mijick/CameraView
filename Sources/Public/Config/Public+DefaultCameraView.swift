//
//  Public+DefaultCameraView.swift of MijickCameraView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2024 Mijick. Licensed under MIT License.


import SwiftUI

// MARK: - Initialiser
public extension DefaultCameraView {
    init(cameraManager: CameraManager, namespace: Namespace.ID, closeControllerAction: @escaping () -> Void) {
        self.init(cameraManager: cameraManager, namespace: namespace, closeControllerAction: closeControllerAction, config: .init())
    }
}

// MARK: - Customising View
public extension DefaultCameraView {
    func outputTypePickerVisible(_ value: Bool) -> Self { setAndReturnSelf { $0.config.outputTypePickerVisible = value } }
    func lightButtonVisible(_ value: Bool) -> Self { setAndReturnSelf { $0.config.lightButtonVisible = value } }
    func captureButtonVisible(_ value: Bool) -> Self { setAndReturnSelf { $0.config.captureButtonVisible = value } }
    func cameraPositionButtonVisible(_ value: Bool) -> Self { setAndReturnSelf { $0.config.changeCameraButtonVisible = value } }
    func gridButtonVisible(_ value: Bool) -> Self { setAndReturnSelf { $0.config.gridButtonVisible = value } }
    func flipButtonVisible(_ value: Bool) -> Self { setAndReturnSelf { $0.config.flipButtonVisible = value } }
    func flashButtonVisible(_ value: Bool) -> Self { setAndReturnSelf { $0.config.flashButtonVisible = value } }
}
