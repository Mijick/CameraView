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
@preconcurrency import AVKit



// klasa ta ma odpowiadać docelowo za wszystkie animacje związane z kamerą
@MainActor class CameraMetalView: MTKView {
    var ciContext: CIContext!

    private var parent: CameraManager!
    private var animation: Animation?
    private var currentFrame: CIImage?
    private var blurView: UIImageView!
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





extension CameraMetalView {
    var isChanging: Bool { (blurView?.alpha ?? 0) > 0 }



    func captureCurrentFrameAndDelay(_ type: CameraMetalView.Animation, _ action: @escaping () throws -> ()) { Task {
        animation = type
        await Task.sleep(seconds: 0.15)

        try action()
        removeBlur()
    }}
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



extension CameraMetalView {
    enum Animation { case blurAndFlip }
}














// MARK: - Capturing Live Frames
extension CameraMetalView: @preconcurrency AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) { switch animation {
        case nil: changeDisplayedFrame(sampleBuffer)
        default: presentCameraAnimation()
    }}
}
private extension CameraMetalView {
    func changeDisplayedFrame(_ sampleBuffer: CMSampleBuffer) { if let cvImageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) {
        let currentFrame = captureCurrentFrame(cvImageBuffer)
        let currentFrameWithFiltersApplied = applyFiltersToCurrentFrame(currentFrame)

        redrawCameraView(currentFrameWithFiltersApplied)
    }}
    func presentCameraAnimation() {
        let snapshot = createSnapshot()

        insertBlurView(snapshot)
        animateBlurFlip()
        animation = nil
    }
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
    func createSnapshot() -> UIImage? {
        guard let currentFrame else { return nil }

        let image = UIImage(ciImage: currentFrame)
        return image
    }
    func insertBlurView(_ snapshot: UIImage?) { if let snapshot {
        blurView = UIImageView(image: snapshot)
        blurView.frame = parent.cameraView.frame
        blurView.contentMode = .scaleAspectFill
        blurView.clipsToBounds = true
        blurView.applyBlurEffect(style: .regular, animationDuration: blurAnimationDuration)

        parent.cameraView.addSubview(blurView)
    }}
    func animateBlurFlip() { if animation == .blurAndFlip {
        UIView.transition(with: parent.cameraView, duration: flipAnimationDuration, options: flipAnimationTransition) {}
    }}
    func removeBlur() {
        UIView.animate(withDuration: blurAnimationDuration, delay: 0.1) { self.blurView.alpha = 0 }
    }
}
private extension CameraMetalView {
    var blurAnimationDuration: Double { 0.3 }

    var flipAnimationDuration: Double { 0.44 }
    var flipAnimationTransition: UIView.AnimationOptions { parent.attributes.cameraPosition == .back ? .transitionFlipFromLeft : .transitionFlipFromRight }
}
