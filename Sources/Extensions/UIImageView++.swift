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
    static func create(image: ImageResource, tintColor: UIColor, size: CGFloat) -> UIImageView {
        let imageView = UIImageView(image: .init(resource: image))
        imageView.tintColor = tintColor
        imageView.frame.size = .init(width: size, height: size)
        return imageView
    }
}
