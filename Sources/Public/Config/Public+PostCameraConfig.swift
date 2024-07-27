//
//  Public+PostCameraConfig.swift of MijickCameraView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2024 Mijick. Licensed under MIT License.


extension PostCameraConfig {
    public func returnToCameraView(_ value: Bool) -> Self { shouldReturnToCameraView = value; return self }
    public func closeCameraController(_ value: Bool) -> Self { shouldCloseCameraController = value; return self }
    public func custom(_ action: @escaping () -> ()) -> Self { customAction = action; return self }
}
