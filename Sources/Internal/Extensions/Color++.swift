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
    static let accent: Color = .init(hex: 0x087F8C)
    static let yellow: Color = .init(hex: 0xF0C808)
    static let red: Color = .init(hex: 0xD52941)
}
extension UIColor {
    static let accent: UIColor = .init(hex: 0x087F8C)
    static let yellow: UIColor = .init(hex: 0xF0C808)
    static let red: UIColor = .init(hex: 0xD52941)
}


// MARK: - Helpers
fileprivate extension Color {
    init(hex: UInt) { self.init(.sRGB, red: Double((hex >> 16) & 0xff) / 255, green: Double((hex >> 08) & 0xff) / 255, blue: Double((hex >> 00) & 0xff) / 255) }
}
fileprivate extension UIColor {
    convenience init(hex: UInt) { self.init(red: Double((hex >> 16) & 0xff) / 255, green: Double((hex >> 08) & 0xff) / 255, blue: Double((hex >> 00) & 0xff) / 255, alpha: 1) }
}
