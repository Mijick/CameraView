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

// MARK: - Initial Camera Settings
public extension MCameraController {
    /// Changes the initial setting of Camera Output Type
    func outputType(_ type: CameraOutputType) -> Self { setAndReturnSelf { $0.cameraManager.change(outputType: type) } }

    /// Changes the initial setting of Camera Position
    func cameraPosition(_ position: CameraPosition) -> Self { setAndReturnSelf { $0.cameraManager.change(cameraPosition: position) } }

    /// Changes the initial setting of Camera Flash Mode
    func flashMode(_ flashMode: CameraFlashMode) -> Self { setAndReturnSelf { $0.cameraManager.change(flashMode: flashMode) } }

    /// Changes the initial setting of Camera Grid View Visibility
    func gridVisible(_ visible: Bool) -> Self { setAndReturnSelf { $0.cameraManager.change(isGridVisible: visible) } }

    /// Changes the Focus Image that is displayed when the camera screen is tapped
    func focusImage(_ focusImage: UIImage) -> Self { setAndReturnSelf { $0.cameraManager.change(focusImage: focusImage) } }

    /// Changes the color of Focus Image that is displayed when the camera screen is tapped
    func focusImageColor(_ color: UIColor) -> Self { setAndReturnSelf { $0.cameraManager.change(focusImageColor: color) } }

    /// Changes the size of Focus Image that is displayed when the camera screen is tapped
    func focusImageSize(_ size: CGFloat) -> Self { setAndReturnSelf { $0.cameraManager.change(focusImageSize: size) } }

    /// Locks the camera interface in portrait orientation (even if device screen rotation is enabled).
    /// For more information, see the project documentation (https://github.com/Mijick/CameraView)
    func lockOrientation(_ appDelegate: MApplicationDelegate.Type) -> Self { setAndReturnSelf { $0.config.appDelegate = appDelegate; $0.cameraManager.lockOrientation() } }
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

// MARK: - Changing Camera Filters
public extension MCameraController {
    /// Changes the camera filters. Applies to both camera live preview and camera output.
    /// For more information, see the project documentation (https://github.com/Mijick/CameraView)
    func changeCameraFilters(_ cameraFilters: [CIFilter]) -> Self { setAndReturnSelf { $0.cameraManager.change(cameraFilters: cameraFilters) } }
}

// MARK: - Actions
public extension MCameraController {
    /// Sets the action to be triggered when the photo is taken. Passes the captured content as an argument
    func onImageCaptured(_ action: @escaping (CIImage) -> ()) -> Self { setAndReturnSelf { $0.config.onImageCaptured = action } }

    /// Sets the action to be triggered when the video is taken. Passes the captured content as an argument
    func onVideoCaptured(_ action: @escaping (URL) -> ()) -> Self { setAndReturnSelf { $0.config.onVideoCaptured = action } }

    /// Sets the action triggered when a photo or video is taken
    func afterMediaCaptured(_ action: @escaping () -> ()) -> Self { setAndReturnSelf { $0.config.afterMediaCaptured = action } }

    /// Determines what happens when the Camera Controller should be closed
    func onCloseController(_ action: @escaping () -> ()) -> Self { setAndReturnSelf { $0.config.onCloseController = action } }
}
