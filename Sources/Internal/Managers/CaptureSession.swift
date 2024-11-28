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

protocol CaptureSession {
    func add(input: (any CaptureDeviceInput)?) throws(MijickCameraError)
    func add(output: AVCaptureOutput?) throws(MijickCameraError)

    func remove(input: (any CaptureDeviceInput)?)


    func startRunning()
    func stopRunning()


    init()


    var sessionPreset: AVCaptureSession.Preset { get set }
    var isRunning: Bool { get }


    var deviceInputs: [any CaptureDeviceInput] { get }
    var outputs: [AVCaptureOutput] { get }
}



// MARK: REAL
extension AVCaptureSession: @unchecked @retroactive Sendable {}
extension AVCaptureSession: CaptureSession {
    var deviceInputs: [any CaptureDeviceInput] {
        inputs as? [any CaptureDeviceInput] ?? []
    }

    func remove(input: (any CaptureDeviceInput)?) {
        guard let input = input as? AVCaptureDeviceInput else { return }
        removeInput(input)
    }

    func add(output: AVCaptureOutput?) throws(MijickCameraError) {
        guard let output, canAddOutput(output) else { throw MijickCameraError.cannotSetupOutput }
        addOutput(output)
    }

    func add(input: (any CaptureDeviceInput)?) throws(MijickCameraError) {
        guard let input = input as? AVCaptureDeviceInput, canAddInput(input) else { throw MijickCameraError.cannotSetupInput }
        addInput(input)
    }
}





// MARK: MOCK
extension MockCaptureSession: @unchecked Sendable {}
class MockCaptureSession: NSObject, CaptureSession {
    var deviceInputs: [any CaptureDeviceInput] { _inputs }

    var outputs: [AVCaptureOutput] { _outputs }

    var isRunning: Bool { _isRunning }




    var captureInputs: [any CaptureDeviceInput] = []
    private var _outputs: [AVCaptureOutput] = []
    private var _inputs: [any CaptureDeviceInput] = []
    private var _isRunning: Bool = false


    func remove(input: (any CaptureDeviceInput)?) {
        //guard let input = input as? MockDeviceInput, let index = inputs.firstIndex(of: input) else { return }




        fatalError()
    }
    required override init() {}

    func add(output: AVCaptureOutput?) throws(MijickCameraError) {
        guard let output, !outputs.contains(output) else { throw MijickCameraError.cannotSetupOutput }
        _outputs.append(output)
    }
    func add(input: (any CaptureDeviceInput)?) throws(MijickCameraError) {
        guard let input = input as? MockDeviceInput, !captureInputs.contains(where: { input == $0 }) else { throw MijickCameraError.cannotSetupInput }
        captureInputs.append(input)
    }

    func startRunning() {
        _isRunning = true
    }

    func stopRunning() {
        _isRunning = false
    }

    var sessionPreset: AVCaptureSession.Preset = .cif352x288
}