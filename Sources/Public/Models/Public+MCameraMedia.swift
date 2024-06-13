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
    private let data: Any?
}

// MARK: - Access to Data
public extension MCameraMedia {
    var image: CIImage? { data as? CIImage }
    var video: URL? { data as? URL }
}

// MARK: - Initialisers
extension MCameraMedia {
    static func create(imageData: AVCapturePhoto, filters: [CIFilter]) -> Self? {
        guard let cgImage = imageData.cgImageRepresentation() else { return nil }

        let ciImage = CIImage(cgImage: cgImage)
        let ciImageWithFiltersApplied = ciImage.applyingFilters(filters)

        let capturedImage = MCameraMedia(data: ciImageWithFiltersApplied)
        return capturedImage
    }
    static func create(videoData: URL, filters: [CIFilter]) -> Self {
        fatalError()
    }
}
private extension MCameraMedia {
    static func a() {

    }
}

// MARK: - Equatable
extension MCameraMedia: Equatable {
    public static func == (lhs: MCameraMedia, rhs: MCameraMedia) -> Bool { lhs.image == rhs.image && lhs.video == rhs.video }
}
