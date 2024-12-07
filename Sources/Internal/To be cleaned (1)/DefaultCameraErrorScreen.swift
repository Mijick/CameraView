//
//  DefaultCameraErrorScreen.swift of MijickCamera
//
//  Created by Tomasz Kurylik. Sending ❤️ from Kraków!
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//    - Medium: https://medium.com/@mijick
//
//  Copyright ©2024 Mijick. All rights reserved.


import SwiftUI

struct DefaultCameraErrorScreen: MCameraErrorScreen {
    let error: MijickCameraError
    let closeControllerAction: () -> ()


    var body: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: 8)
            createCloseButton()
            Spacer()
            createTitle()
            Spacer().frame(height: 16)
            createDescription()
            Spacer().frame(height: 32)
            createOpenSettingsButton()
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.mijickBackgroundPrimary).ignoresSafeArea())
    }
}
private extension DefaultCameraErrorScreen {
    func createCloseButton() -> some View {
        CloseButton(action: closeControllerAction)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 20)
    }
    func createTitle() -> some View {
        Text(title)
            .font(.system(size: 20, weight: .bold))
            .foregroundColor(.init(.mijickTextPrimary))
            .multilineTextAlignment(.center)
            .fixedSize(horizontal: false, vertical: true)
            .padding(.horizontal, 64)
    }
    func createDescription() -> some View {
        Text(description)
            .font(.system(size: 16, weight: .regular))
            .foregroundColor(.init(.mijickTextSecondary))
            .lineSpacing(4)
            .multilineTextAlignment(.center)
            .fixedSize(horizontal: false, vertical: true)
            .padding(.horizontal, 32)
    }
    func createOpenSettingsButton() -> some View {
        Button(action: openAppSettings) {
            Text(openSettingsButton)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(Color(.mijickTextBrand))
        }
    }
}

private extension DefaultCameraErrorScreen {
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
    var openSettingsButton: String { NSLocalizedString("Open Settings", comment: "") }
}
