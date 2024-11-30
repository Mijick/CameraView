//
//  CameraMetalView.swift of MijickCamera
//
//  Created by Tomasz Kurylik. Sending ❤️ from Kraków!
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//    - Medium: https://medium.com/@mijick
//
//  Copyright ©2024 Mijick. All rights reserved.


import SwiftUI
import MetalKit
import AVKit

@MainActor class CameraMetalView: MTKView {
    var ciContext: CIContext!

    private(set) var parent: CameraManager!
    private(set) var currentFrame: CIImage?
    private(set) var focusIndicator: UIImageView = .init(image: .iconCrosshair, tintColor: .yellow, size: 92)
    private(set) var isAnimating: Bool = false
}

// MARK: Setup
extension CameraMetalView {
    func setup(parent: CameraManager) throws(MijickCameraError) {
        guard let metalDevice = MTLCreateSystemDefaultDevice() else { throw .cannotCreateMetalDevice }

        self.assignInitialValues(parent: parent, metalDevice: metalDevice)
        self.configureMetalView(metalDevice: metalDevice)
        self.addToParent(parent.cameraView)
    }
}
private extension CameraMetalView {
    func assignInitialValues(parent: CameraManager, metalDevice: MTLDevice) {
        self.parent = parent
        self.ciContext = CIContext(mtlDevice: metalDevice)
    }
    func configureMetalView(metalDevice: MTLDevice) {
        self.delegate = self
        self.device = metalDevice
        self.isPaused = true
        self.enableSetNeedsDisplay = false
        self.framebufferOnly = false
        self.autoResizeDrawable = false
        self.contentMode = .scaleAspectFill
        self.clipsToBounds = true
    }
}


// MARK: - ANIMATIONS



// MARK: Camera Entrance
extension CameraMetalView {
    func beginCameraEntranceAnimation() {
        parent.cameraView.alpha = 0
    }
    func finishCameraEntranceAnimation() { UIView.animate(withDuration: cameraEntranceAnimationDuration) { [self] in
        parent.cameraView.alpha = 1
    }}
}
private extension CameraMetalView {
    var cameraEntranceAnimationDuration: Double { 0.33 }
}

// MARK: Camera Focus
extension CameraMetalView {
    func performCameraFocusAnimation(touchPoint: CGPoint) {
        removeExistingFocusIndicatorAnimations()
        insertFocusIndicatorToCameraView(touchPoint: touchPoint)
        animateFocusIndicator()
    }
}
private extension CameraMetalView {
    func removeExistingFocusIndicatorAnimations() {
        focusIndicator.layer.removeAllAnimations()
    }
    func insertFocusIndicatorToCameraView(touchPoint: CGPoint) {
        focusIndicator.frame.origin.x = touchPoint.x - focusIndicator.frame.size.width / 2
        focusIndicator.frame.origin.y = touchPoint.y - focusIndicator.frame.size.height / 2
        focusIndicator.transform = .init(scaleX: 0, y: 0)
        focusIndicator.alpha = 1

        parent.cameraView.addSubview(focusIndicator)
    }
    func animateFocusIndicator() {
        UIView.animate(withDuration: self.focusIndicatorAnimationDuration, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, animations: { self.focusIndicator.transform = .init(scaleX: 1, y: 1) }) { _ in
            UIView.animate(withDuration: self.focusIndicatorAnimationDuration, delay: self.focusIndicatorAnimationDelay, animations: { self.focusIndicator.alpha = 0.2 }) { _ in
                UIView.animate(withDuration: self.focusIndicatorAnimationDuration, delay: self.focusIndicatorAnimationDelay, animations: { self.focusIndicator.alpha = 0 })
            }
        }
    }
}
private extension CameraMetalView {
    var focusIndicatorAnimationDuration: Double { 0.44 }
    var focusIndicatorAnimationDelay: Double { 1.44 }
}

// MARK: Image Capture
extension CameraMetalView {
    func performImageCaptureAnimation() {
        let blackMatte = createBlackMatte()

        parent.cameraView.addSubview(blackMatte)
        animateBlackMatte(blackMatte)
    }
}
private extension CameraMetalView {
    func createBlackMatte() -> UIView {
        let view = UIView()
        view.frame = parent.cameraView.frame
        view.backgroundColor = .black
        view.alpha = 0
        return view
    }
    func animateBlackMatte(_ view: UIView) {
        UIView.animate(withDuration: self.imageCaptureAnimationDuration, animations: { view.alpha = 1 }) { _ in
            UIView.animate(withDuration: self.imageCaptureAnimationDuration, animations: { view.alpha = 0 }) { _ in
                view.removeFromSuperview()
            }
        }
    }
}
private extension CameraMetalView {
    var imageCaptureAnimationDuration: Double { 0.13 }
}

// MARK: Camera Orientation
extension CameraMetalView {
    func beginCameraOrientationAnimation(if shouldAnimate: Bool) async { if shouldAnimate {
        parent.cameraView.alpha = 0
        await Task.sleep(seconds: cameraOrientationAnimationDelay)
    }}
    func finishCameraOrientationAnimation(if shouldAnimate: Bool) { if shouldAnimate {
        UIView.animate(withDuration: cameraOrientationAnimationDuration, delay: cameraOrientationAnimationDelay) { self.parent.cameraView.alpha = 1 }
    }}
}
private extension CameraMetalView {
    var cameraOrientationAnimationDuration: Double { 0.2 }
    var cameraOrientationAnimationDelay: Double { 0.1 }
}

// MARK: Camera Flip
extension CameraMetalView {
    func beginCameraFlipAnimation() async {
        let snapshot = createSnapshot()
        isAnimating = true
        insertBlurView(snapshot)
        animateBlurFlip()

        await Task.sleep(seconds: 0.01)
    }
    func finishCameraFlipAnimation() {
        guard let blurView = parent.cameraView.viewWithTag(2137) else { return }

        UIView.animate(withDuration: cameraFlipBlurAnimationDuration, delay: cameraFlipBlurAnimationDelay, animations: { blurView.alpha = 0 }) { [self] _ in
            blurView.removeFromSuperview()
            isAnimating = false
        }
    }
}
private extension CameraMetalView {
    func createSnapshot() -> UIImage? {
        guard let currentFrame else { return nil }

        let image = UIImage(ciImage: currentFrame)
        return image
    }
    func insertBlurView(_ snapshot: UIImage?) { if let snapshot {
        let blurView = UIImageView(image: snapshot)
        blurView.frame = parent.cameraView.frame
        blurView.contentMode = .scaleAspectFill
        blurView.clipsToBounds = true
        blurView.tag = 2137
        blurView.applyBlurEffect(style: .regular)

        parent.cameraView.addSubview(blurView)
    }}
    func animateBlurFlip() {
        UIView.transition(with: parent.cameraView, duration: cameraFlipAnimationDuration, options: cameraFlipAnimationTransition) {}
    }
}
private extension CameraMetalView {
    var cameraFlipBlurAnimationDuration: Double { 0.33 }
    var cameraFlipBlurAnimationDelay: Double { 0.16 }

    var cameraFlipAnimationDuration: Double { 0.44 }
    var cameraFlipAnimationTransition: UIView.AnimationOptions { parent.attributes.cameraPosition == .back ? .transitionFlipFromLeft : .transitionFlipFromRight }
}





extension CameraMetalView: MTKViewDelegate {
    func draw(in view: MTKView) {
        guard let commandBuffer = view.device?.makeCommandQueue()?.makeCommandBuffer(),
              let ciImage = currentFrame,
              let currentDrawable = view.currentDrawable
        else { return }

        changeDrawableSize(view, ciImage)
        renderView(view, currentDrawable, commandBuffer, ciImage)
        commitBuffer(currentDrawable, commandBuffer)
    }
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}
}
private extension CameraMetalView {
    func changeDrawableSize(_ view: MTKView, _ ciImage: CIImage) {
        view.drawableSize = ciImage.extent.size
    }
    func renderView(_ view: MTKView, _ currentDrawable: any CAMetalDrawable, _ commandBuffer: any MTLCommandBuffer, _ ciImage: CIImage) {
        ciContext.render(ciImage, to: currentDrawable.texture, commandBuffer: commandBuffer, bounds: .init(origin: .zero, size: view.drawableSize), colorSpace: CGColorSpaceCreateDeviceRGB())
    }
    func commitBuffer(_ currentDrawable: any CAMetalDrawable, _ commandBuffer: any MTLCommandBuffer) {
        commandBuffer.present(currentDrawable)
        commandBuffer.commit()
    }
}












// MARK: - Capturing Live Frames
extension CameraMetalView: @preconcurrency AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        changeDisplayedFrame(sampleBuffer)

//        switch animationStatus {
//            case .stopped, .pending: changeDisplayedFrame(sampleBuffer)
//            case .launched: presentCameraAnimation()
//        }
    }
}
private extension CameraMetalView {
    func changeDisplayedFrame(_ sampleBuffer: CMSampleBuffer) { if let cvImageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) {
        let currentFrame = captureCurrentFrame(cvImageBuffer)
        let currentFrameWithFiltersApplied = applyFiltersToCurrentFrame(currentFrame)

        redrawCameraView(currentFrameWithFiltersApplied)
    }}

}
private extension CameraMetalView {
    func captureCurrentFrame(_ cvImageBuffer: CVImageBuffer) -> CIImage {
        let currentFrame = CIImage(cvImageBuffer: cvImageBuffer)
        return currentFrame.oriented(parent.frameOrientation)
    }
    func applyFiltersToCurrentFrame(_ currentFrame: CIImage) -> CIImage {
        currentFrame.applyingFilters(parent.attributes.cameraFilters)
    }
    func redrawCameraView(_ frame: CIImage) {
        currentFrame = frame
        draw()
    }
}
