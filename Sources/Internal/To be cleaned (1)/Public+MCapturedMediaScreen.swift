//
//  Public+MCapturedMediaScreen.swift of MijickCamera
//
//  Created by Tomasz Kurylik. Sending ❤️ from Kraków!
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//    - Medium: https://medium.com/@mijick
//
//  Copyright ©2024 Mijick. All rights reserved.


import SwiftUI

public protocol MCapturedMediaScreen: View {
    var capturedMedia: MCameraMedia { get }
    var namespace: Namespace.ID { get }
    var retakeAction: () -> () { get }
    var acceptMediaAction: () -> () { get }
}
