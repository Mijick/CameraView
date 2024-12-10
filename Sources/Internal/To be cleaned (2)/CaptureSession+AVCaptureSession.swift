//
//  CaptureSession+AVCaptureSession.swift of MijickCamera
//
//  Created by Tomasz Kurylik. Sending ❤️ from Kraków!
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//    - Medium: https://medium.com/@mijick
//
//  Copyright ©2024 Mijick. All rights reserved.


import AVKit

extension AVCaptureSession: @unchecked @retroactive Sendable {}
extension AVCaptureSession: CaptureSession {
    func stopRunningAndReturnNewInstance() -> any CaptureSession {
        self.stopRunning()
        return AVCaptureSession()
    }


    var deviceInputs: [any CaptureDeviceInput] {
        inputs as? [any CaptureDeviceInput] ?? []
    }

    func remove(input: (any CaptureDeviceInput)?) {
        guard let input = input as? AVCaptureDeviceInput else { return }
        removeInput(input)
    }

    func add(output: AVCaptureOutput?) throws(MijickCameraError) {
        guard let output else { throw MijickCameraError.cannotSetupOutput }
        if canAddOutput(output) { addOutput(output) }
    }

    func add(input: (any CaptureDeviceInput)?) throws(MijickCameraError) {
        guard let input = input as? AVCaptureDeviceInput else { throw MijickCameraError.cannotSetupInput }
        if canAddInput(input) { addInput(input) }
    }
}
