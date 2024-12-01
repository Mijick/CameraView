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



// MARK: Start
extension CameraManagerVideo {
    func startRecording() {

    }
}
private extension CameraManagerVideo {

}
private extension CameraManagerVideo {

}
private extension CameraManagerVideo {

}

// MARK: Stop
extension CameraManagerVideo {
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
