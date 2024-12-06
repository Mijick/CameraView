//
//  DefaultCameraScreen+BottomButton.swift of MijickCamera
//
//  Created by Tomasz Kurylik. Sending ❤️ from Kraków!
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//    - Medium: https://medium.com/@mijick
//
//  Copyright ©2024 Mijick. All rights reserved.


import SwiftUI

extension DefaultCameraScreen { struct BottomButton: View {
    let image: ImageResource
    let active: Bool
    let action: () -> ()


    var body: some View {
        Button(action: action, label: createButtonLabel)
            .buttonStyle(ButtonScaleStyle())
            .transition(.scale.combined(with: .opacity))
    }
}}
private extension DefaultCameraScreen.BottomButton {
    func createButtonLabel() -> some View {
        ZStack {
            createBackground()
            createIcon()
        }.frame(width: 52, height: 52)
    }
}
private extension DefaultCameraScreen.BottomButton {
    func createBackground() -> some View {
        Circle().fill(Color(.mijickBackgroundSecondary))
    }
    func createIcon() -> some View {
        Image(image)
            .resizable()
            .frame(width: 26, height: 26)
            .foregroundColor(iconColor)
    }
}
private extension DefaultCameraScreen.BottomButton {
    var iconColor: Color { switch active {
        case true: .init(.mijickBackgroundYellow)
        case false: .init(.mijickBackgroundInverted)
    }}
}
