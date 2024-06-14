//
//  Public+MCameraMedia.swift of MijickCameraView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2024 Mijick. Licensed under MIT License.


import AVKit

public struct MCameraMedia {
    private let data: Any

    init?(data: Any?) { switch data {
        case .some(let data): self.data = data
        case nil: return nil
    }}
}

// MARK: - Access to Data
public extension MCameraMedia {
    var image: UIImage? { data as? UIImage }
    var video: URL? { data as? URL }
}

// MARK: - Image Initialiser
extension MCameraMedia {
    static func create(imageData: AVCapturePhoto, orientation: CGImagePropertyOrientation, filters: [CIFilter]) -> Self? {
        guard let imageData = imageData.fileDataRepresentation(),
              let ciImage = CIImage(data: imageData)
        else { return nil }

        let capturedCIImage = prepareCIImage(ciImage, filters)
        let capturedCGImage = prepareCGImage(capturedCIImage)
        let capturedUIImage = prepareUIImage(capturedCGImage, orientation)

        let capturedMedia = MCameraMedia(data: capturedUIImage)
        return capturedMedia
    }
}
private extension MCameraMedia {
    static func prepareCIImage(_ ciImage: CIImage, _ filters: [CIFilter]) -> CIImage {
        ciImage.applyingFilters(filters)
    }
    static func prepareCGImage(_ ciImage: CIImage) -> CGImage? {
        CIContext().createCGImage(ciImage, from: ciImage.extent)
    }
    static func prepareUIImage(_ cgImage: CGImage?, _ orientation: CGImagePropertyOrientation) -> UIImage? {
        guard let cgImage else { return nil }

        let orientation = UIImage.Orientation(orientation)
        let uiImage = UIImage(cgImage: cgImage, scale: 1.0, orientation: orientation)
        return uiImage
    }
}

// MARK: - Video Initialiser
extension MCameraMedia {
    static func create(videoData: URL, filters: [CIFilter]) async -> Self? { let asset = AVAsset(url: videoData)
        return await withCheckedContinuation { task in


            if #available(iOS 16.0, *) {




                AVVideoComposition.videoComposition(with: asset) { request in
                    let videoFrame = prepareVideoFrame(request, filters)
                    request.finish(with: videoFrame, context: nil)
                } completionHandler: { composition, error in
                    guard error == nil,
                          let composition,
                          let fileUrl = prepareFileUrl(),
                          let exportSession = prepareAssetExportSession(asset, fileUrl, composition)
                    else { return task.resume(returning: nil) }

                    exportSession.exportAsynchronously { onAssetExported(task, fileUrl) }
                }






            } else {
                // Fallback on earlier versions
            }
        }
    }
}
private extension MCameraMedia {

}
private extension MCameraMedia {
    static func prepareVideoFrame(_ request: AVAsynchronousCIImageFilteringRequest, _ filters: [CIFilter]) -> CIImage { request
        .sourceImage
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
    static func onAssetExported(_ task: CheckedContinuation<MCameraMedia?, Never>, _ fileUrl: URL) {
        task.resume(returning: .init(data: fileUrl))
    }
}

private extension MCameraMedia {

}

// MARK: - Equatable
extension MCameraMedia: Equatable {
    public static func == (lhs: MCameraMedia, rhs: MCameraMedia) -> Bool { lhs.image == rhs.image && lhs.video == rhs.video }
}
