//
//  CameraManager+PermissionsManager.swift of MijickCamera
//
//  Created by Tomasz Kurylik. Sending ❤️ from Kraków!
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//    - Medium: https://medium.com/@mijick
//
//  Copyright ©2024 Mijick. All rights reserved.


import AVKit

@MainActor class CameraManagerPermissionsManager {}

// MARK: Request Access
extension CameraManagerPermissionsManager {
    func requestAccess(parent: CameraManager) async throws(MCameraError) {
        do {
            try await getAuthorizationStatus(for: .video)
            if parent.attributes.isAudioSourceAvailable { try await getAuthorizationStatus(for: .audio) }
        }
        catch {
            parent.attributes.error = error
            throw error
        }
    }
}
private extension CameraManagerPermissionsManager {
    func getAuthorizationStatus(for mediaType: AVMediaType) async throws(MCameraError) { switch AVCaptureDevice.authorizationStatus(for: mediaType) {
        case .denied, .restricted: throw getPermissionsError(mediaType)
        case .notDetermined: try await requestAccess(for: mediaType)
        default: return
    }}
}
private extension CameraManagerPermissionsManager {
    func requestAccess(for mediaType: AVMediaType) async throws(MCameraError) {
        let isGranted = await AVCaptureDevice.requestAccess(for: mediaType)
        if !isGranted { throw getPermissionsError(mediaType) }
    }
    func getPermissionsError(_ mediaType: AVMediaType) -> MCameraError { switch mediaType {
        case .audio: .microphonePermissionsNotGranted
        case .video: .cameraPermissionsNotGranted
        default: fatalError()
    }}
}
