//
//  Public+CameraManager.swift of MijickCameraView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2024 Mijick. Licensed under MIT License.


import SwiftUI
import AVFoundation

// MARK: - Initialiser
public extension CameraManager {
    convenience init(
        outputType: CameraOutputType? = nil,
        cameraPosition: CameraPosition? = nil,
        cameraFilters: [CIFilter]? = nil,
        resolution: AVCaptureSession.Preset? = nil,
        flashMode: CameraFlashMode? = nil,
        isGridVisible: Bool? = nil,
        focusImage: UIImage? = nil,
        focusImageColor: UIColor? = nil,
        focusImageSize: CGFloat? = nil
    ) {
        self.init(.init(outputType, cameraPosition, cameraFilters, resolution, flashMode, isGridVisible))

        if let focusImage { self.cameraFocusView.image = focusImage }
        if let focusImageColor { self.cameraFocusView.tintColor = focusImageColor }
        if let focusImageSize { self.cameraFocusView.frame.size = .init(width: focusImageSize, height: focusImageSize) }
    }
}
private extension CameraManager.Attributes {
    init(_ outputType: CameraOutputType?, _ cameraPosition: CameraPosition?, _ cameraFilters: [CIFilter]?, _ resolution: AVCaptureSession.Preset?, _ flashMode: CameraFlashMode?, _ isGridVisible: Bool?) { self.init()
        if let outputType { self.outputType = outputType }
        if let cameraPosition { self.cameraPosition = cameraPosition }
        if let cameraFilters { self.cameraFilters = cameraFilters }
        if let resolution { self.resolution = resolution }
        if let flashMode { self.flashMode = flashMode }
        if let isGridVisible { self.isGridVisible = isGridVisible }
    }
}
