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
    @ObservedObject var cameraManager: CameraManager
    @Namespace var namespace
    var config: Config = .init()

    
    public var body: some View { if config.isCameraControllerConfigured {
        ZStack { switch cameraManager.attributes.error {
            case .some(let error): createErrorStateView(error)
            case nil: createNormalStateView()
        }}
        .animation(.mijickEase, value: cameraManager.attributes.capturedMedia)
        .onAppear(perform: onAppear)
        .onDisappear(perform: onDisappear)
        .onChange(of: cameraManager.attributes.capturedMedia, perform: onMediaCaptured)
    }}
}
private extension MCameraController {
    func createErrorStateView(_ error: MijickCameraError) -> some View {
        config.errorScreen(error, config.closeCameraControllerAction).erased()
    }
    func createNormalStateView() -> some View { ZStack { switch cameraManager.attributes.capturedMedia {
        case .some(let media) where config.capturedMediaScreen != nil: createCameraPreview(media)
        default: createCameraView()
    }}}
}
private extension MCameraController {
    func createCameraPreview(_ media: MCameraMedia) -> some View {
        config.capturedMediaScreen?(media, namespace, resetCapturedMedia, performAfterMediaCapturedAction).erased()
    }
    func createCameraView() -> some View {
        config.cameraScreen(cameraManager, namespace, config.closeCameraControllerAction)
            .erased()
            .onDisappear(perform: cameraManager.cancel)
    }
}

private extension MCameraController {
    func onAppear() {
        lockScreenOrientation()
    }
    func onDisappear() {
        unlockScreenOrientation()
        cameraManager.cancel()
    }
    func onMediaCaptured(_ media: MCameraMedia?) { if media != nil {
        switch config.capturedMediaScreen != nil {
            case true: return
            case false: performAfterMediaCapturedAction()
        }
    }}
}
private extension MCameraController {
    func lockScreenOrientation() {
        config.appDelegate?.orientationLock = .portrait
        UINavigationController.attemptRotationToDeviceOrientation()
    }
    func unlockScreenOrientation() {
        config.appDelegate?.orientationLock = .all
    }
    func resetCapturedMedia() {
        cameraManager.attributes.capturedMedia = nil
    }
    func performAfterMediaCapturedAction() { if let capturedMedia = cameraManager.attributes.capturedMedia {
        notifyUserOfMediaCaptured(capturedMedia)
    }}
}
private extension MCameraController {
    func notifyUserOfMediaCaptured(_ capturedMedia: MCameraMedia) {
        if let image = capturedMedia.getImage() { config.imageCapturedAction(image, .init(cameraController: self)) }
        else if let video = capturedMedia.getVideo() { config.videoCapturedAction(video, .init(cameraController: self)) }
    }
}






@MainActor public struct MController {
    let cameraController: MCameraController
}


public extension MController {
    func closeController() {
        cameraController.config.closeCameraControllerAction()
    }
    func back() {
        cameraController.cameraManager.attributes.capturedMedia = nil
    }
}
