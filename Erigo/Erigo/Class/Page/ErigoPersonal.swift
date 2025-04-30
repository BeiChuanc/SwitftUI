//
//  ErigoPersonal.swift
//  Erigo
//
//  Created by 北川 on 2025/4/21.
//

import SwiftUI
import Kingfisher
import AVFoundation

// MARK: 个人主页
struct ErigoPersonal: View {
    
    @State var loginUser = ErigoUserM()
    
    @State var isAlbum: Bool = true
    
    @State var headImage: UIImage?
    
    @State var isVIP: Bool = false
    
    @ObservedObject var loginM = ErigoLoginVM.shared
    
    @EnvironmentObject var router: ErigoRoute
    
    var body: some View {
        VStack {
            VStack {
                ZStack {
                    Image("set_bg")
                        .resizable()
                        .frame(width: ERIGOSCREEN.WIDTH, height: ERIGOSCREEN.HEIGHT * 0.18)
                    HStack {
                        Spacer()
                        Image("per_bg")
                        Spacer()
                        Button(action: { // 设置
                            router.naviTo(to: .SETTING)
                        }) { Image("btnSetting") }
                    }
                    .padding(.horizontal, 20)
                }
            }
            
            VStack {
                
                ZStack(alignment: .topLeading) {
                    HStack {
                        if loginM.landComplete {
                            if let head = loginUser.head {
                                if head == "head_de" {
                                    Image("head_de")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 70, height: 70)
                                        .clipShape(RoundedRectangle(cornerRadius: 35))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 35)
                                                .stroke(.black, lineWidth: 1)
                                        )
                                } else {
                                    if let image = headImage {
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 64, height: 64)
                                            .clipShape(RoundedRectangle(cornerRadius: 32))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 32)
                                                    .stroke(.white, lineWidth: 1)
                                            )
                                    }
                                }
                            }
                        } else {
                            Image("head_de")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 70, height: 70)
                                .clipShape(RoundedRectangle(cornerRadius: 35))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 35)
                                        .stroke(.black, lineWidth: 1)
                                )
                        }
                        Text(loginUser.name ?? "Guest") // 昵称
                            .font(.custom("Futura-CondensedExtraBold", size: 18))
                            .foregroundStyle(.white)
                            .padding(.top, 10)
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    Image("myVIp").opacity(isVIP ? 1 : 0)
                        .padding(.leading, 28)
                        .offset(CGSize(width: 0, height: -32))
                }
                
                Button(action: { // 订阅
                    router.naviTo(to: .STORE)
                }) { Image("btnSubscribe") }
                    .offset(CGSize(width: 20, height: -10))
                
                Rectangle()
                    .fill(Color(hes: "#FFFFFF", alpha: 0.2))
                    .frame(width: ERIGOSCREEN.WIDTH, height: 1)
                
                HStack(spacing: ERIGOSCREEN.WIDTH * 0.4) {
                    Button(action: {
                        isAlbum = true
                    }) {
                        Image(isAlbum ? "btnAlbum_se" : "btnAlbum")
                            .resizable()
                            .frame(width: 28, height: 28)
                    }
                    
                    Button(action: {
                        isAlbum = false
                    }) {
                        Image(isAlbum ? "btnLike" : "btnLike_se")
                            .resizable()
                            .frame(width: 28, height: 28)
                    }
                }.padding(.top, 20)
                
                // 相册
                ErigoMeidiaMyItem(albumItems: isAlbum ? (loginUser.album ?? []) : (loginUser.likes ?? []), isAlbum: isAlbum)
                    .environmentObject(router)
                    .frame(width: ERIGOSCREEN.WIDTH - 40, height: ERIGOSCREEN.HEIGHT * 0.55)
                    .padding(.top, 20)
            }.offset(CGSize(width: 0, height: -50))
        }
        .frame(width: ERIGOSCREEN.WIDTH,
               height: ERIGOSCREEN.HEIGHT)
        .ignoresSafeArea()
        .background(.black)
        .onAppear {
            if loginM.landComplete {
                loginUser = ErigoUserDefaults.ErigoAvNowUser()
                if let uid = loginUser.uerId {
                    headImage = loginM.ErigoLoadIamge(uid: uid)
                    if let vip = ErigoUserDefaults.ErigoReadVIP(), vip {
                        isVIP = vip
                    }
                }
            }
        }
    }
}

// MARK: 媒体Item - 用户帖子数据 & 收藏帖子
struct ErigoMeidiaMyItem: View {
    
    var albumItems: [ErigoEyeTitleM]
    
    var isAlbum: Bool = true
    
    @State var isVisible: Bool = false
    
    @EnvironmentObject var router: ErigoRoute
    
    @ObservedObject var loginM = ErigoLoginVM.shared
    
    var body: some View {
        ZStack {
            Image("album_bg")
                .resizable()
            VStack {
                Text(isAlbum ? "Total published: \(albumItems.count)" : "Shared likes：\(albumItems.count)")
                    .font(.custom("PingFang SC", size: 18))
                    .foregroundStyle(Color(hes: "#FF629D"))
                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) { // 数据
                        ForEach(albumItems) { item in
                            ZStack {
                                if item.type == 1 { // 图片
                                    if item.cover == "" {
                                        let mediaUrl = URL(fileURLWithPath: item.media!)
                                        KFImage(mediaUrl)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: (ERIGOSCREEN.WIDTH - 100) / 2, height: ERIGOSCREEN.HEIGHT * 0.5 / 2)
                                            .clipped()
                                            .onTapGesture {
                                                router.naviTo(to: .POSTDETAILS(item))
                                            }
                                    } else {
                                        Image(item.cover!)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: (ERIGOSCREEN.WIDTH - 100) / 2, height: ERIGOSCREEN.HEIGHT * 0.5 / 2)
                                            .clipped()
                                            .onTapGesture {
                                                router.naviTo(to: .POSTDETAILS(item))
                                            }
                                    }
                                } else { // 视频
                                    if item.cover == "" {
                                        if let image = loginM.ErigoLoadMyCover(item: item) {
                                            ZStack {
                                                Image(uiImage: image)
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: (ERIGOSCREEN.WIDTH - 100) / 2, height: ERIGOSCREEN.HEIGHT * 0.5 / 2)
                                                    .clipped()
                                                Image("btnPlay")
                                                    .buttonStyle(ReButtonEffect())
                                            }
                                            .onTapGesture {
                                                router.naviTo(to: .POSTDETAILS(item))
                                            }
                                        }
                                    } else {
                                        Image(item.cover!)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: (ERIGOSCREEN.WIDTH - 100) / 2, height: ERIGOSCREEN.HEIGHT * 0.5 / 2)
                                            .clipped()
                                            .onTapGesture {
                                                router.naviTo(to: .POSTDETAILS(item))
                                            }
                                    }
                                }
                            }
                        }
                    }
                }
                .frame(width: ERIGOSCREEN.WIDTH - 90, height: ERIGOSCREEN.HEIGHT * 0.48)
                .padding(.horizontal, 20)
            }
            .padding(.top, 15)
            
            if albumItems.count == 0 { // 没有数据
                VStack {
                    Image("noAlbum")
                    Text(isAlbum ? "Not published yet" : "Not liked yet")
                        .font(.custom("PingFangSC-Medium", size: 18))
                        .foregroundStyle(Color(hes: "#FFFFFF", alpha: 0.2))
                    Button(action: { // 发布
                        isAlbum ? router.previousSecond() : router.previousFirst()
                    }) {
                        Image(isAlbum ? "goPublish" : "visitHome")
                    }.padding(.top, 20)
                }
                .opacity(isVisible ? 1 : 0)
                .animation(.easeInOut(duration: 0.5), value: isVisible)
            }
        }
        .onAppear {
            isVisible = albumItems.count == 0
        }
    }
}
