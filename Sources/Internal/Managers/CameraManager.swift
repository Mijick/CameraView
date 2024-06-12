//
//  CameraManager.swift of MijickCameraView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2024 Mijick. Licensed under MIT License.


import SwiftUI
import AVKit
import CoreMotion
import MijickTimer

public class CameraManager: NSObject, ObservableObject {
    // MARK: Attributes
    @Published private(set) var capturedMedia: MCameraMedia? = nil
    @Published private(set) var outputType: CameraOutputType = .photo
    @Published private(set) var cameraPosition: CameraPosition = .back
    @Published private(set) var zoomFactor: CGFloat = 1.0
    @Published private(set) var flashMode: CameraFlashMode = .off
    @Published private(set) var torchMode: CameraTorchMode = .off
    @Published private(set) var mirrorOutput: Bool = false
    @Published private(set) var isGridVisible: Bool = true
    @Published private(set) var isRecording: Bool = false
    @Published private(set) var recordingTime: MTime = .zero
    @Published private(set) var deviceOrientation: AVCaptureVideoOrientation = .portrait

    // MARK: Devices
    private var frontCamera: AVCaptureDevice?
    private var backCamera: AVCaptureDevice?
    private var microphone: AVCaptureDevice?

    // MARK: Input
    private var captureSession: AVCaptureSession!
    private var frontCameraInput: AVCaptureDeviceInput?
    private var backCameraInput: AVCaptureDeviceInput?
    private var audioInput: AVCaptureDeviceInput?

    // MARK: Output
    private var photoOutput: AVCapturePhotoOutput?
    private var videoOutput: AVCaptureMovieFileOutput?

    // MARK: UI Elements
    private(set) var cameraLayer: AVCaptureVideoPreviewLayer!
    private(set) var cameraGridView: GridView!
    private(set) var cameraBlurView: UIImageView!
    private(set) var cameraFocusView: UIImageView = .create(image: .iconCrosshair, tintColor: .yellow, size: 92)

    // MARK: Others
    private var motionManager: CMMotionManager = .init()
    private var lastAction: LastAction = .none
    private var timer: MTimer = .createNewInstance()
    private var orientationLocked: Bool = false
}

// MARK: - Changing Attributes
extension CameraManager {
    func change(outputType: CameraOutputType? = nil, cameraPosition: CameraPosition? = nil, flashMode: CameraFlashMode? = nil, isGridVisible: Bool? = nil, focusImage: UIImage? = nil, focusImageColor: UIColor? = nil, focusImageSize: CGFloat? = nil) {
        if let outputType { self.outputType = outputType }
        if let cameraPosition { self.cameraPosition = cameraPosition }
        if let flashMode { self.flashMode = flashMode }
        if let isGridVisible { self.isGridVisible = isGridVisible }
        if let focusImage { self.cameraFocusView.image = focusImage }
        if let focusImageColor { self.cameraFocusView.tintColor = focusImageColor }
        if let focusImageSize { self.cameraFocusView.frame.size = .init(width: focusImageSize, height: focusImageSize) }
    }
    func resetCapturedMedia() {
        capturedMedia = nil
    }
    func resetZoomAndTorch() {
        zoomFactor = 1.0
        torchMode = .off
    }
}

// MARK: - Checking Camera Permissions
extension CameraManager {
    func checkPermissions() throws {
        if AVCaptureDevice.authorizationStatus(for: .audio) == .denied { throw Error.microphonePermissionsNotGranted }
        if AVCaptureDevice.authorizationStatus(for: .video) == .denied { throw Error.cameraPermissionsNotGranted }
    }
}

// MARK: - Initialising Camera
extension CameraManager {
    func setup(in cameraView: UIView) throws {
        initialiseCaptureSession()
        initialiseCameraLayer(cameraView)
        initialiseCameraGridView(cameraView)
        initialiseDevices()
        initialiseInputs()
        initialiseOutputs()
        initializeMotionManager()
        initialiseObservers()

        try setupDeviceInputs()
        try setupDeviceOutput()
        try setupFrameRecorder()

        startCaptureSession()
        announceSetupCompletion()
    }
}
private extension CameraManager {
    func initialiseCaptureSession() {
        captureSession = .init()
    }
    func initialiseCameraLayer(_ cameraView: UIView) {
        cameraLayer = .init(session: captureSession)
        cameraLayer.videoGravity = .resizeAspectFill
        
        cameraView.layer.addSublayer(cameraLayer)
    }
    func initialiseCameraGridView(_ cameraView: UIView) {
        cameraGridView = .init()
        cameraGridView.addAsSubview(to: cameraView)
        cameraGridView.alpha = isGridVisible ? 1 : 0
    }
    func initialiseDevices() {
        frontCamera = .default(.builtInWideAngleCamera, for: .video, position: .front)
        backCamera = .default(for: .video)
        microphone = .default(for: .audio)
    }
    func initialiseInputs() {
        frontCameraInput = .init(frontCamera)
        backCameraInput = .init(backCamera)
        audioInput = .init(microphone)
    }
    func initialiseOutputs() {
        photoOutput = .init()
        videoOutput = .init()
    }
    func initializeMotionManager() {
        motionManager.accelerometerUpdateInterval = 1
        motionManager.gyroUpdateInterval = 1
        motionManager.startAccelerometerUpdates(to: OperationQueue.current ?? .init(), withHandler: handleAccelerometerUpdates)
    }
    func initialiseObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleSessionWasInterrupted), name: .AVCaptureSessionWasInterrupted, object: captureSession)
    }
    func setupDeviceInputs() throws {
        try setupCameraInput(cameraPosition)
        try setupInput(audioInput)
    }
    func setupDeviceOutput() throws {
        try setupCameraOutput(outputType)
    }
    func setupFrameRecorder() throws {
        let captureVideoOutput = AVCaptureVideoDataOutput()
        captureVideoOutput.setSampleBufferDelegate(self, queue: DispatchQueue.main)

        if captureSession.canAddOutput(captureVideoOutput) { captureSession?.addOutput(captureVideoOutput) }
    }
    func startCaptureSession() { DispatchQueue(label: "cameraSession").async { [self] in
        captureSession.startRunning()
    }}
    func announceSetupCompletion() { DispatchQueue.main.async { [self] in
        objectWillChange.send()
    }}
}
private extension CameraManager {
    func setupCameraInput(_ cameraPosition: CameraPosition) throws { switch cameraPosition {
        case .front: try setupInput(frontCameraInput)
        case .back: try setupInput(backCameraInput)
    }}
    func setupCameraOutput(_ outputType: CameraOutputType) throws { if let output = getOutput(outputType) {
        try setupOutput(output)
    }}
}
private extension CameraManager {
    func setupInput(_ input: AVCaptureDeviceInput?) throws {
        guard let input,
              captureSession.canAddInput(input)
        else { throw Error.cannotSetupInput }

        captureSession.addInput(input)
    }
    func setupOutput(_ output: AVCaptureOutput?) throws {
        guard let output,
              captureSession.canAddOutput(output)
        else { throw Error.cannotSetupOutput }

        captureSession.addOutput(output)
    }
}

// MARK: - Locking Camera Orientation
extension CameraManager {
    func lockOrientation() {
        orientationLocked = true
    }
}

// MARK: - Camera Rotation
extension CameraManager {
    func fixCameraRotation() { if !orientationLocked { let orientation = UIDevice.current.orientation
        if #available(iOS 17.0, *) { fixCameraRotationForIOS17(orientation) }
        else { fixCameraRotationForOlderIOSVersions(orientation) }
    }}
}
private extension CameraManager {
    @available(iOS 17.0, *) func fixCameraRotationForIOS17(_ deviceOrientation: UIDeviceOrientation) { let rotationAngle = calculateRotationAngle(deviceOrientation)
        if cameraLayer.connection?.isVideoRotationAngleSupported(rotationAngle) ?? false {
            cameraLayer.connection?.videoRotationAngle = rotationAngle
        }
    }
    func fixCameraRotationForOlderIOSVersions(_ deviceOrientation: UIDeviceOrientation) { let videoOrientation = calculateVideoOrientation(deviceOrientation)
        if cameraLayer.connection?.isVideoOrientationSupported ?? false {
            cameraLayer.connection?.videoOrientation = videoOrientation
        }
    }
}
private extension CameraManager {
    func calculateRotationAngle(_ deviceOrientation: UIDeviceOrientation) -> CGFloat { switch deviceOrientation {
        case .portrait: 90
        case .landscapeLeft: 0
        case .landscapeRight: 180
        case .portraitUpsideDown: 270
        default: 0
    }}
    func calculateVideoOrientation(_ deviceOrientation: UIDeviceOrientation) -> AVCaptureVideoOrientation { switch deviceOrientation {
        case .portrait: .portrait
        case .landscapeLeft: .landscapeRight
        case .landscapeRight: .landscapeLeft
        case .portraitUpsideDown: .portraitUpsideDown
        default: .portrait
    }}
}

// MARK: - Changing Output Type
extension CameraManager {
    func changeOutputType(_ newOutputType: CameraOutputType) throws { if newOutputType != outputType && !isChanging {
        captureCurrentFrameAndDelay(.outputTypeChange) { [self] in
            removeCameraOutput(outputType)
            try setupCameraOutput(newOutputType)
            updateCameraOutputType(newOutputType)

            updateTorchMode(.off)
            removeBlur()
        }
    }}
}
private extension CameraManager {
    func removeCameraOutput(_ outputType: CameraOutputType) { if let output = getOutput(outputType) {
        captureSession.removeOutput(output)
    }}
    func updateCameraOutputType(_ cameraOutputType: CameraOutputType) {
        outputType = cameraOutputType
    }
}
private extension CameraManager {
    func getOutput(_ outputType: CameraOutputType) -> AVCaptureOutput? { switch outputType {
        case .photo: photoOutput
        case .video: videoOutput
    }}
}

// MARK: - Changing Camera Position
extension CameraManager {
    func changeCamera(_ newPosition: CameraPosition) throws { if newPosition != cameraPosition && !isChanging {
        captureCurrentFrameAndDelay(.cameraPositionChange) { [self] in
            removeCameraInput(cameraPosition)
            try setupCameraInput(newPosition)
            updateCameraPosition(newPosition)
            
            updateTorchMode(.off)
            removeBlur()
        }
    }}
}
private extension CameraManager {
    func removeCameraInput(_ position: CameraPosition) { if let input = getInput(position) {
        captureSession.removeInput(input)
    }}
    func updateCameraPosition(_ position: CameraPosition) {
        cameraPosition = position
    }
}
private extension CameraManager {
    func getInput(_ position: CameraPosition) -> AVCaptureInput? { switch position {
        case .front: frontCameraInput
        case .back: backCameraInput
    }}
}

// MARK: - Camera Focusing
extension CameraManager {
    func setCameraFocus(_ touchPoint: CGPoint) throws { if let device = getDevice(cameraPosition) {
        removeCameraFocusAnimations()
        insertCameraFocus(touchPoint)

        try setCameraFocus(touchPoint, device)
    }}
}
private extension CameraManager {
    func removeCameraFocusAnimations() {
        cameraFocusView.layer.removeAllAnimations()
    }
    func insertCameraFocus(_ touchPoint: CGPoint) { DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) { [self] in
        insertNewCameraFocusView(touchPoint)
        animateCameraFocusView()
    }}
    func setCameraFocus(_ touchPoint: CGPoint, _ device: AVCaptureDevice) throws {
        let focusPoint = cameraLayer.captureDevicePointConverted(fromLayerPoint: touchPoint)
        try configureCameraFocus(focusPoint, device)
    }
}
private extension CameraManager {
    func insertNewCameraFocusView(_ touchPoint: CGPoint) {
        cameraFocusView.frame.origin.x = touchPoint.x - cameraFocusView.frame.size.width / 2
        cameraFocusView.frame.origin.y = touchPoint.y - cameraFocusView.frame.size.height / 2
        cameraFocusView.transform = .init(scaleX: 0, y: 0)
        cameraFocusView.alpha = 1

        cameraView.addSubview(cameraFocusView)
    }
    func animateCameraFocusView() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0) { [self] in cameraFocusView.transform = .init(scaleX: 1, y: 1) }
        UIView.animate(withDuration: 0.5, delay: 1.5) { [self] in cameraFocusView.alpha = 0.2 } completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 3.5) { [self] in cameraFocusView.alpha = 0 }
        }
    }
    func configureCameraFocus(_ focusPoint: CGPoint, _ device: AVCaptureDevice) throws {
        try device.lockForConfiguration()
        setFocusPointOfInterest(focusPoint, device)
        setExposurePointOfInterest(focusPoint, device)
        device.unlockForConfiguration()
    }
}
private extension CameraManager {
    func setFocusPointOfInterest(_ focusPoint: CGPoint, _ device: AVCaptureDevice) { if device.isFocusPointOfInterestSupported {
        device.focusPointOfInterest = focusPoint
        device.focusMode = .autoFocus
    }}
    func setExposurePointOfInterest(_ focusPoint: CGPoint, _ device: AVCaptureDevice) { if device.isExposurePointOfInterestSupported {
        device.exposurePointOfInterest = focusPoint
        device.exposureMode = .autoExpose
    }}
}

// MARK: - Changing Zoom Factor
extension CameraManager {
    func changeZoomFactor(_ value: CGFloat) throws { if let device = getDevice(cameraPosition), !isChanging {
        let zoomFactor = calculateZoomFactor(value, device)

        try setVideoZoomFactor(zoomFactor, device)
        updateZoomFactor(zoomFactor)
    }}
}
private extension CameraManager {
    func getDevice(_ position: CameraPosition) -> AVCaptureDevice? { switch position {
        case .front: frontCamera
        case .back: backCamera
    }}
    func calculateZoomFactor(_ value: CGFloat, _ device: AVCaptureDevice) -> CGFloat {
        min(max(value, getMinZoomLevel(device)), getMaxZoomLevel(device))
    }
    func setVideoZoomFactor(_ zoomFactor: CGFloat, _ device: AVCaptureDevice) throws  {
        try device.lockForConfiguration()
        device.videoZoomFactor = zoomFactor
        device.unlockForConfiguration()
    }
    func updateZoomFactor(_ value: CGFloat) {
        zoomFactor = value
    }
}
private extension CameraManager {
    func getMinZoomLevel(_ device: AVCaptureDevice) -> CGFloat {
        device.minAvailableVideoZoomFactor
    }
    func getMaxZoomLevel(_ device: AVCaptureDevice) -> CGFloat {
        min(device.maxAvailableVideoZoomFactor, 3)
    }
}

// MARK: - Changing Flash Mode
extension CameraManager {
    func changeFlashMode(_ mode: CameraFlashMode) throws { if let device = getDevice(cameraPosition), device.hasFlash, !isChanging {
        updateFlashMode(mode)
    }}
}
private extension CameraManager {
    func updateFlashMode(_ value: CameraFlashMode) {
        flashMode = value
    }
}

// MARK: - Changing Torch Mode
extension CameraManager {
    func changeTorchMode(_ mode: CameraTorchMode) throws { if let device = getDevice(cameraPosition), device.hasTorch, !isChanging {
        try changeTorchMode(device, mode)
        updateTorchMode(mode)
    }}
}
private extension CameraManager {
    func changeTorchMode(_ device: AVCaptureDevice, _ mode: CameraTorchMode) throws {
        try device.lockForConfiguration()
        device.torchMode = mode.get()
        device.unlockForConfiguration()
    }
    func updateTorchMode(_ value: CameraTorchMode) {
        torchMode = value
    }
}

// MARK: - Changing Mirror Mode
extension CameraManager {
    func changeMirrorMode(_ shouldMirror: Bool) { if !isChanging {
        mirrorOutput = shouldMirror
    }}
}

// MARK: - Changing Grid Mode
extension CameraManager {
    func changeGridVisibility(_ shouldShowGrid: Bool) { if !isChanging {
        animateGridVisibilityChange(shouldShowGrid)
        updateGridVisibility(shouldShowGrid)
    }}
}
private extension CameraManager {
    func animateGridVisibilityChange(_ shouldShowGrid: Bool) { UIView.animate(withDuration: 0.32) { [self] in
        cameraGridView.alpha = shouldShowGrid ? 1 : 0
    }}
    func updateGridVisibility(_ shouldShowGrid: Bool) {
        isGridVisible = shouldShowGrid
    }
}

// MARK: - Capturing Output
extension CameraManager {
    func captureOutput() { if !isChanging { switch outputType {
        case .photo: capturePhoto()
        case .video: toggleVideoRecording()
    }}}
}

// MARK: Photo
private extension CameraManager {
    func capturePhoto() {
        let settings = getPhotoOutputSettings()

        configureOutput(photoOutput)
        photoOutput?.capturePhoto(with: settings, delegate: self)
        performCaptureAnimation()
    }
}
private extension CameraManager {
    func getPhotoOutputSettings() -> AVCapturePhotoSettings {
        let settings = AVCapturePhotoSettings()
        settings.flashMode = flashMode.get()
        return settings
    }
    func performCaptureAnimation() {
        let view = createCaptureAnimationView()
        cameraView.addSubview(view)

        animateCaptureView(view)
    }
}
private extension CameraManager {
    func createCaptureAnimationView() -> UIView {
        let view = UIView()
        view.frame = cameraView.frame
        view.backgroundColor = .black
        view.alpha = 0
        return view
    }
    func animateCaptureView(_ view: UIView) {
        UIView.animate(withDuration: captureAnimationDuration) { view.alpha = 1 }
        UIView.animate(withDuration: captureAnimationDuration, delay: captureAnimationDuration) { view.alpha = 0 }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2 * captureAnimationDuration) { view.removeFromSuperview() }
    }
}
private extension CameraManager {
    var captureAnimationDuration: Double { 0.1 }
}

extension CameraManager: AVCapturePhotoCaptureDelegate {
    public func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: (any Swift.Error)?) { if let media = createPhotoMedia(photo) {
        capturedMedia = media
    }}
}
private extension CameraManager {
    func createPhotoMedia(_ photo: AVCapturePhoto) -> MCameraMedia? {
        guard let imageData = photo.fileDataRepresentation() else { return nil }
        return .init(data: imageData)
    }
}

// MARK: Video
private extension CameraManager {
    func toggleVideoRecording() { switch videoOutput?.isRecording {
        case false: startRecording()
        default: stopRecording()
    }}
}
private extension CameraManager {
    func startRecording() {
        let url = prepareUrlForVideoRecording()

        configureOutput(videoOutput)
        videoOutput?.startRecording(to: url, recordingDelegate: self)
        updateIsRecording(true)
        startRecordingTimer()
    }
    func stopRecording() {
        videoOutput?.stopRecording()
        updateIsRecording(false)
        stopRecordingTimer()
    }
}
private extension CameraManager {
    func prepareUrlForVideoRecording() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let fileUrl = paths[0].appendingPathComponent("output.mp4")

        try? FileManager.default.removeItem(at: fileUrl)
        return fileUrl
    }
    func updateIsRecording(_ value: Bool) {
        isRecording = value
    }
    func startRecordingTimer() {
        try? timer
            .publish(every: 1) { [self] in recordingTime = $0 }
            .start()
    }
    func stopRecordingTimer() {
        timer.reset()
    }
}

extension CameraManager: AVCaptureFileOutputRecordingDelegate {
    public func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: (any Swift.Error)?) {
        capturedMedia = MCameraMedia(data: outputFileURL)
    }
}

// MARK: - Handling Device Rotation
private extension CameraManager {
    func handleAccelerometerUpdates(_ data: CMAccelerometerData?, _ error: Swift.Error?) { if let data, error == nil {
        let newDeviceOrientation = fetchDeviceOrientation(data.acceleration)
        deviceOrientation = newDeviceOrientation
    }}
}
private extension CameraManager {
    func fetchDeviceOrientation(_ acceleration: CMAcceleration) -> AVCaptureVideoOrientation { switch acceleration {
        case let acceleration where acceleration.x >= 0.75: return .landscapeLeft
        case let acceleration where acceleration.x <= -0.75: return .landscapeRight
        case let acceleration where acceleration.y <= -0.75: return .portrait
        case let acceleration where acceleration.y >= 0.75: return .portraitUpsideDown
        default: return deviceOrientation
    }}
}

// MARK: - Handling Observers
private extension CameraManager {
    @objc func handleSessionWasInterrupted() {
        torchMode = .off
        updateIsRecording(false)
        stopRecordingTimer()
    }
}

// MARK: - Output Type / Camera Change Animations
extension CameraManager: AVCaptureVideoDataOutputSampleBufferDelegate {
    public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) { if lastAction != .none {
        let snapshot = createSnapshot(sampleBuffer)

        insertBlurView(snapshot)
        animateBlurFlip()
        lastAction = .none
    }}
}
private extension CameraManager {
    func createSnapshot(_ sampleBuffer: CMSampleBuffer?) -> UIImage? {
        guard let sampleBuffer,
              let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
        else { return nil }

        let ciImage = CIImage(cvPixelBuffer: imageBuffer)
        let image = UIImage(ciImage: ciImage, scale: UIScreen.main.scale, orientation: blurImageOrientation)
        return image
    }
    func insertBlurView(_ snapshot: UIImage?) { if let snapshot {
        cameraBlurView = UIImageView(image: snapshot)
        cameraBlurView.frame = cameraView.frame
        cameraBlurView.contentMode = .scaleAspectFill
        cameraBlurView.clipsToBounds = true
        cameraBlurView.applyBlurEffect(style: .regular, animationDuration: blurAnimationDuration)

        cameraView.addSubview(cameraBlurView)
    }}
    func animateBlurFlip() { if lastAction == .cameraPositionChange {
        UIView.transition(with: cameraView, duration: flipAnimationDuration, options: flipAnimationTransition) {}
    }}
    func removeBlur() { Task { @MainActor [self] in
        try await Task.sleep(nanoseconds: 100_000_000)
        UIView.animate(withDuration: blurAnimationDuration) { self.cameraBlurView.alpha = 0 }
    }}
}
private extension CameraManager {
    var blurImageOrientation: UIImage.Orientation { cameraPosition == .back ? .right : .leftMirrored }
    var blurAnimationDuration: Double { 0.3 }

    var flipAnimationDuration: Double { 0.44 }
    var flipAnimationTransition: UIView.AnimationOptions { cameraPosition == .back ? .transitionFlipFromLeft : .transitionFlipFromRight }
}
private extension CameraManager {
    enum LastAction { case cameraPositionChange, outputTypeChange, mediaCapture, none }
}

// MARK: - Modifiers
extension CameraManager {
    var hasFlash: Bool { getDevice(cameraPosition)?.hasFlash ?? false }
    var hasTorch: Bool { getDevice(cameraPosition)?.hasTorch ?? false }
}

// MARK: - Helpers
private extension CameraManager {
    func captureCurrentFrameAndDelay(_ type: LastAction, _ action: @escaping () throws -> ()) { Task { @MainActor in
        lastAction = type
        try await Task.sleep(nanoseconds: 150_000_000)

        try action()
    }}
    func configureOutput(_ output: AVCaptureOutput?) { if let connection = output?.connection(with: .video), connection.isVideoMirroringSupported {
        connection.isVideoMirrored = mirrorOutput ? cameraPosition != .front : cameraPosition == .front
        connection.videoOrientation = deviceOrientation
    }}
}
private extension CameraManager {
    var cameraView: UIView { cameraLayer.superview ?? .init() }
    var isChanging: Bool { (cameraBlurView?.alpha ?? 0) > 0 }
}


// MARK: - Errors
public extension CameraManager { enum Error: Swift.Error {
    case microphonePermissionsNotGranted, cameraPermissionsNotGranted
    case cannotSetupInput, cannotSetupOutput, capturedPhotoCannotBeFetched
}}
