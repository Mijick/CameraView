//
//  Animation++.swift of MijickCamera
//
//  Created by Tomasz Kurylik. Sending ❤️ from Kraków!
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//    - Medium: https://medium.com/@mijick
//
//  Copyright ©2024 Mijick. All rights reserved.


import SwiftUI

// MARK: Custom Animation
extension Animation {
    static var mSpring: Animation { .spring(duration: duration, bounce: 0, blendDuration: 0) }
}
extension Animation {
    static var duration: CGFloat { 0.3 }
}
