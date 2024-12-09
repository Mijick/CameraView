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
import AVKit

// MARK: - Initialiser
public extension MCameraView {
    init() { self.init(manager: .init(
        captureSession: AVCaptureSession(),
        fontCameraInput: AVCaptureDeviceInput.get(mediaType: .video, position: .front),
        backCameraInput: AVCaptureDeviceInput.get(mediaType: .video, position: .back),
        audioInput: AVCaptureDeviceInput.get(mediaType: .audio, position: .unspecified)
    ))}
}

// MARK: - Changing Default Views
public extension MCameraView {
    /// Replaces the default Camera Screen with a new one of your choice (pass the initialiser as an argument of this method).
    /// For more information, see the project documentation (https://github.com/Mijick/CameraView)
    func cameraScreen(_ builder: @escaping CameraScreenBuilder) -> Self { config.cameraScreen = builder; return self }

    /// Replaces the default Media Preview Screen with a new one of your choice (pass the initialiser as an argument of this method).
    /// For more information, see the project documentation (https://github.com/Mijick/CameraView)
    func mediaPreviewScreen(_ builder: CapturedMediaScreenBuilder?) -> Self { config.capturedMediaScreen = builder; return self }

    /// Replaces the default Error Screen with a new one of your choice (pass the initialiser as an argument of this method).
    /// For more information, see the project documentation (https://github.com/Mijick/CameraView)
    func errorScreen(_ builder: @escaping ErrorScreenBuilder) -> Self { config.errorScreen = builder; return self }
}

// MARK: - Actions
public extension MCameraView {
    /// Sets the action to be triggered when the photo is taken. Passes the captured content as an argument
    func onImageCaptured(_ action: @escaping (UIImage, MController) -> ()) -> Self { config.imageCapturedAction = action; return self }

    /// Sets the action to be triggered when the video is taken. Passes the captured content as an argument
    func onVideoCaptured(_ action: @escaping (URL, MController) -> ()) -> Self { config.videoCapturedAction = action; return self }

    /// Determines what happens when the Camera Controller should be closed
    func onCloseController(_ action: @escaping () -> ()) -> Self { config.closeCameraControllerAction = action; return self }
}

// MARK: - Others
public extension MCameraView {
    /// Locks the camera interface in portrait orientation (even if device screen rotation is enabled).
    /// For more information, see the project documentation (https://github.com/Mijick/CameraView)
    func lockOrientation(_ appDelegate: MApplicationDelegate.Type) -> Self { config.appDelegate = appDelegate; manager.attributes.orientationLocked = true; return self }
}



public extension MCameraView {
    func outputType(_ type: CameraOutputType) -> Self { manager.attributes.outputType = type; return self }
    func cameraPosition(_ position: CameraPosition) -> Self { manager.attributes.cameraPosition = position; return self }
    func cameraFilters(_ filters: [CIFilter]) -> Self { manager.attributes.cameraFilters = filters; return self }
    func resolution(_ resolution: AVCaptureSession.Preset) -> Self { manager.attributes.resolution = resolution; return self }
    func frameRate(_ frameRate: Int32) -> Self { self.manager.attributes.frameRate = frameRate; return self }
    func flashMode(_ mode: CameraFlashMode) -> Self { manager.attributes.flashMode = mode; return self }
    func gridVisibility(_ isVisible: Bool) -> Self { manager.attributes.isGridVisible = isVisible; return self }

    func focusImage(_ image: UIImage) -> Self {  manager.cameraMetalView.focusIndicatorConfig.image = image; return self }
    func focusImageColor(_ color: UIColor) -> Self {  manager.cameraMetalView.focusIndicatorConfig.tintColor = color; return self }
    func focusImageSize(_ size: CGFloat) -> Self {  manager.cameraMetalView.focusIndicatorConfig.size = size; return self }
}



public extension MCameraView {
    func start() -> some View { config.isCameraControllerConfigured = true; return self }
}




// MARK: - Typealiases
public typealias CameraScreenBuilder = (CameraManager, Namespace.ID, _ closeControllerAction: @escaping () -> ()) -> any MCameraScreen
public typealias CapturedMediaScreenBuilder = (MCameraMedia, Namespace.ID, _ retakeAction: @escaping () -> (), _ acceptMediaAction: @escaping () -> ()) -> any MCapturedMediaScreen
public typealias ErrorScreenBuilder = (MijickCameraError, _ closeControllerAction: @escaping () -> ()) -> any MCameraErrorScreen
