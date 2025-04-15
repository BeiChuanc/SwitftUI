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
                VideoPlayerView(player: $player)
                    .frame(width: peppyW, height: peppyH)
                    .onAppear {
                        if player == nil {
                            player = AVPlayer(url: media.mediaUrl!)
                        }
                        player?.play()
                        isPlaying = true
                    }
                    .onDisappear {
                        player?.pause()
                        player = nil
                    }
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
            
            Spacer()
            
            Image(isPlaying ? "" : "btnPlay")
                .resizable()
                .frame(width: 50, height: 50)
            
            Button(action: {
                isPlaying.toggle()
                if isPlaying {
                    player?.play()
                } else {
                    player?.pause()
                }
                print("点击了")
            }) {
                Image("").resizable()
                    .frame(width: peppyW, height: peppyH - 90)
            }.buttonStyle(InvalidButton())
                .frame(width: peppyW, height: peppyH - 90)
                .offset(CGSize(width: 0, height: 60))
            
        }.ignoresSafeArea()
            .background(.black)
    }
}

// MARK: - 视频播放器封装
struct VideoPlayerView: UIViewRepresentable {
    
    @Binding var player: AVPlayer?
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        context.coordinator.setupPlayerNotifications()
        updatePlayerLayer(in: view)
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        context.coordinator.updatePlayerNotifications()
        updatePlayerLayer(in: uiView)
    }
    
    private func updatePlayerLayer(in view: UIView) {
        view.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        guard let player = player else { return }
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = UIScreen.main.bounds
        playerLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(playerLayer)
    }
    
    // MARK: - 协调器处理播放逻辑
    class Coordinator: NSObject {
        let parent: VideoPlayerView
        private var observer: NSObjectProtocol?
        
        init(_ parent: VideoPlayerView) {
            self.parent = parent
        }
        
        func setupPlayerNotifications() {
            NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd), name: .AVPlayerItemDidPlayToEndTime, object: parent.player?.currentItem)
        }
        
        func updatePlayerNotifications() {
            NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd), name: .AVPlayerItemDidPlayToEndTime, object: parent.player?.currentItem)
        }
        
        @objc func playerItemDidReachEnd(notification: Notification) {
            parent.player?.seek(to: CMTime.zero)
            parent.player?.play()
        }
        
        deinit {
            NotificationCenter.default.removeObserver(self)
        }
    }
}
