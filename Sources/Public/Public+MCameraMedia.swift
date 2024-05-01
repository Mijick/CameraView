//
//  Public+MCameraMedia.swift of MijickCameraView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2024 Mijick. Licensed under MIT License.


import Foundation

public struct MCameraMedia {
    private let data: Any?

    init(data: Any?) { self.data = data }
}

// MARK: - Access to Data
public extension MCameraMedia {
    var image: Data? { data as? Data }
    var video: URL? { data as? URL }
}

// MARK: - Equatable
extension MCameraMedia: Equatable {
    public static func == (lhs: MCameraMedia, rhs: MCameraMedia) -> Bool { lhs.image == rhs.image && lhs.video == rhs.video }
}
