//
//  Public+MCameraMedia.swift of MijickCameraView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2024 Mijick. Licensed under MIT License.


@preconcurrency import AVKit

public struct MCameraMedia: Sendable {
    private let image: UIImage?
    private let video: URL?

    init?(data: Any?) {
        if let image = data as? UIImage { self.image = image; self.video = nil }
        else if let video = data as? URL { self.video = video; self.image = nil }
        else { return nil }
    }
}

public extension MCameraMedia {
    func getImage() -> UIImage? { image }
    func getVideo() -> URL? { video }
}

// MARK: - Video Initialiser
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

// MARK: - Equatable
extension MCameraMedia: Equatable {
    public static func == (lhs: MCameraMedia, rhs: MCameraMedia) -> Bool { lhs.image == rhs.image && lhs.video == rhs.video }
}
