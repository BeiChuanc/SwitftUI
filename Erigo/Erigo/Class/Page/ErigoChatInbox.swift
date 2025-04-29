//
//  ErigoChatInbox.swift
//  Erigo
//
//  Created by 北川 on 2025/4/21.
//

import SwiftUI

// MARK: 消息列表
struct ErigoChatInbox: View {
    
    @State var isJoin: Bool = false
    
    @State var isShowGroup: Bool = true
    
    @State var groupUser: [ErigoEyeUserM] = []
    
    @State var mesLUsers: [ErigoEyeUserM] = []
    
    @State var isEmpty: Bool = false
    
    @State var isVisible: Bool = false
    
    @ObservedObject var LoginVM = ErigoLoginVM.shared
    
    @EnvironmentObject var router: ErigoRoute
    
    var body: some View {
        VStack {
            HStack {
                Button(action: { // 返回
                    router.previous()
                }) {
                    Image("global_back")
                }
                Spacer()
                Image("chatBox")
                Spacer()
                Image("mesListFlower")
            }.padding(.top, 60)
                .padding(.horizontal, 20)
            
            if isShowGroup {
                ZStack {
                    Image("groupBg")
                        .resizable()
                        .frame(width: ERIGOSCREEN.WIDTH - 40, height: 78)
                    HStack {
                        VStack(alignment: .leading, spacing: 20) {
                            Image("disCuss")
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack (alignment: .center, spacing: -12) {
                                    ForEach(groupUser) { item in
                                        Image("eye_\(item.uid!)")
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 32, height: 32)
                                            .background(.yellow)
                                            .clipShape(RoundedRectangle(cornerRadius: 16))
                                    }
                                }
                            }
                        }
                        Spacer()
                        VStack {
                            Button(action: { // 加入群聊
                                if LoginVM.landComplete {
                                    router.naviTo(to: .DISGROUP)
                                } else {
                                    router.naviTo(to: .LAND)
                                }
                            }) {
                                Text(isJoin ? "Go Chat" : "Join in")
                                    .font(.custom("PingFangSC-Regular", size: 15))
                                    .foregroundStyle(Color(hes: "#111111"))
                            }
                            .frame(width: 70, height: 30)
                            .background(Color(hes: "#F9E82C"))
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                        }
                    }.padding(.horizontal, 40)
                }
                .padding(.top, 10)
            }
            
            ZStack {
                Image("list_head")
                    .resizable()
                    .frame(width: ERIGOSCREEN.WIDTH,
                           height: isShowGroup ? ERIGOSCREEN.HEIGHT * 0.7 : ERIGOSCREEN.HEIGHT * 0.8)
                    .offset(CGSize(width: -10, height: 0))
                VStack {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 10) {
                            if isShowGroup {
                                ErigoChatBoxGroupItem()
                                    .frame(width: ERIGOSCREEN.WIDTH - 70)
                                    .onTapGesture {
                                        if LoginVM.landComplete {
                                            router.naviTo(to: .DISGROUP)
                                        } else {
                                            router.naviTo(to: .LAND)
                                        }
                                    }
                            }
                            ForEach(mesLUsers) { item in
                                ErigoChatBoxItem(userM: item)
                                    .frame(width: ERIGOSCREEN.WIDTH - 70)
                                    .onTapGesture {
                                        router.naviTo(to: .SINGLECHAT(item))
                                    }
                            }
                        }
                    }
                }.padding(.top, 120)
                
                if mesLUsers.count == 0 { // 没有数据
                    VStack {
                        Image("noAlbum")
                        Text("Not Message yet")
                            .font(.custom("PingFangSC-Medium", size: 18))
                            .foregroundStyle(Color(hes: "#FFFFFF", alpha: 0.2))
                        Button(action: { // 发布
                            router.previous()
                        }) {
                            Image("visitHome")
                        }.padding(.top, 20)
                    }
                    .opacity(isVisible ? 1 : 0)
                    .animation(.easeInOut(duration: 0.5), value: isVisible)
                }
            }.padding(.horizontal, 20)
            
            Spacer()
        }
        .frame(width: ERIGOSCREEN.WIDTH,
               height: ERIGOSCREEN.HEIGHT)
        .ignoresSafeArea()
        .background(.black)
        .onAppear {
            groupUser = ErigoLoginVM.shared.eyeUsers
            if LoginVM.landComplete {
                isJoin = ErigoUserDefaults.ErigoAvNowUser().isJoin!
                isShowGroup = !ErigoUserDefaults.ErigoAvNowUser().isReportG!
                mesLUsers = ErigoMesAndPubVM.shared.ErigoAvChatUsers()
            }
            if isShowGroup {
                isVisible = false
            } else {
                isVisible = mesLUsers.count == 0
            }
        }
    }
}

// MARK: 消息Item - 个人
struct ErigoChatBoxItem: View {
    
    var userM: ErigoEyeUserM
    
    @State var lastMes: String = ""
    
    var body: some View {
        HStack {
            Image("eye_\(userM.uid!)") // 个人头像
                .resizable()
                .scaledToFill()
                .frame(width: 48, height: 48)
                .clipShape(RoundedRectangle(cornerRadius: 24))
                .padding(.leading, 20)
            VStack(alignment: .leading) {
                Text(userM.name!) // 个人昵称
                    .font(.custom("PingFangSC-Medium", size: 15))
                    .foregroundStyle(.white)
                Text(lastMes) // 最后一条消息
                    .font(.custom("PingFangSC-Regular", size: 13))
                    .foregroundStyle(Color(hes: "#999999"))
            }
            Spacer()
        }.frame(height: 60)
        .background(.black)
        .clipShape(RoundedRectangle(cornerRadius: 5))
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color(hes: "#FF629D"), lineWidth: 2)
        )
        .onAppear {
            if let model = ErigoMesAndPubVM.shared.ErigoAvLastMes(dialogistId: "\(userM.uid!)") {
                lastMes = model.mesContent!
            }
        }
    }
}

// MARK: 消息Item - 群组
struct ErigoChatBoxGroupItem: View {
    
    @State var lastMes: String = ""
    
    var body: some View {
        HStack {
            Image("groupC") // 个人头像
                .resizable()
                .scaledToFill()
                .frame(width: 48, height: 48)
                .clipShape(RoundedRectangle(cornerRadius: 24))
                .padding(.leading, 20)
            VStack {
                Text("Discussion Group") // 个人昵称
                    .font(.custom("PingFangSC-Medium", size: 15))
                    .foregroundStyle(.white)
                Text(lastMes) // 最后一条消息
                    .font(.custom("PingFangSC-Regular", size: 13))
                    .foregroundStyle(Color(hes: "#999999"))
            }
            Spacer()
        }.frame(height: 60)
        .background(.black)
        .clipShape(RoundedRectangle(cornerRadius: 5))
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color(hes: "#FF629D"), lineWidth: 2)
        )
        .onAppear {
            if let model = ErigoMesAndPubVM.shared.ErigoAvLastMes(dialogistId: "\(8000)") {
                lastMes = model.mesContent ?? ""
            }
        }
    }
}
