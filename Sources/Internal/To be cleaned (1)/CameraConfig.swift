//
//  CameraConfig.swift of MijickCameraView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2024 Mijick. Licensed under MIT License.


import SwiftUI

@MainActor struct CameraConfig {
    // MARK: Screens
    var cameraScreen: CameraScreenBuilder = DefaultCameraView.init
    var capturedMediaScreen: CapturedMediaScreenBuilder? = DefaultCameraPreview.init
    var errorScreen: ErrorScreenBuilder = DefaultCameraErrorView.init

    // MARK: Actions
    var onImageCaptured: (UIImage, MController) -> () = { _,_ in }
    var onVideoCaptured: (URL, MController) -> () = { _,_ in }
    var onCloseController: () -> () = {}

    // MARK: Others
    var appDelegate: MApplicationDelegate.Type? = nil
    var isInitialised: Bool = false
}
