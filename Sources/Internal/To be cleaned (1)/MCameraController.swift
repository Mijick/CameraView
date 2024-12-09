//
//  MCameraController.swift of MijickCamera
//
//  Created by Tomasz Kurylik. Sending ❤️ from Kraków!
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//    - Medium: https://medium.com/@mijick
//
//  Copyright ©2024 Mijick. All rights reserved.


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
        .onAppear(perform: onAppear)
        .onDisappear(perform: onDisappear)
        .onChange(of: cameraManager.attributes.capturedMedia, perform: onMediaCaptured)
    }}
}
private extension MCameraController {
    func createErrorStateView(_ error: MijickCameraError) -> some View {
        config.errorScreen(error, config.closeCameraControllerAction).erased()
    }
    @ViewBuilder func createNormalStateView() -> some View { switch cameraManager.attributes.capturedMedia {
        case .some(let media) where config.capturedMediaScreen != nil: createCameraPreview(media)
        default: createCameraView()
    }}
}
private extension MCameraController {
    func createCameraPreview(_ media: MCameraMedia) -> some View {
        config.capturedMediaScreen?(media, namespace, resetCapturedMedia, performAfterMediaCapturedAction).erased()
    }
    func createCameraView() -> some View {
        config.cameraScreen(cameraManager, namespace, config.closeCameraControllerAction)
            .erased()
            .onAppear(perform: onCameraAppear)
            .onDisappear(perform: cameraManager.cancel)
    }
}

private extension MCameraController {
    func onAppear() {
        lockScreenOrientation()
    }
    func onCameraAppear() { Task {
        do { try await cameraManager.setup() }
        catch { print("(MijickCamera) ERROR DURING SETUP: \(error)") }
    }}
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
        cameraManager.setCapturedMedia(nil)
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
