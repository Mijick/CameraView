//
//  Public+MCameraErrorScreen.swift of MijickCamera
//
//  Created by Tomasz Kurylik. Sending ❤️ from Kraków!
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//    - Medium: https://medium.com/@mijick
//
//  Copyright ©2024 Mijick. All rights reserved.


import SwiftUI

public protocol MCameraErrorScreen: View {
    var error: MijickCameraError { get }
    var closeControllerAction: () -> () { get }
}

// MARK: - Helpers
public extension MCameraErrorScreen {
    func openAppSettings() { if let url = URL(string: UIApplication.openSettingsURLString) {
        UIApplication.shared.open(url)
    }}
}
public extension MCameraErrorScreen {
    func getDefaultTitle() -> String { switch error {
        case .microphonePermissionsNotGranted: NSLocalizedString("Enable Microphone Access", comment: "")
        case .cameraPermissionsNotGranted: NSLocalizedString("Enable Camera Access", comment: "")
        default: ""
    }}
    func getDefaultDescription() -> String { switch error {
        case .microphonePermissionsNotGranted: Bundle.main.infoDictionary?["NSMicrophoneUsageDescription"] as? String ?? ""
        case .cameraPermissionsNotGranted: Bundle.main.infoDictionary?["NSCameraUsageDescription"] as? String ?? ""
        default: ""
    }}
}
