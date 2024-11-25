//
//  CameraManagerAttributes.swift of MijickCamera
//
//  Created by Tomasz Kurylik. Sending ❤️ from Kraków!
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//    - Medium: https://medium.com/@mijick
//
//  Copyright ©2024 Mijick. All rights reserved.


@preconcurrency import AVKit
import MijickTimer

struct CameraManagerAttributes {
    var capturedMedia: MCameraMedia? = nil
    var error: CameraManagerError? = nil

    var outputType: CameraOutputType = .photo
    var cameraPosition: CameraPosition = .back
    var cameraFilters: [CIFilter] = []
    var zoomFactor: CGFloat = 1.0
    var flashMode: CameraFlashMode = .off
    var torchMode: CameraTorchMode = .off
    var cameraExposure: CameraExposure = .init()
    var hdrMode: CameraHDRMode = .auto
    var resolution: AVCaptureSession.Preset = .hd1920x1080
    var frameRate: Int32 = 30
    var mirrorOutput: Bool = false
    var isGridVisible: Bool = true
    var isRecording: Bool = false
    var recordingTime: MTime = .zero

    var deviceOrientation: AVCaptureVideoOrientation = .portrait
    var userBlockedScreenRotation: Bool = false


    // tutaj trzeba dac funkcje change albo init
    // pozostaje jeszcze kwestia initial values, co przydaje się przy resecie, ale raczej nie jest to juz potrzebne
    // całość logiki w zasadzie można przeniesć do deinit i będzie działać
    // sens tego jest taki, że atrybuty tutaj zmieniane wpływają na odświeżanie się UI
}


extension CameraManagerAttributes {
    mutating func set(outputType: CameraOutputType? = nil, cameraPosition: CameraPosition? = nil, cameraFilters: [CIFilter]? = nil, resolution: AVCaptureSession.Preset? = nil, frameRate: Int32? = nil, flashMode: CameraFlashMode? = nil, gridVisible: Bool? = nil) {
        if let outputType { self.outputType = outputType }
        if let cameraPosition { self.cameraPosition = cameraPosition }
        if let cameraFilters { self.cameraFilters = cameraFilters }
        if let resolution { self.resolution = resolution }
        if let frameRate { self.frameRate = frameRate }
        if let flashMode { self.flashMode = flashMode }
        if let gridVisible { self.isGridVisible = gridVisible }
    }
}
