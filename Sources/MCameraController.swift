//
//  MCameraController.swift of MijickCameraView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2024 Mijick. Licensed under MIT License.


import SwiftUI
import AVFoundation

public struct MCameraController: View {
    @ObservedObject private var cameraManager: CameraManager = .init()
    @State private var capturedMedia: MCameraMedia? = nil
    @State private var cameraError: CameraManager.Error?
    @Namespace private var namespace
    private var config: CameraConfig = .init()


    public init() {}
    public var body: some View {
        ZStack { switch cameraError {
            case .some(let error): createErrorStateView(error)
            case nil: createNormalStateView()
        }}
        .animation(.defaultEase, value: capturedMedia == nil)
        .onAppear(perform: onAppear)
        .onDisappear(perform: onDisappear)
    }
}
private extension MCameraController {
    func createErrorStateView(_ error: CameraManager.Error) -> some View {
        config.cameraErrorView(error).erased()
    }
    func createNormalStateView() -> some View { ZStack { switch capturedMedia {
        case .some: createCameraPreview()
        case nil: createCameraView()
    }}}
}
private extension MCameraController {
    func createCameraPreview() -> some View {
        config.mediaPreviewView($capturedMedia, namespace).erased()
    }
    func createCameraView() -> some View {
        config.cameraView(cameraManager, $capturedMedia, namespace).erased()
    }
}

private extension MCameraController {
    func onAppear() {
        checkCameraPermissions()
        lockScreenOrientation()
    }
    func onDisappear() {
        unlockScreenOrientation()
    }
}
private extension MCameraController {
    func checkCameraPermissions() {
        do { try cameraManager.checkPermissions() }
        catch { cameraError = error as? CameraManager.Error }
    }
    func lockScreenOrientation() {
        config.appDelegate?.orientationLock = .portrait
        UINavigationController.attemptRotationToDeviceOrientation()
    }
    func unlockScreenOrientation() {
        config.appDelegate?.orientationLock = .all
    }
}



public extension MCameraController {
    func lockOrientation(_ appDelegate: MApplicationDelegate.Type) -> Self { setAndReturnSelf { $0.config.appDelegate = appDelegate; $0.cameraManager.lockOrientation() } }

    func outputType(_ type: CameraOutputType) -> Self { setAndReturnSelf { $0.cameraManager.change(outputType: type) } }
    func cameraPosition(_ position: AVCaptureDevice.Position) -> Self { setAndReturnSelf { $0.cameraManager.change(cameraPosition: position) } }
    func flashMode(_ flashMode: AVCaptureDevice.FlashMode) -> Self { setAndReturnSelf { $0.cameraManager.change(flashMode: flashMode) } }
    func gridVisible(_ visible: Bool) -> Self { setAndReturnSelf { $0.cameraManager.change(isGridVisible: visible) } }

    func focusImage(_ focusImage: UIImage) -> Self { setAndReturnSelf { $0.cameraManager.change(focusImage: focusImage) } }
    func focusImageColor(_ color: UIColor) -> Self { setAndReturnSelf { $0.cameraManager.change(focusImageColor: color) } }
    func focusImageSize(_ size: CGFloat) -> Self { setAndReturnSelf { $0.cameraManager.change(focusImageSize: size) } }

    



    
    func showCapturedMediaPreview() -> Self { self }

    func changeErrorScreen() -> Self { self }
    func changeMediaPreviewScreen() -> Self { self }
    func changeCameraScreen() -> Self { self }



    func onImageCaptured() -> Self { self }
    func onVideoCaptured() -> Self { self }

    func onCloseButtonTap() -> Self { self }


}
