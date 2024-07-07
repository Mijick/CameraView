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
    @State var cameraError: CameraManager.Error?
    @Namespace var namespace
    var config: CameraConfig = .init()

    
    public var body: some View {
        ZStack { switch cameraError {
            case .some(let error): createErrorStateView(error)
            case nil: createNormalStateView()
        }}
        .animation(.defaultEase, value: cameraManager.attributes.capturedMedia)
        .onAppear(perform: onAppear)
        .onDisappear(perform: onDisappear)
        .onChange(of: cameraManager.attributes.capturedMedia, perform: onMediaCaptured)
    }
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
        checkCameraPermissions()
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
    func performAfterMediaCapturedAction() { if let capturedMedia = cameraManager.attributes.capturedMedia {
        notifyUserOfMediaCaptured(capturedMedia)
        config.afterMediaCaptured()
    }}
}
private extension MCameraController {
    func notifyUserOfMediaCaptured(_ capturedMedia: MCameraMedia) {
        if let image = capturedMedia.image { config.onImageCaptured(image) }
        else if let video = capturedMedia.video { config.onVideoCaptured(video) }
    }
}
