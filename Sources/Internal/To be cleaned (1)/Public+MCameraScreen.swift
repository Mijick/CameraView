//
//  Public+MCameraScreen.swift of MijickCamera
//
//  Created by Tomasz Kurylik. Sending ❤️ from Kraków!
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//    - Medium: https://medium.com/@mijick
//
//  Copyright ©2024 Mijick. All rights reserved.


import SwiftUI
import AVFoundation
import MijickTimer

public protocol MCameraScreen: View {
    var cameraManager: CameraManager { get }
    var namespace: Namespace.ID { get }
    var closeControllerAction: () -> () { get }
}

// MARK: View Methods
public extension MCameraScreen {
    func createCameraView() -> some View { CameraInputBridgeView(cameraManager: cameraManager).equatable() }
}

// MARK: Logic Methods
public extension MCameraScreen {
    func captureOutput() { cameraManager.captureOutput() }
    func setOutputType(_ outputType: CameraOutputType) { cameraManager.setOutputType(outputType) }
    func setCameraPosition(_ cameraPosition: CameraPosition) async throws { try await cameraManager.setCameraPosition(cameraPosition) }
    func setZoomFactor(_ zoomFactor: CGFloat) throws { try cameraManager.setCameraZoomFactor(zoomFactor) }
    func setFlashMode(_ flashMode: CameraFlashMode) { cameraManager.setFlashMode(flashMode) }
    func setLightMode(_ lightMode: CameraLightMode) throws { try cameraManager.setLightMode(lightMode) }
    func setMirrorOutput(_ shouldMirror: Bool) { cameraManager.setMirrorOutput(shouldMirror) }
    func setGridVisibility(_ shouldShowGrid: Bool) { cameraManager.setGridVisibility(shouldShowGrid) }
    func setCameraFilters(_ filters: [CIFilter]) { cameraManager.setCameraFilters(filters) }




    func setResolution(_ resolution: AVCaptureSession.Preset) { cameraManager.setResolution(resolution) }
    func setFrameRate(_ frameRate: Int32) throws { try cameraManager.setFrameRate(frameRate) }



    func setExposureMode(_ exposureMode: AVCaptureDevice.ExposureMode) throws { try cameraManager.setExposureMode(exposureMode) }
    func setExposureDuration(_ value: CMTime) throws { try cameraManager.setExposureDuration(value) }
    func setISO(_ value: Float) throws { try cameraManager.setISO(value) }
    func setExposureTargetBias(_ value: Float) throws { try cameraManager.setExposureTargetBias(value) }
    func setHDRMode(_ mode: CameraHDRMode) throws { try cameraManager.setHDRMode(mode) }


}

// MARK: Attributes
public extension MCameraScreen {
    var outputType: CameraOutputType { cameraManager.attributes.outputType }
    var cameraPosition: CameraPosition { cameraManager.attributes.cameraPosition }
    var resolution: AVCaptureSession.Preset { cameraManager.attributes.resolution }
    var frameRate: Int32 { cameraManager.attributes.frameRate }
    var zoomFactor: CGFloat { cameraManager.attributes.zoomFactor }
    var lightMode: CameraLightMode { cameraManager.attributes.lightMode }
    var flashMode: CameraFlashMode { cameraManager.attributes.flashMode }
    var exposureMode: AVCaptureDevice.ExposureMode { cameraManager.attributes.cameraExposure.mode }
    var exposureDuration: CMTime { cameraManager.attributes.cameraExposure.duration }
    var iso: Float { cameraManager.attributes.cameraExposure.iso }
    var exposureTargetBias: Float { cameraManager.attributes.cameraExposure.targetBias }
    var hdrMode: CameraHDRMode { cameraManager.attributes.hdrMode }
    var mirrorOutput: Bool { cameraManager.attributes.mirrorOutput }
    var showGrid: Bool { cameraManager.attributes.isGridVisible }
    var deviceOrientation: AVCaptureVideoOrientation { cameraManager.attributes.deviceOrientation }
    var isRecording: Bool { cameraManager.videoOutput.timer.timerStatus == .running }
    var recordingTime: MTime { cameraManager.videoOutput.recordingTime }
    var hasLight: Bool { cameraManager.hasLight }
    var hasFlash: Bool { cameraManager.hasFlash }
    var isOrientationLocked: Bool { cameraManager.attributes.orientationLocked || cameraManager.attributes.userBlockedScreenRotation }
}
