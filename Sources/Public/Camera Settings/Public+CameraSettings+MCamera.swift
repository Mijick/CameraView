//
//  Public+CameraSettings+MCamera.swift of MijickCamera
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

// MARK: Changing Initial Values
public extension MCamera {
    func setCameraOutputType(_ cameraOutputType: CameraOutputType) -> Self { manager.attributes.outputType = cameraOutputType; return self }
    func setCameraPosition(_ cameraPosition: CameraPosition) -> Self { manager.attributes.cameraPosition = cameraPosition; return self }
    func setAudioAvailability(_ isAvailable: Bool) -> Self { manager.attributes.isAudioSourceAvailable = isAvailable; return self }
    func setZoomFactor(_ zoomFactor: CGFloat) -> Self { manager.attributes.zoomFactor = zoomFactor; return self }
    func setFlashMode(_ flashMode: CameraFlashMode) -> Self { manager.attributes.flashMode = flashMode; return self }
    func setLightMode(_ lightMode: CameraLightMode) -> Self { manager.attributes.lightMode = lightMode; return self }
    func setResolution(_ resolution: AVCaptureSession.Preset) -> Self { manager.attributes.resolution = resolution; return self }
    func setFrameRate(_ frameRate: Int32) -> Self { manager.attributes.frameRate = frameRate; return self }
    func setCameraExposureDuration(_ duration: CMTime) -> Self { manager.attributes.cameraExposure.duration = duration; return self }
    func setCameraTargetBias(_ targetBias: Float) -> Self { manager.attributes.cameraExposure.targetBias = targetBias; return self }
    func setCameraISO(_ iso: Float) -> Self { manager.attributes.cameraExposure.iso = iso; return self }
    func setCameraExposureMode(_ exposureMode: AVCaptureDevice.ExposureMode) -> Self { manager.attributes.cameraExposure.mode = exposureMode; return self }
    func setCameraHDRMode(_ hdrMode: CameraHDRMode) -> Self { manager.attributes.hdrMode = hdrMode; return self }
    func setCameraFilters(_ filters: [CIFilter]) -> Self { manager.attributes.cameraFilters = filters; return self }
    func setMirrorOutput(_ shouldMirror: Bool) -> Self { manager.attributes.mirrorOutput = shouldMirror; return self }
    func setGridVisibility(_ shouldShowGrid: Bool) -> Self { manager.attributes.isGridVisible = shouldShowGrid; return self }
    func setFocusImage(_ image: UIImage) -> Self { manager.cameraMetalView.focusIndicator.image = image; return self }
    func setFocusImageColor(_ color: UIColor) -> Self { manager.cameraMetalView.focusIndicator.tintColor = color; return self }
    func setFocusImageSize(_ size: CGFloat) -> Self { manager.cameraMetalView.focusIndicator.size = size; return self }
}

// MARK: Actions
public extension MCamera {
    func setCloseMCameraAction(_ action: @escaping () -> ()) -> Self { config.closeMCameraAction = action; return self }
    func onImageCaptured(_ action: @escaping (UIImage, MCamera.Controller) -> ()) -> Self { config.imageCapturedAction = action; return self }
    func onVideoCaptured(_ action: @escaping (URL, MCamera.Controller) -> ()) -> Self { config.videoCapturedAction = action; return self }
}

// MARK: Others
public extension MCamera {
    func lockOrientation(_ appDelegate: MApplicationDelegate.Type) -> Self { config.appDelegate = appDelegate; manager.attributes.orientationLocked = true; return self }
    func start() -> some View { config.isCameraConfigured = true; return self }
}
