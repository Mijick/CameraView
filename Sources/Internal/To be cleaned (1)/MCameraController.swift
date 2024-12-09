//
//  MCameraController.swift of MijickCamera
//
//  Created by Tomasz Kurylik. Sending ❤️ from Kraków!
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//    - Medium: https://medium.com/@mijick
//
//  Copyright ©2024 Mijick. All rights reserved.


import Foundation

@MainActor public struct MCameraController {
    let mCamera: MCamera
}

// MARK: Available Actions
public extension MCameraController {
    func closeMCamera() { mCamera.config.closeMCameraAction() }
    func openCameraScreen() { mCamera.manager.setCapturedMedia(nil) }
}
