//
//  CameraOutputType.swift of MijickCameraView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2024 Mijick. Licensed under MIT License.


import SwiftUI

public enum CameraOutputType: CaseIterable {
    case photo
    case video
}

public enum CameraPosition: CaseIterable {
    case back
    case front
}

public enum CameraFlashMode: CaseIterable {
    case off
    case on
    case auto
}

public enum CameraTorchMode: CaseIterable {
    case off
    case on
}



public typealias ErrorViewBuilder = (CameraManager.Error, _ closeControllerAction: @escaping () -> ()) -> any MCameraErrorView
public typealias PreviewViewBuilder = (MCameraMedia, Namespace.ID, _ retakeAction: @escaping () -> (), _ acceptMediaAction: @escaping () -> ()) -> any MCameraPreview
public typealias CameraViewBuilder = (CameraManager, Namespace.ID, _ closeControllerAction: @escaping () -> ()) -> any MCameraView
