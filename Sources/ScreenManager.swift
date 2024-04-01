//
//  ScreenManager.swift of MijickCameraView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2024 Mijick. Licensed under MIT License.


import SwiftUI

class ScreenManager {}
extension ScreenManager {
    static var safeArea: (top: CGFloat, bottom: CGFloat) { (current.top, current.bottom) }
}
private extension ScreenManager {
    static var current: UIEdgeInsets { UIApplication.shared.windows.first?.safeAreaInsets ?? .zero }
}
