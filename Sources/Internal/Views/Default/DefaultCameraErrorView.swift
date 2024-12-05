//
//  DefaultCameraErrorView.swift of MijickCameraView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2024 Mijick. Licensed under MIT License.


import SwiftUI

struct DefaultCameraErrorView: MCameraErrorView {
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
                .foregroundColor(Color.white)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading, 20)
    }
    func createTitle() -> some View {
        Text(getDefaultTitle())
            .font(.system(size: 20, weight: .bold))
            .foregroundColor(Color.white)
            .multilineTextAlignment(.center)
            .fixedSize(horizontal: false, vertical: true)
            .padding(.horizontal, 60)
    }
    func createDescription() -> some View {
        Text(getDefaultDescription())
            .font(.system(size: 15, weight: .regular))
            .foregroundColor(Color.white.opacity(0.7))
            .multilineTextAlignment(.center)
            .fixedSize(horizontal: false, vertical: true)
            .padding(.horizontal, 48)
    }
    func createOpenSettingsButton() -> some View {
        Button(action: openAppSettings) {
            Text(NSLocalizedString("Open Settings", comment: ""))
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(Color.accent)
        }
    }
}
