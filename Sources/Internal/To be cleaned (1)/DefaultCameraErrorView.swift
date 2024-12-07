//
//  DefaultCameraErrorView.swift of MijickCamera
//
//  Created by Tomasz Kurylik. Sending ❤️ from Kraków!
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//    - Medium: https://medium.com/@mijick
//
//  Copyright ©2024 Mijick. All rights reserved.


import SwiftUI

struct DefaultCameraErrorView: MCameraErrorScreen {
    let error: MijickCameraError
    let closeControllerAction: () -> ()


    var body: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: 8)
            createCloseButton()
            Spacer()
            createTitle()
            Spacer().frame(height: 12)
            createDescription()
            Spacer().frame(height: 32)
            createOpenSettingsButton()
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.mijickBackgroundPrimary).ignoresSafeArea())
    }
}
private extension DefaultCameraErrorView {
    func createCloseButton() -> some View {
        Button(action: closeControllerAction) {
            Image(.mijickIconCancel)
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundColor(Color(.mijickBackgroundInverted))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading, 20)
    }
    func createTitle() -> some View {
        Text(getDefaultTitle())
            .font(.system(size: 20, weight: .bold))
            .foregroundColor(.init(.mijickTextPrimary))
            .multilineTextAlignment(.center)
            .fixedSize(horizontal: false, vertical: true)
            .padding(.horizontal, 60)
    }
    func createDescription() -> some View {
        Text(getDefaultDescription())
            .font(.system(size: 15, weight: .regular))
            .foregroundColor(.init(.mijickTextSecondary))
            .multilineTextAlignment(.center)
            .fixedSize(horizontal: false, vertical: true)
            .padding(.horizontal, 48)
    }
    func createOpenSettingsButton() -> some View {
        Button(action: openAppSettings) {
            Text(NSLocalizedString("Open Settings", comment: ""))
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(Color(.mijickTextBrand))
        }
    }
}




extension DefaultCameraErrorView {
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
