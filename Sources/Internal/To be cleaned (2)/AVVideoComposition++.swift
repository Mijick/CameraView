//
//  AVVideoComposition++.swift of MijickCamera
//
//  Created by Tomasz Kurylik. Sending ❤️ from Kraków!
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//    - Medium: https://medium.com/@mijick
//
//  Copyright ©2024 Mijick. All rights reserved.


import AVKit

// MARK: - Applying Filters
extension AVVideoComposition {
    static func applyFilters(to asset: AVAsset, applyFiltersAction: @Sendable @escaping (AVAsynchronousCIImageFilteringRequest) -> ()) async throws -> AVVideoComposition {
        if #available(iOS 16.0, *) { return try await AVVideoComposition.videoComposition(with: asset, applyingCIFiltersWithHandler: applyFiltersAction) }
        return AVVideoComposition(asset: asset, applyingCIFiltersWithHandler: applyFiltersAction)
    }
}
