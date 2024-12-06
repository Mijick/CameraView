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
    let icon: ImageResource
    let iconRotationAngle: Angle
    let active: Bool
    let action: () -> ()


    var body: some View {
        Button(action: action, label: createButtonLabel).buttonStyle(ButtonScaleStyle())
    }
}}
private extension DefaultCameraScreen.BottomButton {
    func createButtonLabel() -> some View {
        Image(icon)
            .resizable()
            .frame(width: 26, height: 26)
            .foregroundColor(iconColor)
            .frame(width: 52, height: 52)
            .rotationEffect(iconRotationAngle)
            .background(Color(.mijickBackgroundSecondary))
            .mask(Circle())
    }
}
private extension DefaultCameraScreen.BottomButton {
    var iconColor: Color { switch active {
        case true: .init(.mijickBackgroundYellow)
        case false: .init(.mijickBackgroundInverted)
    }}
}
