//
//  CIImage++.swift of MijickCamera
//
//  Created by Tomasz Kurylik. Sending ❤️ from Kraków!
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//    - Medium: https://medium.com/@mijick
//
//  Copyright ©2024 Mijick. All rights reserved.


import SwiftUI

// MARK: Applying Filters
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
