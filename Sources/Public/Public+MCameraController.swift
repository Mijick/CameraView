//
//  Public+MCameraController.swift of MijickCameraView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2024 Mijick. Licensed under MIT License.


import SwiftUI
import AVFoundation

public extension MCameraController {
    func outputType(_ type: CameraOutputType) -> Self { setAndReturnSelf { $0.cameraManager.change(outputType: type) } }
    func cameraPosition(_ position: AVCaptureDevice.Position) -> Self { setAndReturnSelf { $0.cameraManager.change(cameraPosition: position) } }
    func flashMode(_ flashMode: AVCaptureDevice.FlashMode) -> Self { setAndReturnSelf { $0.cameraManager.change(flashMode: flashMode) } }
    func gridVisible(_ visible: Bool) -> Self { setAndReturnSelf { $0.cameraManager.change(isGridVisible: visible) } }
    func focusImage(_ focusImage: UIImage) -> Self { setAndReturnSelf { $0.cameraManager.change(focusImage: focusImage) } }
    func focusImageColor(_ color: UIColor) -> Self { setAndReturnSelf { $0.cameraManager.change(focusImageColor: color) } }
    func focusImageSize(_ size: CGFloat) -> Self { setAndReturnSelf { $0.cameraManager.change(focusImageSize: size) } }
    func lockOrientation(_ appDelegate: MApplicationDelegate.Type) -> Self { setAndReturnSelf { $0.config.appDelegate = appDelegate; $0.cameraManager.lockOrientation() } }

    func errorScreen(_ builder: @escaping (CameraManager.Error, () -> ()) -> any MCameraErrorView) -> Self { setAndReturnSelf { $0.config.cameraErrorView = builder } }
    func mediaPreviewScreen(_ builder: ((MCameraMedia, Namespace.ID, @escaping () -> (), @escaping () -> ()) -> any MCameraPreview)?) -> Self { setAndReturnSelf { $0.config.mediaPreviewView = builder } }
    func cameraScreen(_ builder: @escaping (CameraManager, Namespace.ID, () -> ()) -> any MCameraView) -> Self { setAndReturnSelf { $0.config.cameraView = builder } }

    func onImageCaptured(_ action: @escaping (Data) -> ()) -> Self { setAndReturnSelf { $0.config.onImageCaptured = action } }
    func onVideoCaptured(_ action: @escaping (URL) -> ()) -> Self { setAndReturnSelf { $0.config.onVideoCaptured = action } }

    func afterMediaCaptured(_ action: @escaping () -> ()) -> Self { setAndReturnSelf { $0.config.afterMediaCaptured = action } }
    func onCloseController(_ action: @escaping () -> ()) -> Self { setAndReturnSelf { $0.config.onCloseController = action } }
}
