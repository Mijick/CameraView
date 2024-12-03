//
//  CameraManagerMotionManager.swift of MijickCamera
//
//  Created by Tomasz Kurylik. Sending ❤️ from Kraków!
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//    - Medium: https://medium.com/@mijick
//
//  Copyright ©2024 Mijick. All rights reserved.


import CoreMotion
import AVKit

@MainActor class CameraManagerMotionManager {
    private(set) var parent: CameraManager!
    private(set) var motionManager: CMMotionManager = .init()
}

// MARK: Setup
extension CameraManagerMotionManager {
    func setup(parent: CameraManager) {
        self.parent = parent
        motionManager.accelerometerUpdateInterval = 0.05
        motionManager.startAccelerometerUpdates(to: OperationQueue.current ?? .init(), withHandler: handleAccelerometerUpdates)
    }
}
private extension CameraManagerMotionManager {
    func handleAccelerometerUpdates(_ data: CMAccelerometerData?, _ error: Error?) {
        guard let data, error == nil else { return }

        let newDeviceOrientation = fetchDeviceOrientation(data.acceleration)
        updateDeviceOrientation(newDeviceOrientation)
        updateUserBlockedScreenRotation()
        //updateFrameOrientation()
        //redrawGrid()
    }
}
private extension CameraManagerMotionManager {
    func fetchDeviceOrientation(_ acceleration: CMAcceleration) -> AVCaptureVideoOrientation { switch acceleration {
        case let acceleration where acceleration.x >= 0.75: .landscapeLeft
        case let acceleration where acceleration.x <= -0.75: .landscapeRight
        case let acceleration where acceleration.y <= -0.75: .portrait
        case let acceleration where acceleration.y >= 0.75: .portraitUpsideDown
        default: parent.attributes.deviceOrientation
    }}
    func updateDeviceOrientation(_ newDeviceOrientation: AVCaptureVideoOrientation) { if newDeviceOrientation != parent.attributes.deviceOrientation {
        parent.attributes.deviceOrientation = newDeviceOrientation
    }}
    func updateUserBlockedScreenRotation() {
        let newUserBlockedScreenRotation = getNewUserBlockedScreenRotation()
        if newUserBlockedScreenRotation != parent.attributes.userBlockedScreenRotation { parent.attributes.userBlockedScreenRotation = newUserBlockedScreenRotation }
    }
}
private extension CameraManagerMotionManager {
    func getNewUserBlockedScreenRotation() -> Bool {
        parent.attributes.deviceOrientation.rawValue == UIDevice.current.orientation.rawValue ? false : !parent.attributes.orientationLocked
    }
}
private extension CameraManagerMotionManager {

}

// MARK: Reset
extension CameraManagerMotionManager {
    func reset() {
        motionManager.stopAccelerometerUpdates()
    }
}







private extension CameraManager {

    func updateFrameOrientation() { if UIDevice.current.orientation != .portraitUpsideDown {
        let newFrameOrientation = getNewFrameOrientation(attributes.orientationLocked ? .portrait : UIDevice.current.orientation)
        updateFrameOrientation(newFrameOrientation)
    }}
    func redrawGrid() { if !attributes.orientationLocked {
        cameraGridView.draw(.zero)
    }}
}
private extension CameraManager {

    func getNewFrameOrientation(_ orientation: UIDeviceOrientation) -> CGImagePropertyOrientation { switch attributes.cameraPosition {
        case .back: getNewFrameOrientationForBackCamera(orientation)
        case .front: getNewFrameOrientationForFrontCamera(orientation)
    }}
    func updateFrameOrientation(_ newFrameOrientation: CGImagePropertyOrientation) { Task { if newFrameOrientation != attributes.frameOrientation {
        let shouldAnimate = shouldAnimateFrameOrientationChange(newFrameOrientation)

        await cameraMetalView.beginCameraOrientationAnimation(if: shouldAnimate)
        changeFrameOrientation(shouldAnimate, newFrameOrientation)
        cameraMetalView.finishCameraOrientationAnimation(if: shouldAnimate)
    }}}
}
private extension CameraManager {
    func getNewFrameOrientationForBackCamera(_ orientation: UIDeviceOrientation) -> CGImagePropertyOrientation { switch orientation {
        case .portrait: attributes.mirrorOutput ? .leftMirrored : .right
        case .landscapeLeft: attributes.mirrorOutput ? .upMirrored : .up
        case .landscapeRight: attributes.mirrorOutput ? .downMirrored : .down
        default: attributes.mirrorOutput ? .leftMirrored : .right
    }}
    func getNewFrameOrientationForFrontCamera(_ orientation: UIDeviceOrientation) -> CGImagePropertyOrientation { switch orientation {
        case .portrait: attributes.mirrorOutput ? .right : .leftMirrored
        case .landscapeLeft: attributes.mirrorOutput ? .down : .downMirrored
        case .landscapeRight: attributes.mirrorOutput ? .up : .upMirrored
        default: attributes.mirrorOutput ? .right : .leftMirrored
    }}
    func shouldAnimateFrameOrientationChange(_ newFrameOrientation: CGImagePropertyOrientation) -> Bool {
        let backCameraOrientations: [CGImagePropertyOrientation] = [.left, .right, .up, .down],
            frontCameraOrientations: [CGImagePropertyOrientation] = [.leftMirrored, .rightMirrored, .upMirrored, .downMirrored]
        return (backCameraOrientations.contains(newFrameOrientation) && backCameraOrientations.contains(attributes.frameOrientation))
        || (frontCameraOrientations.contains(attributes.frameOrientation) && frontCameraOrientations.contains(newFrameOrientation))
    }
    func changeFrameOrientation(_ shouldAnimate: Bool, _ newFrameOrientation: CGImagePropertyOrientation) {
        attributes.frameOrientation = newFrameOrientation
    }
}
