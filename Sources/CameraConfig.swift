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
    var cameraErrorView: (CameraManager.Error, @escaping () -> ()) -> any MCameraErrorView = DefaultCameraErrorView.init
    var cameraView: (CameraManager, Namespace.ID, @escaping () -> ()) -> any MCameraView = DefaultCameraView.init
    var mediaPreviewView: ((MCameraMedia, Namespace.ID, @escaping () -> (), @escaping () -> ()) -> any MCameraPreview)? = DefaultCameraPreview.init

    var appDelegate: MApplicationDelegate.Type?

    var onImageCaptured: (Data) -> () = { _ in }
    var onVideoCaptured: (URL) -> () = { _ in }

    var afterMediaCaptured: () -> () = {}
    var onCloseController: () -> () = {}
}
