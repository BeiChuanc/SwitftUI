//
//  ErigoUserInfo.swift
//  Erigo
//
//  Created by 北川 on 2025/4/22.
//

import SwiftUI

// MARK: 个人主页
struct ErigoUserInfo: View {
    
    var userModel: ErigoEyeUserM
    
    @State var titleAndLike: [ErigoEyeTitleM] = []
    
    @EnvironmentObject var router: ErigoRoute
    
    var body: some View {
        VStack {
            ZStack {
                Image("set_bg")
                    .resizable()
                    .frame(width: ERIGOSCREEN.WIDTH, height: ERIGOSCREEN.HEIGHT * 0.18)
                HStack {
                    Button(action: { router.previous() }) {  // 返回
                        Image("global_back")
                    }
                    Spacer()
                    Text(userModel.name ?? "") // 昵称
                        .font(.custom("Futura-CondensedExtraBold", size: 18))
                        .foregroundStyle(.white)
                        .padding(.top, 10)
                    Spacer()
                    Button(action: { // 举报
                        
                    }) { Image("btnReport") }
                }
                .padding(.horizontal, 20)
            }
            
            HStack {
                VStack(alignment: .leading) {
                    Image("eye_\(userModel.uid ?? 0)") // 头像
                        .resizable()
                        .scaledToFill()
                        .frame(width: 70, height: 70)
                        .clipShape(RoundedRectangle(cornerRadius: 35))
                        .overlay(
                            RoundedRectangle(cornerRadius: 35)
                                .stroke(.black, lineWidth: 1)
                        )
                    Text(userModel.name ?? "") // 昵称
                        .font(.custom("Futura-CondensedExtraBold", size: 18))
                        .foregroundStyle(.white)
                        .padding(.top, 10)
                    Spacer()
                }
                Spacer()
                Button(action: {
                    
                }) { Image("userInfoMes") }
                    .padding(.top, 45)
            }
            .frame(height: 130)
            .padding(.horizontal, 10)
            .offset(CGSize(width: 0, height: -50))
            
            Rectangle()
                .fill(Color(hes: "#FFFFFF", alpha: 0.2))
                .frame(width: ERIGOSCREEN.WIDTH, height: 1)
                .offset(CGSize(width: 0, height: -60))
            
            HStack(spacing: ERIGOSCREEN.WIDTH * 0.4) {
                Button(action: {
                    
                }) {
                    Image("btnAlbum")
                }
                
                Button(action: {
                    
                }) {
                    Image("btnLike")
                }
            }.padding(.top, 20)
                .offset(CGSize(width: 0, height: -60))
            // 相册 & 收藏
            
            Spacer()
        }
        .frame(width: ERIGOSCREEN.WIDTH,
               height: ERIGOSCREEN.HEIGHT)
        .ignoresSafeArea()
        .background(.black)
        .onAppear {
            guard userModel.uid != nil else { return }
            titleAndLike = ErigoLoginVM.shared.ErigoGetTitle(uid: userModel.uid!)
        }
    }
}

// MARK: 媒体Item - 用户帖子数据 & 收藏帖子
struct ErigoMeidiaItem: View {
    
    var albumItems: [ErigoEyeTitleM]
    
    var isAlbum: Bool = true
    
    @State var isVisible: Bool = false
    
    var body: some View {
        ZStack {
            Image("album_bg")
                .resizable()
            VStack {
                Text(isAlbum ? "Shared likes：\(albumItems.count)" : "Total published: \(albumItems.count)")
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
