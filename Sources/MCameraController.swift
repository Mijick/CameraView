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
    @Binding var capturedMedia: MCameraMedia?
    let appDelegate: MApplicationDelegate.Type
    @ObservedObject private var cameraManager: CameraManager = .init(config: .init())
    @State private var cameraError: CameraManager.Error?
    @Namespace private var namespace


    public init(capturedMedia: Binding<MCameraMedia?>, appDelegate: MApplicationDelegate.Type) { self._capturedMedia = capturedMedia; self.appDelegate = appDelegate }
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
        DefaultCameraErrorView(error: error)
    }
    func createNormalStateView() -> some View { ZStack { switch capturedMedia {
        case .some: createCameraPreview()
        case nil: createCameraView()
    }}}
}
private extension MCameraController {
    func createCameraPreview() -> some View {
        DefaultCameraPreview(media: $capturedMedia, namespace: namespace)
    }
    func createCameraView() -> some View {
        DefaultCameraView(cameraManager: cameraManager, capturedMedia: $capturedMedia, namespace: namespace)
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
        appDelegate.orientationLock = .portrait
        UINavigationController.attemptRotationToDeviceOrientation()
    }
    func unlockScreenOrientation() {
        appDelegate.orientationLock = .all
    }
}
