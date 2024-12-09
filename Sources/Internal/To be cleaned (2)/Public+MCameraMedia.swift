//
//  Public+MCameraMedia.swift of MijickCamera
//
//  Created by Tomasz Kurylik. Sending ❤️ from Kraków!
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//    - Medium: https://medium.com/@mijick
//
//  Copyright ©2024 Mijick. All rights reserved.


import SwiftUI

public struct MCameraMedia: Sendable {
    private let image: UIImage?
    private let video: URL?

    init?(data: Any?) {
        if let image = data as? UIImage { self.image = image; self.video = nil }
        else if let video = data as? URL { self.video = video; self.image = nil }
        else { return nil }
    }
}

// MARK: Getters
public extension MCameraMedia {
    func getImage() -> UIImage? { image }
    func getVideo() -> URL? { video }
}


// MARK: Equatable
extension MCameraMedia: Equatable {
    public static func == (lhs: MCameraMedia, rhs: MCameraMedia) -> Bool { lhs.image == rhs.image && lhs.video == rhs.video }
}
