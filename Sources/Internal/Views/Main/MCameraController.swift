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
    @ObservedObject var cameraManager: CameraManager = .init()
    @Namespace var namespace
    var config: CameraConfig = .init()
    public init() {}
    
    public var body: some View { if config.isInitialised {
        ZStack { switch cameraManager.attributes.error {
            case .some(let error): createErrorStateView(error)
            case nil: createNormalStateView()
        }}
        .animation(.defaultEase, value: cameraManager.attributes.capturedMedia)
        .onAppear(perform: onAppear)
        .onDisappear(perform: onDisappear)
        .onChange(of: cameraManager.attributes.capturedMedia, perform: onMediaCaptured)
    }}
}
private extension MCameraController {
    func createErrorStateView(_ error: CameraManager.Error) -> some View {
        config.cameraErrorView(error, config.onCloseController).erased()
    }
    func createNormalStateView() -> some View { ZStack { switch cameraManager.attributes.capturedMedia {
        case .some(let media) where config.mediaPreviewView != nil: createCameraPreview(media)
        default: createCameraView()
    }}}
}
private extension MCameraController {
    func createCameraPreview(_ media: MCameraMedia) -> some View {
        config.mediaPreviewView?(media, namespace, cameraManager.resetCapturedMedia, performAfterMediaCapturedAction).erased()
    }
    func createCameraView() -> some View {
        config.cameraView(cameraManager, namespace, config.onCloseController).erased()
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
        switch config.mediaPreviewView != nil {
            case true: cameraManager.resetZoomAndTorch()
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
    func performAfterMediaCapturedAction() { if let capturedMedia = cameraManager.attributes.capturedMedia {
        notifyUserOfMediaCaptured(capturedMedia)
        performPostCameraAction()
    }}
}
private extension MCameraController {
    func notifyUserOfMediaCaptured(_ capturedMedia: MCameraMedia) {
        if let image = capturedMedia.getImage() { config.onImageCaptured(image) }
        else if let video = capturedMedia.getVideo() { config.onVideoCaptured(video) }
    }
    func performPostCameraAction() { let afterMediaCaptured = config.afterMediaCaptured(.init())
        afterMediaCaptured.shouldReturnToCameraView ? cameraManager.resetCapturedMedia() : ()
        afterMediaCaptured.shouldCloseCameraController ? config.onCloseController() : ()
        afterMediaCaptured.customAction()
    }
}
