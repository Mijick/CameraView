//
//  CaptureDeviceInput.swift of MijickCamera
//
//  Created by Tomasz Kurylik. Sending ❤️ from Kraków!
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//    - Medium: https://medium.com/@mijick
//
//  Copyright ©2024 Mijick. All rights reserved.


import AVKit

protocol CaptureDeviceInput: NSObject {
    var device: AVCaptureDevice { get }

    //associatedtype S: CaptureDevice
    //var device: S { get }


    static func get(mediaType: AVMediaType, position: AVCaptureDevice.Position?) -> Self?
}
