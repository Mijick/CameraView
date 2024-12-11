//
//  Public+CameraSettings+MApplicationDelegate.swift of MijickCamera
//
//  Created by Tomasz Kurylik. Sending ❤️ from Kraków!
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//    - Medium: https://medium.com/@mijick
//
//  Copyright ©2024 Mijick. All rights reserved.


import SwiftUI

/**
 Locks the screen in portrait mode when the Camera Screen is active.

 See ``MCamera/lockOrientation(_:)`` for more details.
 - note: Blocks the rotation of the entire screen on which the **MCamera** is located.

 ## Usage
 ```swift
 @main struct App_Main: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup(content: ContentView.init)
    }
 }

// MARK: App Delegate
 class AppDelegate: NSObject, MApplicationDelegate {
    static var orientationLock = UIInterfaceOrientationMask.all

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask { AppDelegate.orientationLock }
 }

// MARK: Content View
 struct ContentView: View {
    var body: some View {
        MCamera()
            .lockOrientation(AppDelegate.self)

            // MUST BE CALLED!
            .startSession()
    }
 }
 ```
 */
public protocol MApplicationDelegate: UIApplicationDelegate {
    static var orientationLock: UIInterfaceOrientationMask { get set }

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask
}
