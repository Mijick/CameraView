//
//  Public+MCameraView.swift of MijickCameraView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2024 Mijick. Licensed under MIT License.


import SwiftUI
import AVFoundation
import MijickTimer

public protocol MCameraView: View {
    var cameraManager: CameraManager { get }
    var namespace: Namespace.ID { get }
    var closeControllerAction: () -> () { get }
}

// MARK: - Use-only View Methods
public extension MCameraView {
    func createCameraView() -> some View { CameraInputBridgeView(cameraManager: cameraManager).equatable() }
}

// MARK: - Use-only Logic Methods
public extension MCameraView {
    func captureOutput() { cameraManager.captureOutput() }
    func changeOutputType(_ type: CameraOutputType) throws { try cameraManager.changeOutputType(type) }
    func changeCamera(_ position: CameraPosition) throws { try cameraManager.changeCamera(position) }
    func changeCameraFilters(_ filters: [CIFilter]) throws { try cameraManager.changeCameraFilters(filters) }
    func changeResolution(_ resolution: AVCaptureSession.Preset) throws { try cameraManager.changeResolution(resolution) }
    func changeFrameRate(_ frameRate: Int32) throws { try cameraManager.changeFrameRate(frameRate) }
    func changeZoomFactor(_ value: CGFloat) throws { try cameraManager.changeZoomFactor(value) }
    func changeFlashMode(_ mode: CameraFlashMode) throws { try cameraManager.changeFlashMode(mode) }
    func changeTorchMode(_ mode: CameraTorchMode) throws { try cameraManager.changeTorchMode(mode) }
    func changeExposureMode(_ exposureMode: AVCaptureDevice.ExposureMode) throws { try cameraManager.changeExposureMode(exposureMode) }
    func changeExposureDuration(_ value: CMTime) throws { try cameraManager.changeExposureDuration(value) }
    func changeISO(_ value: Float) throws { try cameraManager.changeISO(value) }
    func changeExposureTargetBias(_ value: Float) throws { try cameraManager.changeExposureTargetBias(value) }
    func changeHDRMode(_ mode: CameraHDRMode) throws { try cameraManager.changeHDRMode(mode) }
    func changeMirrorOutputMode(_ shouldMirror: Bool) { cameraManager.changeMirrorMode(shouldMirror) }
    func changeGridVisibility(_ shouldShowGrid: Bool) { cameraManager.changeGridVisibility(shouldShowGrid) }
}

// MARK: - Flags
public extension MCameraView {
    var outputType: CameraOutputType { cameraManager.attributes.outputType }
    var cameraPosition: CameraPosition { cameraManager.attributes.cameraPosition }
    var resolution: AVCaptureSession.Preset { cameraManager.attributes.resolution }
    var frameRate: Int32 { cameraManager.attributes.frameRate }
    var zoomFactor: CGFloat { cameraManager.attributes.zoomFactor }
    var torchMode: CameraTorchMode { cameraManager.attributes.torchMode }
    var flashMode: CameraFlashMode { cameraManager.attributes.flashMode }
    var exposureMode: AVCaptureDevice.ExposureMode { cameraManager.attributes.cameraExposure.mode }
    var exposureDuration: CMTime { cameraManager.attributes.cameraExposure.duration }
    var iso: Float { cameraManager.attributes.cameraExposure.iso }
    var exposureTargetBias: Float { cameraManager.attributes.cameraExposure.targetBias }
    var hdrMode: CameraHDRMode { cameraManager.attributes.hdrMode }
    var mirrorOutput: Bool { cameraManager.attributes.mirrorOutput }
    var showGrid: Bool { cameraManager.attributes.isGridVisible }
    var deviceOrientation: AVCaptureVideoOrientation { cameraManager.attributes.deviceOrientation }
    var isRecording: Bool { cameraManager.videoOutput.isRecording }
    var recordingTime: MTime { cameraManager.videoOutput.recordingTime }
    var hasTorch: Bool { cameraManager.hasTorch }
    var hasFlash: Bool { cameraManager.hasFlash }
    var isOrientationLocked: Bool { cameraManager.orientationLocked || cameraManager.attributes.userBlockedScreenRotation }
}
