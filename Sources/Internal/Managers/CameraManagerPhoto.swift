//
//  CameraManagerPhoto.swift of MijickCamera
//
//  Created by Tomasz Kurylik. Sending ❤️ from Kraków!
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//    - Medium: https://medium.com/@mijick
//
//  Copyright ©2024 Mijick. All rights reserved.


import AVKit

@MainActor class CameraManagerPhoto: NSObject {
    private(set) var parent: CameraManager!
    private(set) var photoOutput: AVCapturePhotoOutput = .init()
}

// MARK: Setup
extension CameraManagerPhoto {
    func setup(parent: CameraManager) throws {
        self.parent = parent
        try self.parent.captureSession.add(output: photoOutput)
    }
}


// MARK: - CAPTURE PHOTO



// MARK: Trigger
extension CameraManagerPhoto {
    func capturePhoto() {
        let settings = getPhotoOutputSettings()

        configureOutput()
        photoOutput.capturePhoto(with: settings, delegate: self)
        parent.cameraMetalView.performImageCaptureAnimation()
    }
}
private extension CameraManagerPhoto {
    func getPhotoOutputSettings() -> AVCapturePhotoSettings {
        let settings = AVCapturePhotoSettings()
        settings.flashMode = parent.attributes.flashMode.get()
        return settings
    }
    func configureOutput() {
        guard let connection = photoOutput.connection(with: .video), connection.isVideoMirroringSupported else { return }

        connection.isVideoMirrored = parent.attributes.mirrorOutput ? parent.attributes.cameraPosition != .front : parent.attributes.cameraPosition == .front
        connection.videoOrientation = parent.attributes.deviceOrientation
    }
}

// MARK: Receive Data
extension CameraManagerPhoto: @preconcurrency AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: (any Swift.Error)?) {
        parent.attributes.capturedMedia = .create(imageData: photo, orientation: fixedFrameOrientation(), filters: parent.attributes.cameraFilters)
    }
}
private extension CameraManagerPhoto {
    func fixedFrameOrientation() -> CGImagePropertyOrientation {
        guard UIDevice.current.orientation != parent.attributes.deviceOrientation.toDeviceOrientation() else { return parent.frameOrientation }
        return switch (parent.attributes.deviceOrientation, parent.attributes.cameraPosition) {
            case (.portrait, .front): .left
            case (.portrait, .back): .right
            case (.landscapeLeft, .back): .down
            case (.landscapeRight, .back): .up
            case (.landscapeLeft, .front) where parent.attributes.mirrorOutput: .up
            case (.landscapeLeft, .front): .upMirrored
            case (.landscapeRight, .front) where parent.attributes.mirrorOutput: .down
            case (.landscapeRight, .front): .downMirrored
            default: .right
        }
    }
}
