//
//  Animation++.swift of MijickCameraView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2024 Mijick. Licensed under MIT License.


import SwiftUI

extension Animation {
    static var defaultSpring: Animation { .spring(response: 0.4, dampingFraction: 1, blendDuration: 0.1) }
    static var defaultEase: Animation { .easeInOut(duration: 0.4) }
}
