//
//  CameraManagerConfig.swift of MijickCameraView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2024 Mijick. Licensed under MIT License.


import AVKit

public class CameraManagerConfig { public init() {}
    var outputType: CameraOutputType = .photo
    var cameraPosition: AVCaptureDevice.Position = .back
    var zoomFactor: CGFloat = 1.0
    var flashMode: AVCaptureDevice.FlashMode = .off
    var torchMode: AVCaptureDevice.TorchMode = .off
    var mirrorOutput: Bool = false
    var gridVisible: Bool = true
    var pinchVelocity: CGFloat = 33

    var focusImage: UIImage = .init(resource: .iconCrosshair)
    var focusImageColor: UIColor = .yellow
    var focusImageSize: CGFloat = 92
}
