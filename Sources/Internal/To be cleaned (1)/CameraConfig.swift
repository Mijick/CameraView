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
    // MARK: Default Views
    var cameraErrorView: ErrorViewBuilder = DefaultCameraErrorView.init
    var cameraView: CameraViewBuilder = DefaultCameraView.init
    var mediaPreviewView: PreviewViewBuilder? = DefaultCameraPreview.init

    // MARK: To Lock Orientation
    var appDelegate: MApplicationDelegate.Type? = nil

    // MARK: Actions
    var onImageCaptured: (UIImage) -> () = { _ in }
    var onVideoCaptured: (URL) -> () = { _ in }
    var afterMediaCaptured: (PostCameraConfig) -> (PostCameraConfig) = { _ in .init() }
    var onCloseController: () -> () = {}


    var isInitialised: Bool = false
}




// MARK: - Typealiases
public typealias CameraViewBuilder = (CameraManager, Namespace.ID, _ closeControllerAction: @escaping () -> ()) -> any MCameraView
public typealias PreviewViewBuilder = (MCameraMedia, Namespace.ID, _ retakeAction: @escaping () -> (), _ acceptMediaAction: @escaping () -> ()) -> any MCameraPreview
public typealias ErrorViewBuilder = (MijickCameraError, _ closeControllerAction: @escaping () -> ()) -> any MCameraErrorView
