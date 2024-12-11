//
//  CameraView+FocusIndicator.swift of MijickCamera
//
//  Created by Tomasz Kurylik. Sending ❤️ from Kraków!
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//    - Medium: https://medium.com/@mijick
//
//  Copyright ©2024 Mijick. All rights reserved.


import SwiftUI

@MainActor class CameraFocusIndicatorView {
    var image: UIImage = .init(resource: .mijickIconCrosshair)
    var tintColor: UIColor = .init(resource: .mijickBackgroundYellow)
    var size: CGFloat = 92
}

// MARK: Create
extension CameraFocusIndicatorView {
    func create(at touchPoint: CGPoint) -> UIImageView {
        let focusIndicator = UIImageView(image: image)
        focusIndicator.tintColor = tintColor
        focusIndicator.frame.size = .init(width: size, height: size)
        focusIndicator.frame.origin.x = touchPoint.x - size / 2
        focusIndicator.frame.origin.y = touchPoint.y - size / 2
        focusIndicator.transform = .init(scaleX: 0, y: 0)
        focusIndicator.tag = .focusIndicatorTag
        return focusIndicator
    }
}
