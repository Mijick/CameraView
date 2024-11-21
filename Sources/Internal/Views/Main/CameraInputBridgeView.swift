//
//  CameraInputBridgeView.swift of MijickCameraView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2024 Mijick. Licensed under MIT License.


import SwiftUI

struct CameraInputBridgeView {
    let cameraManager: CameraManager
    let inputView: UIView = .init()

    init(_ cameraManager: CameraManager) { self.cameraManager = cameraManager }
}


// MARK: - PROTOCOLS CONFORMANCE



// MARK: UIViewRepresentable
extension CameraInputBridgeView: UIViewRepresentable {
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
    func setupCameraManager() {
        cameraManager.setup(in: inputView)
    }
    func setupTapGesture(_ context: Context) {
        let tapRecognizer = UITapGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handleTapGesture))
        inputView.addGestureRecognizer(tapRecognizer)
    }
    func setupPinchGesture(_ context: Context) {
        let pinchRecognizer = UIPinchGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handlePinchGesture))
        inputView.addGestureRecognizer(pinchRecognizer)
    }
}

// MARK: Equatable
extension CameraInputBridgeView: Equatable {
    static func ==(lhs: Self, rhs: Self) -> Bool { true }
}


// MARK: - LOGIC
extension CameraInputBridgeView { class Coordinator: NSObject {
    let parent: CameraInputBridgeView

    init(_ parent: CameraInputBridgeView) { self.parent = parent }
}}

// MARK: On Tap
extension CameraInputBridgeView.Coordinator {
    @objc func handleTapGesture(_ tap: UITapGestureRecognizer) {
        let touchPoint = tap.location(in: parent.inputView)
        setCameraFocus(touchPoint)
    }
}
private extension CameraInputBridgeView.Coordinator {
    func setCameraFocus(_ touchPoint: CGPoint) {
        do { try parent.cameraManager.setCameraFocus(touchPoint) }
        catch {}
    }
}

// MARK: On Pinch
extension CameraInputBridgeView.Coordinator {
    @objc func handlePinchGesture(_ pinch: UIPinchGestureRecognizer) { if pinch.state == .changed {
        let desiredZoomFactor = parent.cameraManager.attributes.zoomFactor + atan2(pinch.velocity, 33)
        changeZoomFactor(desiredZoomFactor)
    }}
}
private extension CameraInputBridgeView.Coordinator {
    func changeZoomFactor(_ desiredZoomFactor: CGFloat) {
        do { try parent.cameraManager.changeZoomFactor(desiredZoomFactor) }
        catch {}
    }
}
