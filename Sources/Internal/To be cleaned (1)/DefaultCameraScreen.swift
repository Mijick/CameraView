//
//  DefaultCameraScreen.swift of MijickCameraView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2024 Mijick. Licensed under MIT License.


import SwiftUI

public struct DefaultCameraScreen: MCameraScreen {
    @ObservedObject public var cameraManager: CameraManager
    public let namespace: Namespace.ID
    public let closeControllerAction: () -> ()
    var config: Config = .init()


    public var body: some View {
        VStack(spacing: 0) {
            createTopView()
            createContentView()
            createBottomView()
        }
        .ignoresSafeArea(.all, edges: .horizontal)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.mijickBackgroundPrimary).ignoresSafeArea())
        .statusBarHidden()
        .animation(.mijickSpring, value: isRecording)
        .animation(.mijickSpring, value: cameraOutputType)
        .animation(.mijickSpring, value: hasLight)
        .animation(.mijickSpring, value: iconAngle)
    }
}
private extension DefaultCameraScreen {
    func createTopView() -> some View {
        ZStack {
            createCloseButton()
            createTopCentreView()
            createTopRightView()
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 4)
        .padding(.bottom, 12)
        .padding(.horizontal, 20)
    }
    func createContentView() -> some View {
        ZStack {
            createCameraView()
            createOutputTypeButtons()
        }
    }
    func createBottomView() -> some View {
        DefaultCameraScreen.BottomBar(parent: self)
    }
}
private extension DefaultCameraScreen {
    func createOutputTypeButtons() -> some View {
        CameraOutputSwitch(currentCameraOutputType: cameraOutputType, iconRotationAngle: iconAngle, changeOutputTypeAction: changeCameraOutputType)
            .transition(.asymmetric(insertion: .opacity.animation(.mijickSpring.delay(1)), removal: .scale.combined(with: .opacity)))
            .isActive(!isRecording)
            .isActive(config.outputTypePickerVisible)
            .frame(maxHeight: .infinity, alignment: .bottom)
            .padding(.bottom, 8)
    }
}
private extension DefaultCameraScreen {
    func createCloseButton() -> some View {
        CloseButton(action: closeControllerAction)
            .frame(maxWidth: .infinity, alignment: .leading)
            .isActive(!isRecording)
    }
    func createTopCentreView() -> some View {
        Text(recordingTime.toString())
            .font(.system(size: 20, weight: .medium, design: .monospaced))
            .foregroundColor(.init(.mijickTextPrimary))
            .isActive(isRecording)
    }
    func createTopRightView() -> some View {
        HStack(spacing: 12) {
            createGridButton()
            createFlipOutputButton()
            createFlashButton()
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .isActive(!isRecording)
    }
}
private extension DefaultCameraScreen {
    func createGridButton() -> some View {
        TopButton(icon: gridButtonIcon, iconRotationAngle: iconAngle, action: changeGridVisibility)
            .isActiveStackElement(config.gridButtonVisible)
    }
    func createFlipOutputButton() -> some View {
        TopButton(icon: flipButtonIcon, iconRotationAngle: iconAngle, action: changeMirrorOutput)
            .isActiveStackElement(cameraPosition == .front)
            .isActiveStackElement(config.flipButtonVisible)
    }
    func createFlashButton() -> some View {
        TopButton(icon: flashButtonIcon, iconRotationAngle: iconAngle, action: changeFlashMode)
            .isActiveStackElement(hasFlash)
            .isActiveStackElement(cameraOutputType == .photo)
            .isActiveStackElement(config.flashButtonVisible)
    }
}
private extension DefaultCameraScreen {
    // TODO: Dodać animację do przycisków
    func createLightButton() -> some View {
        BottomButton(icon: .mijickIconLight, iconRotationAngle: iconAngle, active: lightMode == .on, action: changeLightMode)
            .matchedGeometryEffect(id: "button-bottom-left", in: namespace)
            .frame(maxWidth: .infinity, alignment: .leading)
            .isActive(hasLight)
            .isActive(config.lightButtonVisible)
    }
    func createCaptureButton() -> some View {
        CaptureButton(outputType: cameraOutputType, isRecording: isRecording, action: captureOutput).isActive(config.captureButtonVisible)
    }
    func createChangeCameraButton() -> some View {
        BottomButton(icon: .mijickIconChangeCamera, iconRotationAngle: iconAngle, active: false, action: changeCameraPosition)
            .matchedGeometryEffect(id: "button-bottom-right", in: namespace)
            .frame(maxWidth: .infinity, alignment: .trailing)
            .isActive(!isRecording)
            .isActive(config.changeCameraButtonVisible)
    }
}
private extension DefaultCameraScreen {
    var iconAngle: Angle { switch isOrientationLocked {
        case true: deviceOrientation.getAngle()
        case false: .zero
    }}
    var gridButtonIcon: ImageResource { switch isGridVisible {
        case true: .mijickIconGridOn
        case false: .mijickIconGridOff
    }}
    var flipButtonIcon: ImageResource { switch isOutputMirrored {
        case true: .mijickIconFlipOn
        case false: .mijickIconFlipOff
    }}
    var flashButtonIcon: ImageResource { switch flashMode {
        case .off: .mijickIconFlashOff
        case .on: .mijickIconFlashOn
        case .auto: .mijickIconFlashAuto
    }}
}

private extension DefaultCameraScreen {
    func changeGridVisibility() {
        setGridVisibility(!isGridVisible)
    }
    func changeMirrorOutput() {
        setMirrorOutput(!isOutputMirrored)
    }
    func changeFlashMode() {
        setFlashMode(flashMode.next())
    }
    func changeLightMode() {
        do { try setLightMode(lightMode.next()) }
        catch {}
    }
    func changeCameraPosition() { Task {
        do { try await setCameraPosition(cameraPosition.next()) }
        catch {}
    }}
    func changeCameraOutputType(_ type: CameraOutputType) {
        setOutputType(type)
    }
}

// MARK: - Configurables
extension DefaultCameraScreen { struct Config {
    var outputTypePickerVisible: Bool = true
    var lightButtonVisible: Bool = true
    var captureButtonVisible: Bool = true
    var changeCameraButtonVisible: Bool = true
    var gridButtonVisible: Bool = true
    var flipButtonVisible: Bool = true
    var flashButtonVisible: Bool = true
}}








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
            action: parent.changeLightMode
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









extension DefaultCameraScreen { struct TopBar: View {


    var body: some View {
        EmptyView()
    }
}}
private extension DefaultCameraScreen.TopBar {

}
private extension DefaultCameraScreen.TopBar {

}
private extension DefaultCameraScreen.TopBar {

}
private extension DefaultCameraScreen.TopBar {

}
private extension DefaultCameraScreen.TopBar {

}
private extension DefaultCameraScreen.TopBar {

}
private extension DefaultCameraScreen.TopBar {

}

