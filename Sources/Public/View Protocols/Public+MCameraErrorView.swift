//
//  Public+MCameraErrorView.swift of MijickCameraView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2024 Mijick. Licensed under MIT License.


import SwiftUI

public protocol MCameraErrorView: View {
    var error: CameraManager.Error { get }
}

public extension MCameraErrorView {
    func openAppSettings() { if let url = URL(string: UIApplication.openSettingsURLString) {
        UIApplication.shared.open(url)
    }}
}

public extension MCameraErrorView {
    var title: String { switch error {
        case .microphonePermissionsNotGranted: NSLocalizedString("Enable Microphone Access", comment: "")
        case .cameraPermissionsNotGranted: NSLocalizedString("Enable Camera Access", comment: "")
        default: ""
    }}
    var description: String { switch error {
        case .microphonePermissionsNotGranted: Bundle.main.infoDictionary?["NSMicrophoneUsageDescription"] as? String ?? ""
        case .cameraPermissionsNotGranted: Bundle.main.infoDictionary?["NSCameraUsageDescription"] as? String ?? ""
        default: ""
    }}
}
