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
        ZStack(content: createContent)
            .onAppear(perform: onAppear)
            .onDisappear(perform: onDisappear)
            .onChange(of: cameraManager.attributes.capturedMedia, perform: notifyUserOfMediaCaptured)
    }}
}
private extension MCameraController {
    @ViewBuilder func createContent() -> some View {
        if let error = cameraManager.attributes.error { createErrorScreen(error) }
        else if let capturedMedia = cameraManager.attributes.capturedMedia, config.capturedMediaScreen != nil { createCapturedMediaScreen(capturedMedia) }
        else { createCameraScreen() }
    }
}
private extension MCameraController {
    func createErrorScreen(_ error: MijickCameraError) -> some View {
        config.errorScreen(error, config.closeCameraControllerAction).erased()
    }
    func createCapturedMediaScreen(_ media: MCameraMedia) -> some View {
        config.capturedMediaScreen?(media, namespace, resetCapturedMedia, performAfterMediaCapturedAction)
            .erased()
    }
    func createCameraScreen() -> some View {
        config.cameraScreen(cameraManager, namespace, config.closeCameraControllerAction)
            .erased()
            .onAppear(perform: onCameraAppear)
            .onDisappear(perform: onCameraDisappear)
    }
}


// MARK: - ACTIONS



// MARK: Controller
private extension MCameraController {
    func onAppear() {
        lockScreenOrientation()
    }
    func onDisappear() {
        unlockScreenOrientation()
        cameraManager.cancel()
    }
    func notifyUserOfMediaCaptured(_ capturedMedia: MCameraMedia?) {
        if let image = capturedMedia?.getImage() { config.imageCapturedAction(image, .init(cameraController: self)) }
        else if let video = capturedMedia?.getVideo() { config.videoCapturedAction(video, .init(cameraController: self)) }
    }
}
private extension MCameraController {
    func lockScreenOrientation() {
        config.appDelegate?.orientationLock = .portrait
        UINavigationController.attemptRotationToDeviceOrientation()
    }
    func unlockScreenOrientation() {
        config.appDelegate?.orientationLock = .all
    }
}

// MARK: Camera Screen
private extension MCameraController {
    func onCameraAppear() { Task {
        do { try await cameraManager.setup() }
        catch { print("(MijickCamera) ERROR DURING SETUP: \(error)") }
    }}
    func onCameraDisappear() {
        cameraManager.cancel()
    }
}

// MARK: Captured Media Screen
private extension MCameraController {
    func resetCapturedMedia() {
        cameraManager.setCapturedMedia(nil)
    }
    func performAfterMediaCapturedAction() {
        guard let capturedMedia = cameraManager.attributes.capturedMedia else { return }
        notifyUserOfMediaCaptured(capturedMedia)
    }
}
