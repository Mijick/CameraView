//
//  Public+MCameraController.swift of MijickCameraView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2024 Mijick. Licensed under MIT License.


import SwiftUI

// MARK: - Initialiser
public extension MCameraController {
    init(manager: CameraManager) { self.init(cameraManager: manager) }
}

// MARK: - Changing Default Views
public extension MCameraController {
    /// Replaces the default Camera Screen with a new one of your choice (pass the initialiser as an argument of this method).
    /// For more information, see the project documentation (https://github.com/Mijick/CameraView)
    func cameraScreen(_ builder: @escaping CameraViewBuilder) -> Self { setAndReturnSelf { $0.config.cameraView = builder } }

    /// Replaces the default Media Preview Screen with a new one of your choice (pass the initialiser as an argument of this method).
    /// For more information, see the project documentation (https://github.com/Mijick/CameraView)
    func mediaPreviewScreen(_ builder: PreviewViewBuilder?) -> Self { setAndReturnSelf { $0.config.mediaPreviewView = builder } }

    /// Replaces the default Error Screen with a new one of your choice (pass the initialiser as an argument of this method).
    /// For more information, see the project documentation (https://github.com/Mijick/CameraView)
    func errorScreen(_ builder: @escaping ErrorViewBuilder) -> Self { setAndReturnSelf { $0.config.cameraErrorView = builder } }
}

// MARK: - Actions
public extension MCameraController {
    /// Sets the action to be triggered when the photo is taken. Passes the captured content as an argument
    func onImageCaptured(_ action: @escaping (UIImage) -> ()) -> Self { setAndReturnSelf { $0.config.onImageCaptured = action } }

    /// Sets the action to be triggered when the video is taken. Passes the captured content as an argument
    func onVideoCaptured(_ action: @escaping (URL) -> ()) -> Self { setAndReturnSelf { $0.config.onVideoCaptured = action } }

    /// Sets the action triggered when a photo or video is taken
    func afterMediaCaptured(_ action: @escaping (PostCameraConfig) -> (PostCameraConfig)) -> Self { setAndReturnSelf { $0.config.afterMediaCaptured = action } }

    /// Determines what happens when the Camera Controller should be closed
    func onCloseController(_ action: @escaping () -> ()) -> Self { setAndReturnSelf { $0.config.onCloseController = action } }
}

// MARK: - Others
public extension MCameraController {
    /// Locks the camera interface in portrait orientation (even if device screen rotation is enabled).
    /// For more information, see the project documentation (https://github.com/Mijick/CameraView)
    func lockOrientation(_ appDelegate: MApplicationDelegate.Type) -> Self { setAndReturnSelf { $0.config.appDelegate = appDelegate; $0.cameraManager.lockOrientation() } }
}
