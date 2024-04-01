//
//  Color++.swift of MijickCameraView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2024 Mijick. Licensed under MIT License.


import SwiftUI

extension Color {
    static var accent: Color = .init(red: 8.toRGB(), green: 127.toRGB(), blue: 140.toRGB())
    static var yellow: Color = .init(red: 240.toRGB(), green: 200.toRGB(), blue: 8.toRGB())
    static var red: Color = .init(red: 213.toRGB(), green: 41.toRGB(), blue: 65.toRGB())
    static var background: Color = .init(red: 4.toRGB(), green: 4.toRGB(), blue: 4.toRGB())
}
extension UIColor {
    static var accent: UIColor = .init(red: 8.toRGB(), green: 127.toRGB(), blue: 140.toRGB(), alpha: 1)
    static var yellow: UIColor = .init(red: 240.toRGB(), green: 200.toRGB(), blue: 8.toRGB(), alpha: 1)
    static var red: UIColor = .init(red: 213.toRGB(), green: 41.toRGB(), blue: 65.toRGB(), alpha: 1)
    static var background: UIColor = .init(red: 4.toRGB(), green: 4.toRGB(), blue: 4.toRGB(), alpha: 1)
}


// MARK: - Helpers
fileprivate extension Int {
    func toRGB() -> CGFloat { CGFloat(self) / 255 }
}
