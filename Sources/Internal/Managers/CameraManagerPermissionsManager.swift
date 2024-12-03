//
//  CameraManagerPermissionsManager.swift of CameraView-Demo
//
//  Created by Tomasz Kurylik. Sending ❤️ from Kraków!
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//    - Medium: https://medium.com/@mijick
//
//  Copyright ©2024 Mijick. All rights reserved.


import AVKit

class CameraManagerPermissionsManager {}

// MARK: Get Authorization Status
extension CameraManagerPermissionsManager {
    static func getAuthorizationStatus(for mediaType: AVMediaType) async throws(MijickCameraError) { switch AVCaptureDevice.authorizationStatus(for: mediaType) {
        case .denied, .restricted: throw getPermissionsError(mediaType)
        case .notDetermined: try await requestAccess(for: mediaType)
        default: return
    }}
}
private extension CameraManagerPermissionsManager {
    static func requestAccess(for mediaType: AVMediaType) async throws(MijickCameraError) {
        let isGranted = await AVCaptureDevice.requestAccess(for: mediaType)
        if !isGranted { throw getPermissionsError(mediaType) }
    }
    static func getPermissionsError(_ mediaType: AVMediaType) -> MijickCameraError { switch mediaType {
        case .audio: .microphonePermissionsNotGranted
        case .video: .cameraPermissionsNotGranted
        default: fatalError()
    }}
}
