//
//  FileManager++.swift of MijickCamera
//
//  Created by Tomasz Kurylik. Sending ❤️ from Kraków!
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//    - Medium: https://medium.com/@mijick
//
//  Copyright ©2024 Mijick. All rights reserved.


import SwiftUI

// MARK: - Preparing place for video output
extension FileManager {
    static func prepareURLForVideoOutput() -> URL? {
        guard let fileUrl = createFileUrl() else { return nil }

        clearPlaceIfTaken(fileUrl)
        return fileUrl
    }
}
private extension FileManager {
    static func createFileUrl() -> URL? {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            .first?
            .appendingPathComponent(videoPath)
    }
    static func clearPlaceIfTaken(_ url: URL) {
        try? FileManager.default.removeItem(at: url)
    }
}
private extension FileManager {
    static var videoPath: String { "mijick-camera-video-output.mp4" }
}
