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

// MARK: - Initialisers
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
    static func create(videoData: URL, filters: [CIFilter]) -> Self {
        fatalError()
    }
}
private extension MCameraMedia {
    static func prepareCIImage(_ ciImage: CIImage, _ filters: [CIFilter]) -> CIImage {
        let ciImageWithFiltersApplied = ciImage.applyingFilters(filters)
        return ciImageWithFiltersApplied
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

// MARK: - Equatable
extension MCameraMedia: Equatable {
    public static func == (lhs: MCameraMedia, rhs: MCameraMedia) -> Bool { lhs.image == rhs.image && lhs.video == rhs.video }
}
