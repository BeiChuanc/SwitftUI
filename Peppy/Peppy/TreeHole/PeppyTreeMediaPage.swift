//
//  PeppyTreeMediaPage.swift
//  Peppy
//
//  Created by 北川 on 2025/4/11.
//

import SwiftUI
import AVFoundation
import Kingfisher

// MARK: 媒体播放
struct PeppyTreeMediaPage: View {
    
    var media: PeppyMyMedia
    
    @State var player: AVPlayer?
    
    @State var isPlaying = true
    
    @State var videoPlayer: VideoPlayerView?
    
    @EnvironmentObject var peppyRouter: PeppyRouteManager
    
    var body: some View {
        ZStack (alignment: .center) {
            if media.mediaType == .PITURE { // 图片
                KFImage(media.mediaUrl!)
                    .resizable()
                    .frame(width: peppyW, height: peppyH)
                    .scaledToFill()
                    .ignoresSafeArea()
            } else { // 视频
                VideoPlayerView(player: AVPlayer(url: media.mediaUrl!))
                    .frame(width: peppyW, height: peppyH)
                    .onAppear { player?.play() }
                    .onDisappear { player?.pause() }
                    .scaledToFill()
                    .ignoresSafeArea()
            }
            
            VStack {
                HStack {
                    Button(action: {
                        withAnimation(.bouncy) {
                            peppyRouter.pop()
                        }
                    }) {
                        Image("btnBac").frame(width: 24, height: 24)
                    }
                    Spacer()
                }.frame(width: peppyW - 40, height: 25)
                    .padding(.top, 64)
                
                Spacer()
                
                Text(media.mediaContent!)
                    .frame(maxWidth: peppyW - 40)
                    .fixedSize(horizontal: false, vertical: true)
                    .font(.custom("PingFang SC", size: 12))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
            ZStack {
                Button(action: {
                    print("播放被点击")
                }) {
                    Image(isPlaying ? "" : "btnPlay")
                        .frame(width: peppyW, height: peppyW - 64)
                        .foregroundColor(.white)
                }.buttonStyle(InvalidButton())
            }.frame(width: peppyW, height: peppyW - 64)
        }.ignoresSafeArea()
            .background(.black)
    }
}

// MARK: - 视频播放器封装
struct VideoPlayerView: UIViewRepresentable {
    
    let player: AVPlayer
    
    func makeUIView(context: Context) -> some UIView {
        let playerLayerView = UIView()
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = UIScreen.main.bounds
        playerLayer.videoGravity = .resizeAspectFill
        playerLayerView.layer.addSublayer(playerLayer)
        player.play()
        return playerLayerView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {}
}
