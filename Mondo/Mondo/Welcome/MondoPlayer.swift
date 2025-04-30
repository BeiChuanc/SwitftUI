//
//  MondoPlayer.swift
//  Mondo
//
//  Created by 北川 on 2025/4/29.
//

import SwiftUI
import AVFoundation
import _AVKit_SwiftUI
import Kingfisher

// MARK: 视频播放
struct MondoPlayer: View {
    
    var url: String
    
    var type: Int
    
    var vId: Int
    
    var isFromMe: Bool
    
    @State var isPlaying = false
    
    var monMe = MondoCacheVM.MondoAvCurUser()
    
    @EnvironmentObject var pageControl: MondoPageControl
    
    var body: some View {
        if isFromMe {
            ZStack(alignment: .top) {
                if type == 0 {
                    let mediaUrl = URL(fileURLWithPath: url)
                    KFImage(mediaUrl)
                        .resizable()
                        .scaledToFill()
                        .frame(width: MONDOSCREEN.WIDTH, height: MONDOSCREEN.HEIGHT)
                        .scaledToFill()
                        .ignoresSafeArea()
                } else {
                    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                    let mediaURL = documentsURL.appendingPathComponent("Mondo_\(monMe.uid)/\(url.components(separatedBy: "/").last!)")
                    MondoPlayerVC(url: mediaURL, isPlaying: $isPlaying)
                        .frame(width: MONDOSCREEN.WIDTH, height: MONDOSCREEN.HEIGHT)
                    Button(action: {
                        isPlaying.toggle()
                    }) {
                        if isPlaying {
                            Image(systemName: "")
                                .frame(width: MONDOSCREEN.WIDTH, height: MONDOSCREEN.HEIGHT)
                        } else {
                            Image("btnPlay")
                                .frame(width: MONDOSCREEN.WIDTH, height: MONDOSCREEN.HEIGHT)
                        }
                    }
                }
                HStack {
                    Button(action: { // 返回
                        pageControl.backToLevel()
                    }) { Image("titleBack") }
                    Spacer()
                }.padding(.top, 70)
                    .padding(.horizontal, 16)
            }
        } else {
            ZStack(alignment: .top) {
                if type == 0 {
                    Image(url).resizable().scaledToFill().ignoresSafeArea()
                        .frame(width: MONDOSCREEN.WIDTH, height: MONDOSCREEN.HEIGHT)
                } else {
                    MondoPlayerVC(url: URL(string: url)!, isPlaying: $isPlaying)
                        .frame(width: MONDOSCREEN.WIDTH, height: MONDOSCREEN.HEIGHT)
                    Button(action: {
                        isPlaying.toggle()
                    }) {
                        if isPlaying {
                            Image(systemName: "")
                                .frame(width: MONDOSCREEN.WIDTH, height: MONDOSCREEN.HEIGHT)
                        } else {
                            Image("btnPlay")
                                .frame(width: MONDOSCREEN.WIDTH, height: MONDOSCREEN.HEIGHT)
                        }
                    }
                }
                HStack {
                    Button(action: { // 返回
                        pageControl.backToLevel()
                    }) { Image("titleBack") }
                    Spacer()
                }.padding(.top, 70)
                    .padding(.horizontal, 16)
            }.ignoresSafeArea()
        }
    }
}

struct MondoPlayerVC: UIViewControllerRepresentable {
    
    let url: URL
    
    @Binding var isPlaying: Bool
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let player = AVPlayer(url: url)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        playerViewController.videoGravity = .resizeAspectFill
        playerViewController.showsPlaybackControls = false
        
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: .main) { _ in
            self.isPlaying = false
            player.seek(to: .zero)
        }
        
        return playerViewController
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        if isPlaying {
            uiViewController.player?.play()
        } else {
            uiViewController.player?.pause()
        }
    }
}
