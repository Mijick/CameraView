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
    /**
     Changes the camera screen to a selected one.

     For more details and tips on creating your own **Camera Screen**, see the ``MCameraScreen`` documentation.

     - tip: To hide selected buttons and controls on the screen, use the method with DefaultCameraScreen as argument. For a code example, please refer to Usage -> Default Camera Screen Customization section.


     # Usage

     ## New Camera Screen
     ```swift
     struct ContentView: View {
        var body: some View {
            MCamera()
                .setCameraScreen(CustomCameraScreen.init)

                // MUST BE CALLED!
                .startSession()
        }
     }
     ```

     ## Default Camera Screen Customization
     ```swift
     struct ContentView: View {
        var body: some View {
            MCamera()
                .setCameraScreen {
                    DefaultCameraScreen(cameraManager: $0, namespace: $1, closeMCameraAction: $2)
                        .captureButtonAllowed(false)
                        .cameraOutputSwitchAllowed(false)
                        .lightButtonAllowed(false)
                }

                // MUST BE CALLED!
                .startSession()
        }
     }
     ```
     */
    func setCameraScreen(_ builder: @escaping CameraScreenBuilder) -> Self { config.cameraScreen = builder; return self }

    /**
     Changes the captured media screen to a selected one.

     For more details and tips on creating your own **Captured Media Screen**, see the ``MCapturedMediaScreen`` documentation.

     - tip: To disable displaying captured media, call the method with a nil value.


     # Usage

     ## New Captured Media Screen
     ```swift
     struct ContentView: View {
        var body: some View {
            MCamera()
                .setCapturedMediaScreen(DefaultCapturedMediaScreen.init)

                // MUST BE CALLED!
                .startSession()
        }
     }
     ```

     ## No Captured Media Screen
     ```swift
     struct ContentView: View {
        var body: some View {
            MCamera()
                .setCapturedMediaScreen(nil)

                // MUST BE CALLED!
                .startSession()
        }
     }
     ```
     */
    func setCapturedMediaScreen(_ builder: CapturedMediaScreenBuilder?) -> Self { config.capturedMediaScreen = builder; return self }

    /**
     Changes the error screen to a selected one.

     For more details and tips on creating your own **Error Screen**, see the ``MCameraErrorScreen`` documentation.


     ## Usage
     ```swift
     struct ContentView: View {
        var body: some View {
            MCamera()
                .setErrorScreen(CustomCameraErrorScreen.init)

                // MUST BE CALLED!
                .startSession()
        }
     }
     ```
     */
    func setErrorScreen(_ builder: @escaping ErrorScreenBuilder) -> Self { config.errorScreen = builder; return self }
}

// MARK: Changing Initial Values
public extension MCamera {
    /**
     Changes the initial camera output type.

     For available options, please refer to the ``CameraOutputType`` documentation.
     */
    func setCameraOutputType(_ cameraOutputType: CameraOutputType) -> Self { manager.attributes.outputType = cameraOutputType; return self }

    /**
     Changes the initial camera position.

     For available options, please refer to the ``CameraPosition`` documentation
     */
    func setCameraPosition(_ cameraPosition: CameraPosition) -> Self { manager.attributes.cameraPosition = cameraPosition; return self }

    /**
     Definies whether the audio source is available.

     If disabled, the camera will not record audio, and will not ask for permission to access the microphone.
     */
    func setAudioAvailability(_ isAvailable: Bool) -> Self { manager.attributes.isAudioSourceAvailable = isAvailable; return self }

    /**
     Changes the initial camera zoom level.
     */
    func setZoomFactor(_ zoomFactor: CGFloat) -> Self { manager.attributes.zoomFactor = zoomFactor; return self }

    /**
     Changes the initial camera flash mode.

     For available options, please refer to the ``CameraFlashMode`` documentation.
     */
    func setFlashMode(_ flashMode: CameraFlashMode) -> Self { manager.attributes.flashMode = flashMode; return self }

    /**
     Changes the initial light (torch / flashlight) mode.

     For available options, please refer to the ``CameraLightMode`` documentation.
     */
    func setLightMode(_ lightMode: CameraLightMode) -> Self { manager.attributes.lightMode = lightMode; return self }

    /**
     Changes the initial camera resolution.

     - important: Changing the resolution may affect the maximum frame rate that can be set.
     */
    func setResolution(_ resolution: AVCaptureSession.Preset) -> Self { manager.attributes.resolution = resolution; return self }

    /**
     Changes the initial camera frame rate.

     - important: Depending on the resolution of the camera and the current specifications of the device, there are some restrictions on the frame rate that can be set. If you set a frame rate that exceeds the camera's capabilities, the library will automatically set the closest possible value and show you which value has been set (``MCameraScreen/frameRate``).
     */
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
    func startSession() -> some View { config.isCameraConfigured = true; return self }
}
