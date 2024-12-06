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
            .padding(.top, 16)
            .padding(.bottom, 12)
            .padding(.horizontal, 32)
    }
}
private extension DefaultCameraScreen {
    func createOutputTypeButtons() -> some View {
        CameraOutputSwitch(parent: self)
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
extension DefaultCameraScreen {
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


















extension DefaultCameraScreen { struct TopBar: View {
    let parent: DefaultCameraScreen


    var body: some View {
        ZStack {
            createCloseButton()
            createTopCentreView()
            createTopRightView()
        }
        .frame(maxWidth: .infinity)
    }
}}
private extension DefaultCameraScreen.TopBar {

}
private extension DefaultCameraScreen.TopBar {

}
private extension DefaultCameraScreen.TopBar {
    @ViewBuilder func createGridButton() -> some View { if isGridButtonActive {
        DefaultCameraScreen.TopButton(
            icon: gridButtonIcon,
            iconRotationAngle: parent.iconAngle,
            action: changeGridVisibility
        )
    }}
    @ViewBuilder func createFlipOutputButton() -> some View { if isFlipOutputButtonActive {
        DefaultCameraScreen.TopButton(
            icon: flipButtonIcon,
            iconRotationAngle: parent.iconAngle,
            action: changeMirrorOutput
        )
    }}
    @ViewBuilder func createFlashButton() -> some View { if isFlashButtonActive {
        DefaultCameraScreen.TopButton(
            icon: flashButtonIcon,
            iconRotationAngle: parent.iconAngle,
            action: changeFlashMode
        )
    }}
}
private extension DefaultCameraScreen.TopBar {

}
private extension DefaultCameraScreen.TopBar {
    func changeGridVisibility() {
        parent.setGridVisibility(!parent.isGridVisible)
    }
    func changeMirrorOutput() {
        parent.setMirrorOutput(!parent.isOutputMirrored)
    }
    func changeFlashMode() {
        parent.setFlashMode(parent.flashMode.next())
    }
}

private extension DefaultCameraScreen.TopBar {
    var gridButtonIcon: ImageResource { switch parent.isGridVisible {
        case true: .mijickIconGridOn
        case false: .mijickIconGridOff
    }}
    var flipButtonIcon: ImageResource { switch parent.isOutputMirrored {
        case true: .mijickIconFlipOn
        case false: .mijickIconFlipOff
    }}
    var flashButtonIcon: ImageResource { switch parent.flashMode {
        case .off: .mijickIconFlashOff
        case .on: .mijickIconFlashOn
        case .auto: .mijickIconFlashAuto
    }}
}
private extension DefaultCameraScreen.TopBar {
    var isCloseButtonActive: Bool { true }
    var isGridButtonActive: Bool { parent.config.gridButtonVisible }
    var isFlipOutputButtonActive: Bool { parent.config.flipButtonVisible && parent.cameraPosition == .front }
    var isFlashButtonActive: Bool { parent.config.flashButtonVisible && parent.hasFlash && parent.cameraOutputType == .photo }
}

