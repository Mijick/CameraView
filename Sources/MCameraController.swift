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
    @State private var cameraError: CameraManager.Error?
    @Namespace private var namespace
    private var config: CameraConfig = .init()


    public init() {}
    public var body: some View {
        ZStack { switch cameraError {
            case .some(let error): createErrorStateView(error)
            case nil: createNormalStateView()
        }}
        .animation(.defaultEase, value: cameraManager.capturedMedia)
        .onAppear(perform: onAppear)
        .onDisappear(perform: onDisappear)
        .onChange(of: cameraManager.capturedMedia, perform: onMediaCaptured)
    }
}
private extension MCameraController {
    func createErrorStateView(_ error: CameraManager.Error) -> some View {
        config.cameraErrorView(error).erased()
    }
    func createNormalStateView() -> some View { ZStack { switch cameraManager.capturedMedia {
        case .some(let media) where config.mediaPreviewView != nil: createCameraPreview(media)
        default: createCameraView()
    }}}
}
private extension MCameraController {
    func createCameraPreview(_ media: MCameraMedia) -> some View {
        config.mediaPreviewView?(media, namespace, cameraManager.resetCapturedMedia, notifyUserOfMediaCaptured).erased()
    }
    func createCameraView() -> some View {
        config.cameraView(cameraManager, namespace).erased()
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
    func onMediaCaptured(_ media: MCameraMedia?) { if media != nil {
        switch config.mediaPreviewView != nil {
            case true: break
            case false: notifyUserOfMediaCaptured()
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
    func notifyUserOfMediaCaptured() { if let capturedMedia = cameraManager.capturedMedia {
        if let image = capturedMedia.data { config.onImageCaptured(image) }
        if let video = capturedMedia.url { config.onVideoCaptured(video) }
    }}
}



public extension MCameraController {
    func outputType(_ type: CameraOutputType) -> Self { setAndReturnSelf { $0.cameraManager.change(outputType: type) } }
    func cameraPosition(_ position: AVCaptureDevice.Position) -> Self { setAndReturnSelf { $0.cameraManager.change(cameraPosition: position) } }
    func flashMode(_ flashMode: AVCaptureDevice.FlashMode) -> Self { setAndReturnSelf { $0.cameraManager.change(flashMode: flashMode) } }
    func gridVisible(_ visible: Bool) -> Self { setAndReturnSelf { $0.cameraManager.change(isGridVisible: visible) } }
    func focusImage(_ focusImage: UIImage) -> Self { setAndReturnSelf { $0.cameraManager.change(focusImage: focusImage) } }
    func focusImageColor(_ color: UIColor) -> Self { setAndReturnSelf { $0.cameraManager.change(focusImageColor: color) } }
    func focusImageSize(_ size: CGFloat) -> Self { setAndReturnSelf { $0.cameraManager.change(focusImageSize: size) } }
    func lockOrientation(_ appDelegate: MApplicationDelegate.Type) -> Self { setAndReturnSelf { $0.config.appDelegate = appDelegate; $0.cameraManager.lockOrientation() } }

    func errorScreen(_ builder: @escaping (CameraManager.Error) -> any CameraErrorView) -> Self { setAndReturnSelf { $0.config.cameraErrorView = builder } }
    func mediaPreviewScreen(_ builder: ((MCameraMedia, Namespace.ID, @escaping () -> (), @escaping () -> ()) -> any CameraPreview)?) -> Self { setAndReturnSelf { $0.config.mediaPreviewView = builder } }
    func cameraScreen(_ builder: @escaping (CameraManager, Namespace.ID) -> any CameraView) -> Self { setAndReturnSelf { $0.config.cameraView = builder } }

    func onImageCaptured(_ action: @escaping (Data) -> ()) -> Self { setAndReturnSelf { $0.config.onImageCaptured = action } }
    func onVideoCaptured(_ action: @escaping (URL) -> ()) -> Self { setAndReturnSelf { $0.config.onVideoCaptured = action } }
    func onCloseButtonTap(_ action: @escaping () -> ()) -> Self { setAndReturnSelf { $0.config.onCloseButtonTap = action } }
}
