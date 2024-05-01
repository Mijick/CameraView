//
//  UIView++.swift of MijickCameraView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2024 Mijick. Licensed under MIT License.


import SwiftUI

// MARK: - Blurring View
extension UIView {
    func applyBlurEffect(style: UIBlurEffect.Style, animationDuration: Double) {
        let blurEffectView = UIVisualEffectView()
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        UIView.animate(withDuration: animationDuration) { blurEffectView.effect = UIBlurEffect(style: style) }

        addSubview(blurEffectView)
    }
}
