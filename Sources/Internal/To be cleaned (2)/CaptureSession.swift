//
//  CaptureSession.swift of MijickCamera
//
//  Created by Tomasz Kurylik. Sending ❤️ from Kraków!
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//    - Medium: https://medium.com/@mijick
//
//  Copyright ©2024 Mijick. All rights reserved.


import AVKit

protocol CaptureSession: Sendable {
    func add(input: (any CaptureDeviceInput)?) throws(MijickCameraError)
    func add(output: AVCaptureOutput?) throws(MijickCameraError)

    func remove(input: (any CaptureDeviceInput)?)


    func startRunning()
    func stopRunningAndReturnNewInstance() -> CaptureSession


    var sessionPreset: AVCaptureSession.Preset { get set }
    var isRunning: Bool { get }


    var deviceInputs: [any CaptureDeviceInput] { get }
    var outputs: [AVCaptureOutput] { get }
}
