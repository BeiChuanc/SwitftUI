//
//  ErigoPersonal.swift
//  Erigo
//
//  Created by 北川 on 2025/4/21.
//

import SwiftUI
import Kingfisher

// MARK: 个人主页
struct ErigoPersonal: View {
    
    @State var loginUser = ErigoUserM()
    
    @State var isAlbum: Bool = true
    
    @State var headUrl: URL? = nil
    
    @ObservedObject var loginM = ErigoLoginVM.shared
    
    @EnvironmentObject var router: ErigoRoute
    
    var body: some View {
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
                            KFImage(headUrl)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 70, height: 70)
                                .clipShape(RoundedRectangle(cornerRadius: 35))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 35)
                                        .stroke(.black, lineWidth: 1)
                                )
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
            .offset(CGSize(width: 0, height: -50))
            
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
            
            ErigoMeidiaMyItem(albumItems: isAlbum ? (loginUser.album ?? []) : (loginUser.likes ?? []), isAlbum: isAlbum)
            
            Spacer()
        }
        .frame(width: ERIGOSCREEN.WIDTH,
               height: ERIGOSCREEN.HEIGHT)
        .ignoresSafeArea()
        .background(.black)
        .onAppear {
            if loginM.landComplete {
                loginUser = ErigoUserDefaults.ErigoAvNowUser()
                headUrl = ErigoAvHead()
            }
        }
    }
    
    func ErigoAvHead() -> URL {
        let doc = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let headPath = doc.appendingPathComponent("ErigoHead")
        return headPath
    }
}

// MARK: 媒体Item - 用户帖子数据 & 收藏帖子
struct ErigoMeidiaMyItem: View {
    
    var albumItems: [ErigoEyeTitleM]
    
    var isAlbum: Bool = true
    
    @State var isVisible: Bool = false
    
    var body: some View {
        ZStack {
            Image("album_bg")
                .resizable()
            VStack {
                Text(isAlbum ? "Total published: \(albumItems.count)" : "Shared likes：\(albumItems.count)")
                    .font(.custom("PingFang SC", size: 18))
                    .foregroundStyle(Color(hes: "#FF629D"))
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) { // 数据
                    
                }
                
                Spacer()
            }
            .padding(.top, 15)
            
            if albumItems.count == 0 { // 没有数据
                VStack {
                    Image("noAlbum")
                    Text("Not published yet")
                        .font(.custom("PingFangSC-Medium", size: 18))
                        .foregroundStyle(Color(hes: "#FFFFFF", alpha: 0.2))
                    Button(action: { // 发布
                        
                    }) {
                        Image(isAlbum ? "goPublish" : "visitHome")
                    }.padding(.top, 20)
                }
                .opacity(isVisible ? 1 : 0)
                .animation(.easeInOut(duration: 0.5), value: isVisible)
            }
            
        }.frame(width: ERIGOSCREEN.WIDTH - 40, height: ERIGOSCREEN.HEIGHT * 0.6)
            .onAppear {
                isVisible = albumItems.count == 0
            }
    }
}
