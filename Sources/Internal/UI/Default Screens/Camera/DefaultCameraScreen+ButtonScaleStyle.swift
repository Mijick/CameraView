//
//  DefaultCameraScreen+ButtonScaleStyle.swift of MijickCamera
//
//  Created by Tomasz Kurylik. Sending ❤️ from Kraków!
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//    - Medium: https://medium.com/@mijick
//
//  Copyright ©2024 Mijick. All rights reserved.


import SwiftUI

struct ButtonScaleStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View { configuration
        .label
        .scaleEffect(configuration.isPressed ? 0.96 : 1)
    }
}
