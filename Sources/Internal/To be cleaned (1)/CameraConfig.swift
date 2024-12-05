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
    var onImageCaptured: (UIImage) -> () = { _ in }
    var onVideoCaptured: (URL) -> () = { _ in }
    var afterMediaCaptured: (PostCameraConfig) -> (PostCameraConfig) = { _ in .init() }
    var onCloseController: () -> () = {}

    // MARK: Others
    var appDelegate: MApplicationDelegate.Type? = nil
    var isInitialised: Bool = false
}




// MARK: - Typealiases
public typealias CameraScreenBuilder = (CameraManager, Namespace.ID, _ closeControllerAction: @escaping () -> ()) -> any MCameraView
public typealias CapturedMediaScreenBuilder = (MCameraMedia, Namespace.ID, _ retakeAction: @escaping () -> (), _ acceptMediaAction: @escaping () -> ()) -> any MCameraPreview
public typealias ErrorScreenBuilder = (MijickCameraError, _ closeControllerAction: @escaping () -> ()) -> any MCameraErrorView
