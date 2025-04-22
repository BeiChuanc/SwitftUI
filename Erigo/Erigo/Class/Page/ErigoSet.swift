//
//  ErigoSet.swift
//  Erigo
//
//  Created by 北川 on 2025/4/18.
//

import SwiftUI

struct ErigoSet: View {
    
    @State var isEditName: Bool = false
    
    @State var showP: Bool = false
    
    @State var showT: Bool = false
    
    @State var userLogOut: Bool = false
    
    @State var userDelete: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                Image("set_bg").resizable()
                    .frame(height: ERIGOSCREEN.HEIGHT * 0.18)
                VStack {
                    HStack {
                        Button(action: {}) { // 返回上一级
                            Image("global_back")
                        }
                        Image("setUp")
                        Spacer()
                    }
                    ZStack(alignment: .bottom) { // 修改头像
                        Image("")
                            .frame(width: 64, height: 64)
                            .clipShape(RoundedRectangle(cornerRadius: 32))
                            .overlay(
                                RoundedRectangle(cornerRadius: 32)
                                    .stroke(.white, lineWidth: 1)
                            )
                        Button(action: {}) {
                            Image("btnEditHead")
                                .offset(CGSize(width: 20, height: 0))
                        }
                        .foregroundStyle(.primary)
                    }
                    
                    VStack(spacing: 22) {
                        HStack { // 修改名字
                            Text("Eidt Data")
                                .font(.custom("PingFangSC-Semibold", size: 14))
                                .foregroundStyle(.white)
                            Spacer()
                            Image("back_row")
                        }
                        .onTapGesture {
                            isEditName = true
                        }
                        
                        ZStack {
                            HStack { // 隐私
                                Text("Privacy Policy")
                                    .font(.custom("PingFangSC-Semibold", size: 14))
                                    .foregroundStyle(.white)
                                Spacer()
                                Image("back_row")
                            }
                        }
                        .onTapGesture {
                            showP = true
                        }
                        .fullScreenCover(isPresented: $showP) {
                            NavigationStack {
                                WebViewContainer(url: URL(string: ERIGOLINK.POL))
                                    .frame(width: ERIGOSCREEN.WIDTH,
                                           height: ERIGOSCREEN.HEIGHT)
                                    .toolbar {
                                        ToolbarItem(placement: .topBarLeading) {
                                            Button(action: { showP = false }) {
                                                Image("web_back")
                                            }
                                        }
                                    }
                            }
                        }
                        
                        HStack { // 技术支持
                            Text("Term of service")
                                .font(.custom("PingFangSC-Semibold", size: 14))
                                .foregroundStyle(.white)
                            Spacer()
                            Image("back_row")
                        }
                        .onTapGesture {
                            showT = true
                        }
                        .fullScreenCover(isPresented: $showT) {
                            NavigationStack {
                                WebViewContainer(url: URL(string: ERIGOLINK.TER))
                                    .frame(width: ERIGOSCREEN.WIDTH,
                                           height: ERIGOSCREEN.HEIGHT)
                                    .toolbar {
                                        ToolbarItem(placement: .topBarLeading) {
                                            Button(action: { showT = false }) {
                                                Image("web_back")
                                            }
                                        }
                                    }
                            }
                        }
                        
                    }
                    .padding(.top, 20)
                    Rectangle()
                        .fill(Color(hes: "#FFFFFF", alpha: 0.2))
                        .frame(height: 1)
                        .padding(.top, 40)
                    
                    HStack {
                        Button(action: {}) {
                            Text("Delete Account")
                                .font(.custom("PingFangSC-Semibold", size: 14))
                                .foregroundStyle(.white)
                        }
                        Spacer()
                    }.padding(.top, 40)
                    
                    Spacer()
                    
                    Button(action: {}) {
                        Image("btnLogOut")
                    }.padding(.bottom, 80)
                    
                }.frame(height: ERIGOSCREEN.HEIGHT * 0.82)
                    .padding(.horizontal, 20)
                    .offset(CGSize(width: 0, height: -ERIGOSCREEN.WIDTH * 0.2))
            }.ignoresSafeArea()
                .background(.black)
            // 修改名字
            if isEditName {
                ZStack {}
                .frame(width: ERIGOSCREEN.WIDTH,
                       height: ERIGOSCREEN.HEIGHT)
                .background(.clear)
            }
        }
    }
}

#Preview {
    ErigoSet()
}
