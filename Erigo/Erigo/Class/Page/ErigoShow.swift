//
//  SwiftUIView.swift
//  Erigo
//
//  Created by 北川 on 2025/4/24.
//

import SwiftUI
import AVFoundation
import Kingfisher

// MARK: 展示
struct ErigoShow: View {
    
    var nowUser = ErigoUserDefaults.ErigoAvNowUser()
    
    var media: ErigoEyeTitleM
    
    @State var player: AVPlayer?
    
    @State var isPlaying = true
    
    @EnvironmentObject var router: ErigoRoute
    
    var body: some View {
        ZStack (alignment: .center) {
            if media.type == 1 { // 图片
                if media.bid! == nowUser.uerId ?? 0 {
                    let mediaUrl = URL(fileURLWithPath: media.media!)
                    KFImage(mediaUrl)
                        .resizable()
                        .frame(width: ERIGOSCREEN.WIDTH, height: ERIGOSCREEN.HEIGHT)
                        .scaledToFill()
                        .ignoresSafeArea()
                } else {
                    Image(media.cover!)
                        .resizable()
                        .scaledToFill()
                        .frame(width: ERIGOSCREEN.WIDTH, height: ERIGOSCREEN.HEIGHT)
                        .scaledToFill()
                        .ignoresSafeArea()
                }
            } else { // 视频
                VideoPlayerView(player: $player)
                .frame(width: ERIGOSCREEN.WIDTH, height: ERIGOSCREEN.HEIGHT)
                .onAppear {
                    if player == nil {
                        
                        if media.bid! == nowUser.uerId ?? 0 {
                            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                            let mediaURL = documentsURL.appendingPathComponent("Erigo_\(nowUser.uerId!)/\(media.tid! - nowUser.uerId!).mp4")
                            player = AVPlayer(url: mediaURL)
                        } else {
                            player = AVPlayer(url: URL(string: media.media!)!)
                        }
                        
                        // 添加播放状态监听
                        NotificationCenter.default.addObserver(forName: .AVPlayerItemTimeJumped,object: player?.currentItem,queue: .main) { _ in
                            ErigoProgressVM.ErigoVideoDismiss()
                        }
                    }
                    player?.play()
                    isPlaying = true
                    ErigoProgressVM.ErigoVideoLoad()
                }
                .onDisappear {
                    
                    // 移除监听
                    NotificationCenter.default.removeObserver(self,name: .AVPlayerItemTimeJumped,object: player?.currentItem)
                    
                    player?.pause()
                    player = nil
                }
                .scaledToFill()
                .ignoresSafeArea()
                .background(.black)
                
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
                }) {
                    Image("").resizable()
                        .frame(width: ERIGOSCREEN.WIDTH, height: ERIGOSCREEN.HEIGHT - 90)
                }
                    .frame(width: ERIGOSCREEN.WIDTH, height: ERIGOSCREEN.HEIGHT - 90)
                    .offset(CGSize(width: 0, height: 60))
            }
            
            HStack {
                Button(action: {
                    router.previous()
                }) {
                    Image("global_back")
                }
                .background {
                    // 添加高斯模糊效果
                    VisualEffectView(effect: UIBlurEffect(style:.systemMaterial))
                        .cornerRadius(10)
                }
                Spacer()
            }.padding(.bottom, ERIGOSCREEN.HEIGHT - 120)
                .padding(.leading, 20)
        }
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
