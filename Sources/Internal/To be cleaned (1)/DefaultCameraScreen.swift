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
private extension DefaultCameraScreen {
    func createOutputTypeButtons() -> some View {
        OutputTypeSwitch(currentCameraOutputType: cameraOutputType, iconRotationAngle: iconAngle, changeOutputTypeAction: changeCameraOutputType)
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
            .rotationEffect(iconAngle)
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
        TopButton(image: gridButtonIcon, action: changeGridVisibility)
            .rotationEffect(iconAngle)
            .isActiveStackElement(config.gridButtonVisible)
    }
    func createFlipOutputButton() -> some View {
        TopButton(image: flipButtonIcon, action: changeMirrorOutput)
            .rotationEffect(iconAngle)
            .isActiveStackElement(cameraPosition == .front)
            .isActiveStackElement(config.flipButtonVisible)
    }
    func createFlashButton() -> some View {
        TopButton(image: flashButtonIcon, action: changeFlashMode)
            .rotationEffect(iconAngle)
            .isActiveStackElement(hasFlash)
            .isActiveStackElement(cameraOutputType == .photo)
            .isActiveStackElement(config.flashButtonVisible)
    }
}
private extension DefaultCameraScreen {
    func createLightButton() -> some View {
        BottomButton(image: .mijickIconLight, active: lightMode == .on, action: changeLightMode)
            .matchedGeometryEffect(id: "button-bottom-left", in: namespace)
            .rotationEffect(iconAngle)
            .frame(maxWidth: .infinity, alignment: .leading)
            .isActive(hasLight)
            .isActive(config.lightButtonVisible)
    }
    func createCaptureButton() -> some View {
        CaptureButton(action: captureOutput, mode: cameraOutputType, isRecording: isRecording).isActive(config.captureButtonVisible)
    }
    func createChangeCameraButton() -> some View {
        BottomButton(image: .mijickIconChangeCamera, active: false, action: changeCameraPosition)
            .matchedGeometryEffect(id: "button-bottom-right", in: namespace)
            .rotationEffect(iconAngle)
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


// MARK: - CloseButton
fileprivate struct CloseButton: View {
    let action: () -> ()


    var body: some View {
        Button(action: action) {
            Image(.mijickIconCancel)
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundColor(Color(.mijickBackgroundInverted))
        }
    }
}

// MARK: - TopButton
fileprivate struct TopButton: View {
    let image: ImageResource
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
        Image(image)
            .resizable()
            .frame(width: 16, height: 16)
            .foregroundColor(Color(.mijickBackgroundInverted))
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
        Circle().stroke(Color(.mijickBackgroundInverted), lineWidth: 2.5)
    }
}
private extension CaptureButton {
    var backgroundColor: Color { switch mode {
        case .photo: .init(.mijickBackgroundInverted)
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
    let image: ImageResource
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
        Image(image)
            .resizable()
            .frame(width: 26, height: 26)
            .foregroundColor(iconColor)
    }
}
private extension BottomButton {
    var iconColor: Color { switch active {
        case true: .init(.mijickBackgroundYellow)
        case false: .init(.mijickBackgroundInverted)
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
        Image(icon)
            .resizable()
            .frame(width: iconSize, height: iconSize)
            .foregroundColor(iconColor)
            .frame(width: backgroundSize, height: backgroundSize)
            .background(Color(.mijickBackgroundSecondary))
            .mask(Circle())
    }
}
private extension OutputTypeButton {
    var icon: ImageResource { switch type {
        case .photo: .mijickIconPhoto
        case .video: .mijickIconVideo
    }}
    var iconSize: CGFloat { switch active {
        case true: 28
        case false: 22
    }}
    var backgroundSize: CGFloat { switch active {
        case true: 44
        case false: 32
    }}
    var iconColor: Color { switch active {
        case true: .init(.mijickBackgroundYellow)
        case false: .init(.mijickTextTertiary)
    }}
}
