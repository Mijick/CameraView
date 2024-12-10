//
//  MCameraError.swift of MijickCamera
//
//  Created by Tomasz Kurylik. Sending ❤️ from Kraków!
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//    - Medium: https://medium.com/@mijick
//
//  Copyright ©2024 Mijick. All rights reserved.


public enum MCameraError: Error {
    case microphonePermissionsNotGranted, cameraPermissionsNotGranted
    case cannotSetupInput, cannotSetupOutput
    case cannotSetupMetalDevice
}
