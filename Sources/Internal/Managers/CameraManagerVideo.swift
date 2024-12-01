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

}


// MARK: - CAPTURE VIDEO



// MARK: Start
extension CameraManagerVideo {

}

// MARK: Stop
extension CameraManagerVideo {

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
