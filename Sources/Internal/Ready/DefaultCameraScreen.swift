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
        VStack(spacing: 0) {
            createTopBar()
            createContentView()
            createBottomBar()
        }
        .ignoresSafeArea(.all, edges: .horizontal)
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
            .padding(.top, 4)
            .padding(.bottom, 12)
            .padding(.horizontal, 20)
    }
    func createContentView() -> some View {
        ZStack {
            createCameraView()
            createOutputTypeSwitch()
        }
        .matchedGeometryEffect(id: "content", in: namespace)
    }
    func createBottomBar() -> some View {
        DefaultCameraScreen.BottomBar(parent: self)
            .padding(.top, 16)
            .padding(.bottom, 12)
            .padding(.horizontal, 32)
    }
}
private extension DefaultCameraScreen {
    @ViewBuilder func createOutputTypeSwitch() -> some View { if isOutputTypeSwitchActive {
        CameraOutputSwitch(parent: self)
            .frame(maxHeight: .infinity, alignment: .bottom)
            .padding(.bottom, 8)
    }}
}

extension DefaultCameraScreen {
    var iconAngle: Angle { switch isOrientationLocked {
        case true: deviceOrientation.getAngle()
        case false: .zero
    }}
    var isOutputTypeSwitchActive: Bool { config.cameraOutputSwitchAllowed && !isRecording }
}
