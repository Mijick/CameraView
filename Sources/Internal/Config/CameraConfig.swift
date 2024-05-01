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

struct CameraConfig {
    // MARK: Default Views
    var cameraErrorView: ErrorViewBuilder = DefaultCameraErrorView.init
    var cameraView: CameraViewBuilder = DefaultCameraView.init
    var mediaPreviewView: PreviewViewBuilder? = DefaultCameraPreview.init

    // MARK: To Lock Orientation
    var appDelegate: MApplicationDelegate.Type? = nil

    // MARK: Actions
    var onImageCaptured: (Data) -> () = { _ in }
    var onVideoCaptured: (URL) -> () = { _ in }
    var afterMediaCaptured: () -> () = {}
    var onCloseController: () -> () = {}
}
