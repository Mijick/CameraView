//
//  UIImageView++.swift of MijickCameraView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2024 Mijick. Licensed under MIT License.


import SwiftUI

extension UIImageView {
    convenience init(image: ImageResource, tintColor: UIColor, size: CGFloat) {
        self.init(image: .init(resource: image))
        self.tintColor = tintColor
        self.frame.size = .init(width: size, height: size)
    }
}
