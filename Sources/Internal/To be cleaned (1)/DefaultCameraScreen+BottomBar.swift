//
//  DefaultCameraScreen+BottomBar.swift of MijickCamera
//
//  Created by Tomasz Kurylik. Sending ❤️ from Kraków!
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//    - Medium: https://medium.com/@mijick
//
//  Copyright ©2024 Mijick. All rights reserved.


import SwiftUI

extension DefaultCameraScreen { struct BottomBar: View {
    let parent: DefaultCameraScreen


    var body: some View {
        ZStack {
            createLightButton()
            createCaptureButton()
            createChangeCameraButton()
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 16)
        .padding(.bottom, 12)
        .padding(.horizontal, 32)
    }
}}
private extension DefaultCameraScreen.BottomBar {
    @ViewBuilder func createLightButton() -> some View { if isLightButtonActive {
        DefaultCameraScreen.BottomButton(
            icon: .mijickIconLight,
            iconRotationAngle: parent.iconAngle,
            active: parent.lightMode == .on,
            action: changeLightMode
        )
        .matchedGeometryEffect(id: "button-bottom-left", in: parent.namespace)
        .frame(maxWidth: .infinity, alignment: .leading)
    }}
    @ViewBuilder func createCaptureButton() -> some View { if isCaptureButtonActive {
        DefaultCameraScreen.CaptureButton(
            outputType: parent.cameraOutputType,
            isRecording: parent.isRecording,
            action: parent.captureOutput
        )
    }}
    @ViewBuilder func createChangeCameraButton() -> some View { if isChangeCameraButtonActive {
        DefaultCameraScreen.BottomButton(
            icon: .mijickIconChangeCamera,
            iconRotationAngle: parent.iconAngle,
            active: false,
            action: changeCameraPosition
        )
        .matchedGeometryEffect(id: "button-bottom-right", in: parent.namespace)
        .frame(maxWidth: .infinity, alignment: .trailing)
    }}
}

private extension DefaultCameraScreen.BottomBar {
    func changeLightMode() {
        do { try parent.setLightMode(parent.lightMode.next()) }
        catch {}
    }
    func changeCameraPosition() { Task {
        do { try await parent.setCameraPosition(parent.cameraPosition.next()) }
        catch {}
    }}
}
private extension DefaultCameraScreen.BottomBar {
    var isLightButtonActive: Bool { parent.config.lightButtonVisible && parent.hasLight }
    var isCaptureButtonActive: Bool { parent.config.captureButtonVisible }
    var isChangeCameraButtonActive: Bool { parent.config.changeCameraButtonVisible && !parent.isRecording }
}
