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
    var cameraErrorView: (CameraManager.Error) -> any CameraErrorView = DefaultCameraErrorView.init
    var cameraView: (CameraManager, Binding<MCameraMedia?>, Namespace.ID) -> any CameraView = DefaultCameraView.init
    var mediaPreviewView: ((Binding<MCameraMedia?>, Namespace.ID) -> any CameraPreview)? = DefaultCameraPreview.init


    var appDelegate: MApplicationDelegate.Type?
}
