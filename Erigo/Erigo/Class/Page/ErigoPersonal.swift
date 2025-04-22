//
//  ErigoPersonal.swift
//  Erigo
//
//  Created by 北川 on 2025/4/21.
//

import SwiftUI

// MARK: 个人主页
struct ErigoPersonal: View {
    
    @State var albumCount: Int = 1
    
    @State var loginUser = ErigoUserM()
    
    @State var isVisible: Bool = false
    
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
                        
                    }) { Image("btnSetting") }
                }
                .padding(.horizontal, 20)
            }
            
            HStack {
                Image("") // 头像
                    .resizable()
                    .frame(width: 70, height: 70)
                    .clipShape(RoundedRectangle(cornerRadius: 35))
                    .overlay(
                        RoundedRectangle(cornerRadius: 35)
                            .stroke(.black, lineWidth: 1)
                    )
                Text("") // 昵称
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
                    
                }) {
                    Image("btnAlbum")
                }
                
                Button(action: {
                    
                }) {
                    Image("btnLike")
                }
            }.padding(.top, 20)
            
            ZStack {
                Image("album_bg")
                    .resizable()
                VStack {
                    Text("Total published: \(albumCount)")
                        .font(.custom("PingFang SC", size: 18))
                        .foregroundStyle(Color(hes: "#FF629D"))
                    // 相册数据
                    Spacer()
                }
                .padding(.top, 15)
                
                if albumCount == 0 {
                    VStack {
                        Image("noAlbum")
                        Text("Not published yet")
                            .font(.custom("PingFangSC-Medium", size: 18))
                            .foregroundStyle(Color(hes: "#FFFFFF", alpha: 0.2))
                        Button(action: { // 发布
                            
                        }) {
                            Image("goPublish")
                        }.padding(.top, 20)
                    }
                    .opacity(isVisible ? 1 : 0)
                    .animation(.easeInOut(duration: 0.5), value: isVisible)
                }
                
            }.frame(width: ERIGOSCREEN.WIDTH - 40, height: ERIGOSCREEN.HEIGHT * 0.6)
            
            Spacer()
        }
        .frame(width: ERIGOSCREEN.WIDTH,
               height: ERIGOSCREEN.HEIGHT)
        .ignoresSafeArea()
        .background(.black)
        .onAppear {
            isVisible = true
            loginUser = ErigoUserDefaults.ErigoAvNowUser()
        }
    }
}
