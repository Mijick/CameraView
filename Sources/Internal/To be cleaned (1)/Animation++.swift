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
    static var mijickSpring: Animation { .spring(duration: 0.32, bounce: 0, blendDuration: 0) }
    static var mijickEase: Animation { .easeInOut(duration: 0.32) }
}
