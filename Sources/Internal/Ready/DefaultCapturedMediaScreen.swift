//
//  DefaultCapturedMediaScreen.swift of MijickCamera
//
//  Created by Tomasz Kurylik. Sending ❤️ from Kraków!
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//    - Medium: https://medium.com/@mijick
//
//  Copyright ©2024 Mijick. All rights reserved.


import SwiftUI
import AVKit

struct DefaultCapturedMediaScreen: MCapturedMediaScreen {
    let capturedMedia: MCameraMedia
    let namespace: Namespace.ID
    let retakeAction: () -> ()
    let acceptMediaAction: () -> ()
    @State private var player: AVPlayer = .init()


    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            createContentView()
            Spacer()
            createButtons()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.mijickBackgroundPrimary).ignoresSafeArea())
    }
}
private extension DefaultCapturedMediaScreen {
    @ViewBuilder func createContentView() -> some View {
        if let image = capturedMedia.getImage() { createImageView(image) }
        else if let video = capturedMedia.getVideo() { createVideoView(video) }
    }
    func createButtons() -> some View {
        HStack(spacing: 32) {
            createRetakeButton()
            createSaveButton()
        }
        .padding(.top, 12)
        .padding(.bottom, 4)
    }
}
private extension DefaultCapturedMediaScreen {
    func createImageView(_ image: UIImage) -> some View {
        Image(uiImage: image)
            .resizable()
            .matchedGeometryEffect(id: "content", in: namespace)
            .aspectRatio(contentMode: .fit)
            .ignoresSafeArea()
    }
    func createVideoView(_ video: URL) -> some View {
        VideoPlayer(player: player)
            .matchedGeometryEffect(id: "content", in: namespace)
            .onAppear { onVideoAppear(video) }
    }
    func createRetakeButton() -> some View {
        BottomButton(
            icon: .mijickIconCancel,
            iconColor: .init(.mijickBackgroundInverted),
            backgroundColor: .init(.mijickBackgroundSecondary),
            rotationAngle: .zero,
            action: retakeAction
        )
        .matchedGeometryEffect(id: "button-bottom-left", in: namespace)
    }
    func createSaveButton() -> some View {
        BottomButton(
            icon: .mijickIconCheck,
            iconColor: .init(.mijickBackgroundPrimary),
            backgroundColor: .init(.mijickBackgroundInverted),
            rotationAngle: .zero,
            action: acceptMediaAction
        )
        .matchedGeometryEffect(id: "button-bottom-right", in: namespace)
    }
}

private extension DefaultCapturedMediaScreen {
    func onVideoAppear(_ url: URL) {
        player = .init(url: url)
        player.play()
    }
}
