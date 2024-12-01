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
import MijickTimer

@MainActor class CameraManagerVideo: NSObject {
    private(set) var recordingTime: MTime = .zero
    private(set) var parent: CameraManager!
    private(set) var output: AVCaptureMovieFileOutput = .init()
    private(set) var timer: MTimer = .init(.camera)
    private(set) var firstRecordedFrame: UIImage?
}

// MARK: Setup
extension CameraManagerVideo {
    func setup(parent: CameraManager) throws {
        self.parent = parent
        try parent.captureSession.add(output: output)
    }
}

// MARK: Reset
extension CameraManagerVideo {
    func reset() {
        timer.reset()
    }
}


// MARK: - CAPTURE VIDEO



// MARK: Toggle
extension CameraManagerVideo {
    func toggleRecording() { switch output.isRecording {
        case true: stopRecording()
        case false: startRecording()
    }}
}

// MARK: Start Recording
private extension CameraManagerVideo {
    func startRecording() {
        guard let url = prepareUrlForVideoRecording() else { return }

        configureOutput()
        storeLastFrame()
        output.startRecording(to: url, recordingDelegate: self)
        startRecordingTimer()
        parent.objectWillChange.send()
    }
}
private extension CameraManagerVideo {
    func prepareUrlForVideoRecording() -> URL? {
        FileManager.prepareURLForVideoOutput()
    }
    func configureOutput() {
        guard let connection = output.connection(with: .video), connection.isVideoMirroringSupported else { return }

        connection.isVideoMirrored = parent.attributes.mirrorOutput ? parent.attributes.cameraPosition != .front : parent.attributes.cameraPosition == .front
        connection.videoOrientation = parent.attributes.deviceOrientation
    }
    func storeLastFrame() {
        guard let texture = parent.cameraMetalView.currentDrawable?.texture,
              let ciImage = CIImage(mtlTexture: texture, options: nil),
              let cgImage = parent.cameraMetalView.ciContext.createCGImage(ciImage, from: ciImage.extent)
        else { return }

        firstRecordedFrame = UIImage(cgImage: cgImage, scale: 1.0, orientation: parent.attributes.deviceOrientation.toImageOrientation())
    }
    func startRecordingTimer() { try? timer
        .publish(every: 1) { [self] in
            recordingTime = $0
            parent.objectWillChange.send()
        }
        .start()
    }
}

// MARK: Stop Recording
private extension CameraManagerVideo {
    func stopRecording() {
        presentLastFrame()
        output.stopRecording()
        timer.reset()
    }
}
private extension CameraManagerVideo {
    func presentLastFrame() {
        parent.attributes.capturedMedia = .init(data: firstRecordedFrame)
    }
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


// MARK: - HELPERS
fileprivate extension MTimerID {
    static let camera: MTimerID = .init(rawValue: "mijick-camera")
}





extension MCameraMedia {
    static func create(videoData: URL, filters: [CIFilter]) async throws -> Self? {
        guard !filters.isEmpty else { return .init(data: videoData) }

        let asset = AVAsset(url: videoData),
            videoComposition = try await AVVideoComposition.applyFilters(to: asset, applyFiltersAction: { applyFiltersToVideo($0, filters) }),
            fileUrl = prepareFileUrl(),
            exportSession = prepareAssetExportSession(asset, fileUrl, videoComposition)

        try await exportVideo(exportSession, fileUrl)
        return .init(data: fileUrl)
    }
}
private extension MCameraMedia {
    static func applyFiltersToVideo(_ request: AVAsynchronousCIImageFilteringRequest, _ filters: [CIFilter]) {
        let videoFrame = prepareVideoFrame(request, filters)
        request.finish(with: videoFrame, context: nil)
    }
    static func exportVideo(_ exportSession: AVAssetExportSession?, _ fileUrl: URL?) async throws { if let fileUrl {
        if #available(iOS 18, *) { try await exportSession?.export(to: fileUrl, as: .mov) }
        else { await exportSession?.export() }
    }}
}
private extension MCameraMedia {
    static func prepareVideoFrame(_ request: AVAsynchronousCIImageFilteringRequest, _ filters: [CIFilter]) -> CIImage { request
        .sourceImage
        .clampedToExtent()
        .applyingFilters(filters)
    }
    static func prepareFileUrl() -> URL? {
        FileManager.prepareURLForVideoOutput()
    }
    static func prepareAssetExportSession(_ asset: AVAsset, _ fileUrl: URL?, _ composition: AVVideoComposition?) -> AVAssetExportSession? {
        let export = AVAssetExportSession(asset: asset, presetName: AVAssetExportPreset1920x1080)
        export?.outputFileType = .mov
        export?.outputURL = fileUrl
        export?.videoComposition = composition
        return export
    }
}
