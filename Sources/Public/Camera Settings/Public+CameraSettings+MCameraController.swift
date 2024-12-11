//
//  Public+CameraSettings+MCameraController.swift of MijickCamera
//
//  Created by Tomasz Kurylik. Sending ❤️ from Kraków!
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//    - Medium: https://medium.com/@mijick
//
//  Copyright ©2024 Mijick. All rights reserved.


import Foundation

// MARK: Available Actions
public extension MCamera.Controller {
    /**
     Closes the MCamera.

     See ``MCamera/setCloseMCameraAction(_:)`` for more details.
     */
    func closeMCamera() { mCamera.config.closeMCameraAction() }

    /**
     Opens the Camera Screen.
     */
    func reopenCameraScreen() { mCamera.manager.setCapturedMedia(nil) }
}
