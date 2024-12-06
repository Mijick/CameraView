//
//  DefaultCameraScreen+CaptureButton.swift of MijickCamera
//
//  Created by Tomasz Kurylik. Sending ❤️ from Kraków!
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//    - Medium: https://medium.com/@mijick
//
//  Copyright ©2024 Mijick. All rights reserved.


import SwiftUI

extension DefaultCameraScreen { struct CaptureButton: View {
    let action: () -> ()
    let mode: CameraOutputType
    let isRecording: Bool


    var body: some View {
        Button(action: action, label: createButtonLabel).buttonStyle(ButtonScaleStyle())
    }
}}
private extension DefaultCameraScreen.CaptureButton {
    func createButtonLabel() -> some View {
        ZStack {
            createBackground()
            createBorders()
        }.frame(width: 72, height: 72)
    }
}
private extension DefaultCameraScreen.CaptureButton {
    func createBackground() -> some View {
        RoundedRectangle(cornerRadius: backgroundCornerRadius, style: .continuous)
            .fill(backgroundColor)
            .padding(backgroundPadding)
    }
    func createBorders() -> some View {
        Circle().stroke(Color(.mijickBackgroundInverted), lineWidth: 2.5)
    }
}
private extension DefaultCameraScreen.CaptureButton {
    var backgroundColor: Color { switch mode {
        case .photo: .init(.mijickBackgroundInverted)
        case .video: .init(.mijickBackgroundRed)
    }}
    var backgroundCornerRadius: CGFloat { switch isRecording {
        case true: 5
        case false: 34
    }}
    var backgroundPadding: CGFloat { switch isRecording {
        case true: 20
        case false: 4
    }}
}
