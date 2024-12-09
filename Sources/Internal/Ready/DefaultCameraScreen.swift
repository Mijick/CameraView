//
//  DefaultCameraScreen.swift of MijickCamera
//
//  Created by Tomasz Kurylik. Sending ❤️ from Kraków!
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//    - Medium: https://medium.com/@mijick
//
//  Copyright ©2024 Mijick. All rights reserved.


import SwiftUI

public struct DefaultCameraScreen: MCameraScreen {
    @ObservedObject public var cameraManager: CameraManager
    public let namespace: Namespace.ID
    public let closeControllerAction: () -> ()
    var config: Config = .init()


    public var body: some View {
        ZStack {
            createContentView()
            createTopBar()
            createBottomBar()
        }
        .ignoresSafeArea()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.mijickBackgroundPrimary).ignoresSafeArea())
        .statusBarHidden()
        .animation(.mijickSpring, value: isRecording)
        .animation(.mijickSpring, value: cameraOutputType)
        .animation(.mijickSpring, value: hasLight)
        .animation(.mijickSpring, value: iconAngle)
        .animation(.mijickSpring, value: lightMode)
    }
}
private extension DefaultCameraScreen {
    func createTopBar() -> some View {
        DefaultCameraScreen.TopBar(parent: self)
            .frame(maxHeight: .infinity, alignment: .top)
    }
    func createContentView() -> some View {
        createCameraView()
            .ignoresSafeArea()
    }
    func createBottomBar() -> some View {
        DefaultCameraScreen.BottomBar(parent: self)
            .frame(maxHeight: .infinity, alignment: .bottom)
    }
}

extension DefaultCameraScreen {
    var iconAngle: Angle { switch isOrientationLocked {
        case true: deviceOrientation.getAngle()
        case false: .zero
    }}
}
