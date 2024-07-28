//
//  PostCameraConfig.swift of MijickCameraView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2024 Mijick. Licensed under MIT License.


public class PostCameraConfig {
    // MARK: Attributes
    var shouldReturnToCameraView: Bool = false
    var shouldCloseCameraController: Bool = false

    // MARK: Actions
    var customAction: () -> () = {}
}
