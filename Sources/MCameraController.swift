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

public struct MCameraController: View {
    @ObservedObject private var cameraManager: CameraManager = .init(config: .init())
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
    func lockOrientation(_ appDelegate: MApplicationDelegate.Type) -> Self { setAndReturnSelf { $0.config.appDelegate = appDelegate } }

    func outputType() -> Self { self }
    func cameraPosition() -> Self { self }
    func flashMode() -> Self { self }
    func gridVisible() -> Self { self }

    func focusImage() -> Self { self }
    func focusImageColor() -> Self { self }
    func focusImageSize() -> Self { self }

    



    
    func showCapturedMediaPreview() -> Self { self }

    func changeErrorScreen() -> Self { self }
    func changeMediaPreviewScreen() -> Self { self }
    func changeCameraScreen() -> Self { self }



    func onImageCaptured() -> Self { self }
    func onVideoCaptured() -> Self { self }

    func onCloseButtonTap() -> Self { self }


}
