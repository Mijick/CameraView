//
//  Bundle++.swift of MijickCameraView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2024 Mijick. Licensed under MIT License.


import Foundation

extension Bundle {
    static var mijick: Bundle {
        .allBundles
        .compactMap { $0.resourceURL?.appendingPathComponent("MijickCamera_MijickCamera", isDirectory: false).appendingPathExtension("bundle") }
        .compactMap { Bundle(url: $0) }
        .first ?? .main
    }
}
