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

extension Animation {
    static var mijickSpring: Animation { .spring(response: 0.4, dampingFraction: 1, blendDuration: 0.1) }
    static var mijickEase: Animation { .easeInOut(duration: 0.32) }
}
