//
//  AVVideoComposition++.swift of MijickCameraView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2024 Mijick. Licensed under MIT License.


import AVKit

// MARK: - Applying Filters
extension AVVideoComposition {
    static func applyFilters(to asset: AVAsset, applyFiltersAction: @Sendable @escaping (AVAsynchronousCIImageFilteringRequest) -> ()) async throws -> AVVideoComposition {
        if #available(iOS 16.0, *) { return try await AVVideoComposition.videoComposition(with: asset, applyingCIFiltersWithHandler: applyFiltersAction) }
        return AVVideoComposition(asset: asset, applyingCIFiltersWithHandler: applyFiltersAction)
    }
}
