//
//  MCameraView.swift of MijickCamera
//
//  Created by Tomasz Kurylik. Sending ❤️ from Kraków!
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//    - Medium: https://medium.com/@mijick
//
//  Copyright ©2024 Mijick. All rights reserved.


import SwiftUI

public struct MCameraView: View {
    @ObservedObject var manager: CameraManager
    @Namespace var namespace
    var config: Config = .init()

    
    public var body: some View { if config.isCameraControllerConfigured {
        ZStack(content: createContent)
            .onAppear(perform: onAppear)
            .onDisappear(perform: onDisappear)
            .onChange(of: manager.attributes.capturedMedia, perform: onCapturedMediaChange)
    }}
}
private extension MCameraView {
    @ViewBuilder func createContent() -> some View {
        if let error = manager.attributes.error { createErrorScreen(error) }
        else if let capturedMedia = manager.attributes.capturedMedia, config.capturedMediaScreen != nil { createCapturedMediaScreen(capturedMedia) }
        else { createCameraScreen() }
    }
}
private extension MCameraView {
    func createErrorScreen(_ error: MijickCameraError) -> some View {
        config.errorScreen(error, config.closeCameraControllerAction).erased()
    }
    func createCapturedMediaScreen(_ media: MCameraMedia) -> some View {
        config.capturedMediaScreen?(media, namespace, onCapturedMediaRejected, onCapturedMediaAccepted)
            .erased()
    }
    func createCameraScreen() -> some View {
        config.cameraScreen(manager, namespace, config.closeCameraControllerAction)
            .erased()
            .onAppear(perform: onCameraAppear)
            .onDisappear(perform: onCameraDisappear)
    }
}


// MARK: - ACTIONS



// MARK: Controller
private extension MCameraView {
    func onAppear() {
        lockScreenOrientation()
    }
    func onDisappear() {
        unlockScreenOrientation()
        manager.cancel()
    }
    func onCapturedMediaChange(_ capturedMedia: MCameraMedia?) {
        guard let capturedMedia, config.capturedMediaScreen == nil else { return }
        notifyUserOfMediaCaptured(capturedMedia)
    }
}
private extension MCameraView {
    func lockScreenOrientation() {
        config.appDelegate?.orientationLock = .portrait
        UINavigationController.attemptRotationToDeviceOrientation()
    }
    func unlockScreenOrientation() {
        config.appDelegate?.orientationLock = .all
    }
    func notifyUserOfMediaCaptured(_ capturedMedia: MCameraMedia) {
        if let image = capturedMedia.getImage() { config.imageCapturedAction(image, .init(cameraView: self)) }
        else if let video = capturedMedia.getVideo() { config.videoCapturedAction(video, .init(cameraView: self)) }
    }
}

// MARK: Camera Screen
private extension MCameraView {
    func onCameraAppear() { Task {
        do { try await manager.setup() }
        catch { print("(MijickCamera) ERROR DURING SETUP: \(error)") }
    }}
    func onCameraDisappear() {
        manager.cancel()
    }
}

// MARK: Captured Media Screen
private extension MCameraView {
    func onCapturedMediaRejected() {
        manager.setCapturedMedia(nil)
    }
    func onCapturedMediaAccepted() {
        guard let capturedMedia = manager.attributes.capturedMedia else { return }
        notifyUserOfMediaCaptured(capturedMedia)
    }
}
