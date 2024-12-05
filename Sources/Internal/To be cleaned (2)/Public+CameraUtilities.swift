//
//  Public+CameraUtilities.swift of MijickCameraView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2024 Mijick. Licensed under MIT License.


import SwiftUI

// MARK: Camera Output Type
public enum CameraOutputType: CaseIterable {
    case photo
    case video
}

// MARK: Camera Position
public enum CameraPosition: CaseIterable {
    case back
    case front
}

// MARK: Camera Flash Mode
public enum CameraFlashMode: CaseIterable {
    case off
    case on
    case auto
}

// MARK: Camera Light Mode
public enum CameraLightMode: CaseIterable {
    case off
    case on
}

// MARK: Camera HDR Mode
public enum CameraHDRMode: CaseIterable {
    case off
    case on
    case auto
}
