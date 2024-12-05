//
//  CIImage++.swift of MijickCameraView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2024 Mijick. Licensed under MIT License.


import SwiftUI

extension CIImage {
    func applyingFilters(_ filters: [CIFilter]) -> CIImage {
        var ciImage = self
        filters.forEach {
            $0.setValue(ciImage, forKey: kCIInputImageKey)
            ciImage = $0.outputImage ?? ciImage
        }
        return ciImage
    }
}
