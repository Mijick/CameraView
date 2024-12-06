//
//  MCameraControllerConfig.swift of MijickCamera
//
//  Created by Tomasz Kurylik. Sending ❤️ from Kraków!
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//    - Medium: https://medium.com/@mijick
//
//  Copyright ©2024 Mijick. All rights reserved.


import SwiftUI

extension MCameraController { @MainActor struct Config {
    // MARK: Screens
    var cameraScreen: CameraScreenBuilder = DefaultCameraScreen.init
    var capturedMediaScreen: CapturedMediaScreenBuilder? = DefaultCameraPreview.init
    var errorScreen: ErrorScreenBuilder = DefaultCameraErrorView.init

    // MARK: Actions
    var imageCapturedAction: (UIImage, MController) -> () = { _,_ in }
    var videoCapturedAction: (URL, MController) -> () = { _,_ in }
    var closeCameraControllerAction: () -> () = {}

    // MARK: Others
    var appDelegate: MApplicationDelegate.Type? = nil
    var isCameraControllerConfigured: Bool = false
}}
