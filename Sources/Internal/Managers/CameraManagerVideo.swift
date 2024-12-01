//
//  CameraManagerVideo.swift of MijickCamera
//
//  Created by Tomasz Kurylik. Sending ❤️ from Kraków!
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//    - Medium: https://medium.com/@mijick
//
//  Copyright ©2024 Mijick. All rights reserved.


import AVKit

@MainActor class CameraManagerVideo: NSObject {
    private(set) var parent: CameraManager!
    private(set) var videoOutput: AVCaptureMovieFileOutput = .init()
}

// MARK: Setup
extension CameraManagerVideo {
    func setup(parent: CameraManager) throws {
        self.parent = parent
        try parent.captureSession.add(output: videoOutput)
    }
}


// MARK: - CAPTURE VIDEO



// MARK: Toggle
extension CameraManagerVideo {
    func toggleRecording() { switch videoOutput.isRecording {
        case true: stopRecording()
        case false: startRecording()
    }}
}

// MARK: Start Recording
private extension CameraManagerVideo {
    func startRecording() {

    }
}
private extension CameraManagerVideo {
    func configureOutput() {
        guard let connection = videoOutput.connection(with: .video), connection.isVideoMirroringSupported else { return }

        connection.isVideoMirrored = parent.attributes.mirrorOutput ? parent.attributes.cameraPosition != .front : parent.attributes.cameraPosition == .front
        connection.videoOrientation = parent.attributes.deviceOrientation
    }
}
private extension CameraManagerVideo {

}
private extension CameraManagerVideo {

}

// MARK: Stop Recording
private extension CameraManagerVideo {
    func stopRecording() {

    }
}
private extension CameraManagerVideo {

}
private extension CameraManagerVideo {

}
private extension CameraManagerVideo {

}

// MARK: Receive Data
extension CameraManagerVideo: @preconcurrency AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: (any Swift.Error)?) { Task {
        parent.attributes.capturedMedia = try await .create(videoData: outputFileURL, filters: parent.attributes.cameraFilters)
    }}
}
private extension CameraManagerVideo {

}
private extension CameraManagerVideo {

}
private extension CameraManagerVideo {

}
private extension CameraManagerVideo {

}
