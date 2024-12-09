//
//  Public+MCamera.swift of MijickCamera
//
//  Created by Tomasz Kurylik. Sending ❤️ from Kraków!
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//    - Medium: https://medium.com/@mijick
//
//  Copyright ©2024 Mijick. All rights reserved.


import SwiftUI
import AVKit

// MARK: Initializer
public extension MCamera {
    init() { self.init(manager: .init(
        captureSession: AVCaptureSession(),
        fontCameraInput: AVCaptureDeviceInput.get(mediaType: .video, position: .front),
        backCameraInput: AVCaptureDeviceInput.get(mediaType: .video, position: .back),
        audioInput: AVCaptureDeviceInput.get(mediaType: .audio, position: .unspecified)
    ))}
}


// MARK: - METHODS



// MARK: Changing Default Screens
public extension MCamera {
    func setCameraScreen(_ builder: @escaping CameraScreenBuilder) -> Self { config.cameraScreen = builder; return self }
    func setCapturedMediaScreen(_ builder: CapturedMediaScreenBuilder?) -> Self { config.capturedMediaScreen = builder; return self }
    func setErrorScreen(_ builder: @escaping ErrorScreenBuilder) -> Self { config.errorScreen = builder; return self }
}

// MARK: Actions
public extension MCamera {
    func onImageCaptured(_ action: @escaping (UIImage, MCameraController) -> ()) -> Self { config.imageCapturedAction = action; return self }
    func onVideoCaptured(_ action: @escaping (URL, MCameraController) -> ()) -> Self { config.videoCapturedAction = action; return self }
    func onCloseController(_ action: @escaping () -> ()) -> Self { config.closeMCameraAction = action; return self }
}

// MARK: Others
public extension MCamera {
    func lockOrientation(_ appDelegate: MApplicationDelegate.Type) -> Self { config.appDelegate = appDelegate; manager.attributes.orientationLocked = true; return self }
}



public extension MCamera {
    func setCameraOutputType(_ cameraOutputType: CameraOutputType) -> Self { manager.attributes.outputType = cameraOutputType; return self }
    func setCameraPosition(_ cameraPosition: CameraPosition) -> Self { manager.attributes.cameraPosition = cameraPosition; return self }
    func setAudioAvailability(_ isAvailable: Bool) -> Self { manager.attributes.isAudioSourceAvailable = isAvailable; return self }
    func setZoomFactor(_ zoomFactor: CGFloat) -> Self { manager.attributes.zoomFactor = zoomFactor; return self }
    func setFlashMode(_ flashMode: CameraFlashMode) -> Self { manager.attributes.flashMode = flashMode; return self }
    func setLightMode(_ lightMode: CameraLightMode) -> Self { manager.attributes.lightMode = lightMode; return self }
    func setResolution(_ resolution: AVCaptureSession.Preset) -> Self { manager.attributes.resolution = resolution; return self }
    func setFrameRate(_ frameRate: Int32) -> Self { manager.attributes.frameRate = frameRate; return self }
    






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



public extension MCamera {
    func start() -> some View { config.isCameraConfigured = true; return self }
}




// MARK: - Typealiases
public typealias CameraScreenBuilder = (CameraManager, Namespace.ID, _ closeControllerAction: @escaping () -> ()) -> any MCameraScreen
public typealias CapturedMediaScreenBuilder = (MCameraMedia, Namespace.ID, _ retakeAction: @escaping () -> (), _ acceptMediaAction: @escaping () -> ()) -> any MCapturedMediaScreen
public typealias ErrorScreenBuilder = (MijickCameraError, _ closeControllerAction: @escaping () -> ()) -> any MCameraErrorScreen