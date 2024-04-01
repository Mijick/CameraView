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

public struct CameraConfig: Configurable { public init() {}
    private(set) var cameraErrorView: (CameraManager.Error) -> any CameraErrorView = DefaultCameraErrorView.init
    private(set) var cameraView: (CameraManager, Binding<MCameraMedia?>, Namespace.ID) -> any CameraView = DefaultCameraView.init
    private(set) var previewView: (Binding<MCameraMedia?>, Namespace.ID) -> any CameraPreview = DefaultCameraPreview.init
}
