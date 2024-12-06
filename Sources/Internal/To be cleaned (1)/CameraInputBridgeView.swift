//
//  CameraInputBridgeView.swift of MijickCamera
//
//  Created by Tomasz Kurylik. Sending ❤️ from Kraków!
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//    - Medium: https://medium.com/@mijick
//
//  Copyright ©2024 Mijick. All rights reserved.


import SwiftUI

struct CameraInputBridgeView: UIViewRepresentable {
    let cameraManager: CameraManager
    let inputView: UIView = .init()
}
extension CameraInputBridgeView {
    func makeUIView(context: Context) -> some UIView {
        setupCameraManager()
        setupTapGesture(context)
        setupPinchGesture(context)
        return inputView
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {}
    func makeCoordinator() -> Coordinator { .init(self) }
}
private extension CameraInputBridgeView {
    func setupCameraManager() { Task {
        do { try await cameraManager.setup(in: inputView) }
        catch { print("(MijickCamera) ERROR DURING SETUP: \(error)") }
    }}
    func setupTapGesture(_ context: Context) {
        let tapRecognizer = UITapGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.onTapGesture))
        inputView.addGestureRecognizer(tapRecognizer)
    }
    func setupPinchGesture(_ context: Context) {
        let pinchRecognizer = UIPinchGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.onPinchGesture))
        inputView.addGestureRecognizer(pinchRecognizer)
    }
}

// MARK: Equatable
extension CameraInputBridgeView: Equatable {
    nonisolated static func ==(lhs: Self, rhs: Self) -> Bool { true }
}


// MARK: - GESTURES
extension CameraInputBridgeView { class Coordinator: NSObject { init(_ parent: CameraInputBridgeView) { self.parent = parent }
    let parent: CameraInputBridgeView
}}

// MARK: On Tap
extension CameraInputBridgeView.Coordinator {
    @MainActor @objc func onTapGesture(_ tap: UITapGestureRecognizer) {
        do {
            let touchPoint = tap.location(in: parent.inputView)
            try parent.cameraManager.setCameraFocus(at: touchPoint)
        } catch {}
    }
}

// MARK: On Pinch
extension CameraInputBridgeView.Coordinator {
    @MainActor @objc func onPinchGesture(_ pinch: UIPinchGestureRecognizer) { if pinch.state == .changed {
        do {
            let desiredZoomFactor = parent.cameraManager.attributes.zoomFactor + atan2(pinch.velocity, 33)
            try parent.cameraManager.setCameraZoomFactor(desiredZoomFactor)
        } catch {}
    }}
}
