//
//  Public+UI+DefaultCameraScreen.swift of MijickCamera
//
//  Created by Tomasz Kurylik. Sending ❤️ from Kraków!
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//    - Medium: https://medium.com/@mijick
//
//  Copyright ©2024 Mijick. All rights reserved.


import SwiftUI

// MARK: Initializer
public extension DefaultCameraScreen {
    init(cameraManager: CameraManager, namespace: Namespace.ID, closeMCameraAction: @escaping () -> Void) {
        self.init(cameraManager: cameraManager, namespace: namespace, closeMCameraAction: closeMCameraAction, config: .init())
    }
}

// MARK: Methods
public extension DefaultCameraScreen {
    func captureButtonAllowed(_ value: Bool) -> Self { config.captureButtonAllowed = value; return self }
    func cameraOutputSwitchAllowed(_ value: Bool) -> Self { config.cameraOutputSwitchAllowed = value; return self }
    func cameraPositionButtonAllowed(_ value: Bool) -> Self { config.cameraPositionButtonAllowed = value; return self }
    func flashButtonAllowed(_ value: Bool) -> Self { config.flashButtonAllowed = value; return self }
    func lightButtonAllowed(_ value: Bool) -> Self { config.lightButtonAllowed = value; return self }
    func flipButtonAllowed(_ value: Bool) -> Self { config.flipButtonAllowed = value; return self }
    func gridButtonAllowed(_ value: Bool) -> Self { config.gridButtonAllowed = value; return self }
}
