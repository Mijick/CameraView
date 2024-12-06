//
//  DefaultCameraScreen.OutputTypeSwitch.swift of MijickCamera
//
//  Created by Tomasz Kurylik. Sending ❤️ from Kraków!
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//    - Medium: https://medium.com/@mijick
//
//  Copyright ©2024 Mijick. All rights reserved.


import SwiftUI

extension DefaultCameraScreen { struct OutputTypeSwitch: View {
    let currentCameraOutputType: CameraOutputType
    let currentScreenRotationAngle: Angle
    let changeOutputTypeAction: (CameraOutputType) -> ()


    var body: some View {
        HStack(spacing: 4) {
            createOutputTypeButton(.video)
            createOutputTypeButton(.photo)
        }
        .padding(8)
        .background(Color(.mijickBackgroundPrimary).opacity(0.64))
        .mask(Capsule())
    }
}}
private extension DefaultCameraScreen.OutputTypeSwitch {
    func createOutputTypeButton(_ outputType: CameraOutputType) -> some View {
        Button(icon: getOutputTypeButtonIcon(outputType), active: isOutputTypeButtonActive(outputType)) {
            changeOutputTypeAction(outputType)
        }
        .rotationEffect(currentScreenRotationAngle)
    }
}

private extension DefaultCameraScreen.OutputTypeSwitch {
    func getOutputTypeButtonIcon(_ outputType: CameraOutputType) -> ImageResource { switch outputType {
        case .photo: return .mijickIconPhoto
        case .video: return .mijickIconVideo
    }}
    func isOutputTypeButtonActive(_ outputType: CameraOutputType) -> Bool {
        outputType == currentCameraOutputType
    }
}


// MARK: Button
fileprivate struct Button: View {
    let icon: ImageResource
    let active: Bool
    let action: () -> ()


    var body: some View {
        SwiftUI.Button(action: action, label: createButtonLabel).buttonStyle(ButtonScaleStyle())
    }
}
private extension Button {
    func createButtonLabel() -> some View {
        Image(icon)
            .resizable()
            .frame(width: iconSize, height: iconSize)
            .foregroundColor(iconColor)
            .padding(16)
            .background(Color(.mijickBackgroundSecondary))
            .mask(Circle())
    }
}
private extension Button {
    var iconSize: CGFloat { switch active {
        case true: 28
        case false: 22
    }}
    var iconColor: Color { switch active {
        case true: .init(.mijickBackgroundYellow)
        case false: .init(.mijickTextTertiary)
    }}
}
