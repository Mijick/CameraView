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
    static func applyFilters(to asset: AVAsset, applyFiltersAction: (AVAsynchronousCIImageFilteringRequest) -> (), completionHandler: (AVVideoComposition, (any Error)?)) {
        if #available(iOS 16.0, *) {}
        else {}
    }
}
private extension AVVideoComposition {
    @available(iOS 16.0, *)
    static func applyFiltersNewWay(_ asset: AVAsset, _ applyFiltersAction: @escaping (AVAsynchronousCIImageFilteringRequest) -> (), _ completionHandler: @escaping (AVVideoComposition?, (any Error)?) -> ()) {
        AVVideoComposition.videoComposition(with: asset, applyingCIFiltersWithHandler: applyFiltersAction, completionHandler: completionHandler)
    }
    static func applyFiltersOldWay(_ asset: AVAsset, _ applyFiltersAction: @escaping (AVAsynchronousCIImageFilteringRequest) -> (), _ completionHandler: @escaping (AVVideoComposition?, (any Error)?) -> ()) {
        let composition = AVVideoComposition(asset: asset, applyingCIFiltersWithHandler: applyFiltersAction)
        completionHandler(composition, nil)
    }
}
private extension AVVideoComposition {

}
private extension AVVideoComposition {

}
