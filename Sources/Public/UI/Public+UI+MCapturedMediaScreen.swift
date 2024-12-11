//
//  Public+UI+MCapturedMediaScreen.swift of MijickCamera
//
//  Created by Tomasz Kurylik. Sending ❤️ from Kraków!
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//    - Medium: https://medium.com/@mijick
//
//  Copyright ©2024 Mijick. All rights reserved.


import SwiftUI

/**
 Screen that displays the captured media.

 - important: A view conforming to **MCapturedMediaScreen** has to be passed directly to ``MCamera``. See ``MCamera/setCapturedMediaScreen(_:)`` for more details.


 ## Usage
 ```swift
 


 ```
 */
public protocol MCapturedMediaScreen: View {
    var capturedMedia: MCameraMedia { get }
    var namespace: Namespace.ID { get }
    var retakeAction: () -> () { get }
    var acceptMediaAction: () -> () { get }
}
