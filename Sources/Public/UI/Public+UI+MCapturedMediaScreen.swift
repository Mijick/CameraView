//
//  Public+UI+MCapturedMediaScreen.swift of MijickCamera
//
//  Created by Tomasz Kurylik. Sending ❤️ from Kraków!
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//    - Medium: https://medium.com/@mijick
//
//  Copyright ©2024 Mijick. All rights reserved.


import SwiftUI

/**
 Screen that displays the captured media.

 - important: A view conforming to **MCapturedMediaScreen** has to be passed directly to ``MCamera``. See ``MCamera/setCapturedMediaScreen(_:)`` for more details.


 ## Usage
 ```swift
 struct CustomCapturedMediaScreen: MCapturedMediaScreen {
    let capturedMedia: MCameraMedia
    let namespace: Namespace.ID
    let retakeAction: () -> ()
    let acceptMediaAction: () -> ()


    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            createContentView()
            Spacer()
            createButtons()
        }
    }
 }
 private extension CustomCapturedMediaScreen {
    func createContentView() -> some View { ZStack {
        if let image = capturedMedia.getImage() { createImageView(image) }
        else { EmptyView() }
    }}
    func createButtons() -> some View {
        HStack(spacing: 24) {
            createRetakeButton()
            createSaveButton()
        }
    }
 }
 private extension CustomCapturedMediaScreen {
    func createImageView(_ image: UIImage) -> some View {
        Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .ignoresSafeArea()
    }
    func createRetakeButton() -> some View {
        Button(action: retakeAction) { Text("Retake") }
    }
    func createSaveButton() -> some View {
        Button(action: acceptMediaAction) { Text("Save") }
    }
 }
 ```
 */
public protocol MCapturedMediaScreen: View {
    var capturedMedia: MCameraMedia { get }
    var namespace: Namespace.ID { get }
    var retakeAction: () -> () { get }
    var acceptMediaAction: () -> () { get }
}
