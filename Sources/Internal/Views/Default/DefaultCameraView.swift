//
//  DefaultCameraView.swift of MijickCameraView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2024 Mijick. Licensed under MIT License.


import SwiftUI

public struct DefaultCameraView: MCameraView {
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
        .animation(.defaultSpring, value: isRecording)
        .animation(.defaultSpring, value: outputType)
        .animation(.defaultSpring, value: hasLight)
        .animation(.defaultSpring, value: iconAngle)
    }
}
private extension DefaultCameraView {
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
}
private extension DefaultCameraView {
    func createOutputTypeButtons() -> some View {
        HStack(spacing: 4) {
            createOutputTypeButton(.video)
            createOutputTypeButton(.photo)
        }
        .padding(8)
        .background(Color(.mijickBackgroundPrimary).opacity(0.64))
        .mask(Capsule())
        .transition(.asymmetric(insertion: .opacity.animation(.defaultSpring.delay(1)), removal: .scale.combined(with: .opacity)))
        .isActive(!isRecording)
        .isActive(config.outputTypePickerVisible)
        .frame(maxHeight: .infinity, alignment: .bottom)
        .padding(.bottom, 8)
    }
}
private extension DefaultCameraView {
    func createCloseButton() -> some View {
        CloseButton(action: closeControllerAction)
            .rotationEffect(iconAngle)
            .frame(maxWidth: .infinity, alignment: .leading)
            .isActive(!isRecording)
    }
    func createTopCentreView() -> some View {
        Text(recordingTime.toString())
            .font(.system(size: 20, weight: .medium, design: .monospaced))
            .foregroundColor(.white)
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
private extension DefaultCameraView {
    func createGridButton() -> some View {
        TopButton(icon: gridButtonIcon, action: changeGridVisibility)
            .rotationEffect(iconAngle)
            .isActiveStackElement(config.gridButtonVisible)
    }
    func createFlipOutputButton() -> some View {
        TopButton(icon: flipButtonIcon, action: changeMirrorOutput)
            .rotationEffect(iconAngle)
            .isActiveStackElement(cameraPosition == .front)
            .isActiveStackElement(config.flipButtonVisible)
    }
    func createFlashButton() -> some View {
        TopButton(icon: flashButtonIcon, action: changeFlashMode)
            .rotationEffect(iconAngle)
            .isActiveStackElement(hasFlash)
            .isActiveStackElement(outputType == .photo)
            .isActiveStackElement(config.flashButtonVisible)
    }
}
private extension DefaultCameraView {
    func createLightButton() -> some View {
        BottomButton(icon: "icon-light", active: lightMode == .on, action: changeLightMode)
            .matchedGeometryEffect(id: "button-bottom-left", in: namespace)
            .rotationEffect(iconAngle)
            .frame(maxWidth: .infinity, alignment: .leading)
            .isActive(hasLight)
            .isActive(config.lightButtonVisible)
    }
    func createCaptureButton() -> some View {
        CaptureButton(action: captureOutput, mode: outputType, isRecording: isRecording).isActive(config.captureButtonVisible)
    }
    func createChangeCameraButton() -> some View {
        BottomButton(icon: "icon-change-camera", active: false, action: changeCameraPosition)
            .matchedGeometryEffect(id: "button-bottom-right", in: namespace)
            .rotationEffect(iconAngle)
            .frame(maxWidth: .infinity, alignment: .trailing)
            .isActive(!isRecording)
            .isActive(config.changeCameraButtonVisible)
    }
    func createOutputTypeButton(_ cameraOutputType: CameraOutputType) -> some View {
        OutputTypeButton(type: cameraOutputType, active: cameraOutputType == outputType, action: { changeCameraOutputType(cameraOutputType) })
            .rotationEffect(iconAngle)
    }
}
private extension DefaultCameraView {
    var iconAngle: Angle { switch isOrientationLocked {
        case true: deviceOrientation.getAngle()
        case false: .zero
    }}
    var gridButtonIcon: String { switch showGrid {
        case true: "icon-grid-on"
        case false: "icon-grid-off"
    }}
    var flipButtonIcon: String { switch mirrorOutput {
        case true: "icon-flip-on"
        case false: "icon-flip-off"
    }}
    var flashButtonIcon: String { switch flashMode {
        case .off: "icon-flash-off"
        case .on: "icon-flash-on"
        case .auto: "icon-flash-auto"
    }}
}

private extension DefaultCameraView {
    func changeGridVisibility() {
        changeGridVisibility(!showGrid)
    }
    func changeMirrorOutput() {
        changeMirrorOutputMode(!mirrorOutput)
    }
    func changeFlashMode() {
        changeFlashMode(flashMode.next())
    }
    func changeLightMode() {
        do { try changeLightMode(lightMode.next()) }
        catch {}
    }
    func changeCameraPosition() { Task {
        do { try await changeCamera(cameraPosition.next()) }
        catch {}
    }}
    func changeCameraOutputType(_ type: CameraOutputType) {
        changeOutputType(type)
    }
}

// MARK: - Configurables
extension DefaultCameraView { struct Config {
    var outputTypePickerVisible: Bool = true
    var lightButtonVisible: Bool = true
    var captureButtonVisible: Bool = true
    var changeCameraButtonVisible: Bool = true
    var gridButtonVisible: Bool = true
    var flipButtonVisible: Bool = true
    var flashButtonVisible: Bool = true
}}


// MARK: - CloseButton
fileprivate struct CloseButton: View {
    let action: () -> ()


    var body: some View {
        Button(action: action) {
            Image("icon-cancel", bundle: .module)
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundColor(Color.white)
        }
    }
}

// MARK: - TopButton
fileprivate struct TopButton: View {
    let icon: String
    let action: () -> ()


    var body: some View {
        Button(action: action, label: createButtonLabel)
    }
}
private extension TopButton {
    func createButtonLabel() -> some View {
        ZStack {
            createBackground()
            createIcon()
        }
    }
}
private extension TopButton {
    func createBackground() -> some View {
        Circle()
            .fill(Color(.mijickBackgroundSecondary))
            .frame(width: 32, height: 32)
    }
    func createIcon() -> some View {
        Image(icon, bundle: .module)
            .resizable()
            .frame(width: 16, height: 16)
            .foregroundColor(Color.white)
    }
}

// MARK: - CaptureButton
fileprivate struct CaptureButton: View {
    let action: () -> ()
    let mode: CameraOutputType
    let isRecording: Bool


    var body: some View {
        Button(action: action, label: createButtonLabel).buttonStyle(ButtonScaleStyle())
    }
}
private extension CaptureButton {
    func createButtonLabel() -> some View {
        ZStack {
            createBackground()
            createBorders()
        }.frame(width: 72, height: 72)
    }
}
private extension CaptureButton {
    func createBackground() -> some View {
        RoundedRectangle(cornerRadius: backgroundCornerRadius, style: .continuous)
            .fill(backgroundColor)
            .padding(backgroundPadding)
    }
    func createBorders() -> some View {
        Circle().stroke(Color.white, lineWidth: 2.5)
    }
}
private extension CaptureButton {
    var backgroundColor: Color { switch mode {
        case .photo: .white
        case .video: .init(.mijickBackgroundRed)
    }}
    var backgroundCornerRadius: CGFloat { switch isRecording {
        case true: 5
        case false: 34
    }}
    var backgroundPadding: CGFloat { switch isRecording {
        case true: 20
        case false: 4
    }}
}

// MARK: - BottomButton
fileprivate struct BottomButton: View {
    let icon: String
    let active: Bool
    let action: () -> ()


    var body: some View {
        Button(action: action, label: createButtonLabel)
            .buttonStyle(ButtonScaleStyle())
            .transition(.scale.combined(with: .opacity))
    }
}
private extension BottomButton {
    func createButtonLabel() -> some View {
        ZStack {
            createBackground()
            createIcon()
        }.frame(width: 52, height: 52)
    }
}
private extension BottomButton {
    func createBackground() -> some View {
        Circle().fill(Color(.mijickBackgroundSecondary))
    }
    func createIcon() -> some View {
        Image(icon, bundle: .module)
            .resizable()
            .frame(width: 26, height: 26)
            .foregroundColor(iconColor)
    }
}
private extension BottomButton {
    var iconColor: Color { switch active {
        case true: .yellow
        case false: .white
    }}
}

// MARK: - OutputTypeButton
fileprivate struct OutputTypeButton: View {
    let type: CameraOutputType
    let active: Bool
    let action: () -> ()


    var body: some View {
        Button(action: action, label: createButtonLabel).buttonStyle(ButtonScaleStyle())
    }
}
private extension OutputTypeButton {
    func createButtonLabel() -> some View {
        Image(icon, bundle: .module)
            .resizable()
            .frame(width: iconSize, height: iconSize)
            .foregroundColor(iconColor)
            .frame(width: backgroundSize, height: backgroundSize)
            .background(Color(.mijickBackgroundSecondary))
            .mask(Circle())
    }
}
private extension OutputTypeButton {
    var icon: String { "icon-" + .init(describing: type) }
    var iconSize: CGFloat { switch active {
        case true: 28
        case false: 22
    }}
    var backgroundSize: CGFloat { switch active {
        case true: 44
        case false: 32
    }}
    var iconColor: Color { switch active {
        case true: .yellow
        case false: .white.opacity(0.6)
    }}
}
