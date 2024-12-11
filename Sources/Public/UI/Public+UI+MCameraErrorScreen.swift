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

/**
 Screen that displays an error message if one or more camera permissions are denied by the user.

 - important: A view conforming to **MCameraErrorScreen** has to be passed directly to ``MCamera``. See ``MCamera/setErrorScreen(_:)`` for more details.


 ## Usage
 ```swift
 struct ContentView: View {
    var body: some View {
        MCamera()
            .setErrorScreen(CustomCameraErrorScreen.init)

            // MUST BE CALLED!
            .startSession()
    }
 }

 // MARK: Custom Camera Error Screen
 struct CustomCameraErrorScreen: MCameraErrorScreen {
    let error: MCameraError
    let closeMCameraAction: () -> ()


    var body: some View {
        Button(action: openAppSettings) { Text("Open Settings") }
    }
 }
 ```
 */
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
