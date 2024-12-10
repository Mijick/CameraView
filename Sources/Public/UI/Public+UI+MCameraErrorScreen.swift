//
//  Public+UI+MCameraErrorScreen.swift of MijickCamera
//
//  Created by Tomasz Kurylik. Sending ❤️ from Kraków!
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//    - Medium: https://medium.com/@mijick
//
//  Copyright ©2024 Mijick. All rights reserved.


import SwiftUI

public protocol MCameraErrorScreen: View {
    var error: MCameraError { get }
    var closeMCameraAction: () -> () { get }
}

// MARK: Methods
public extension MCameraErrorScreen {
    func openAppSettings() { if let url = URL(string: UIApplication.openSettingsURLString) {
        UIApplication.shared.open(url)
    }}
}
