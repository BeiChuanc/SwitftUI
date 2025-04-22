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
            
            ZStack {
                Image("groupBg")
                    .resizable()
                    .frame(width: ERIGOSCREEN.WIDTH - 40, height: 78)
                HStack {
                    VStack(alignment: .leading, spacing: 20) {
                        Image("disCuss")
                        HStack (spacing: -12) {
                            ForEach(0..<4) { item in
                                HStack { // 群组头像
                                    Image("")
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                        .background(.yellow)
                                        .clipShape(RoundedRectangle(cornerRadius: 35))
                                }.frame(height: 12)
                            }
                        }
                    }
                    Spacer()
                    VStack {
                        Button(action: { // 加入群聊
                            
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
            
            ZStack {
                Image("list_head")
                    .resizable()
                    .frame(width: ERIGOSCREEN.WIDTH, height: ERIGOSCREEN.HEIGHT * 0.7)
                    .offset(CGSize(width: -10, height: 0))
                VStack {
                    // 消息列表: 一页6个可滑动翻页
                }
                .padding(.top, 80)
            }.padding(.horizontal, 20)
            
            Spacer()
        }
        .frame(width: ERIGOSCREEN.WIDTH,
                height: ERIGOSCREEN.HEIGHT)
         .ignoresSafeArea()
         .background(.black)
    }
}

#Preview {
    ErigoChatInbox()
}

// MARK: 消息Item
struct ErigoChatBoxItem: View {
    var body: some View {
        HStack {
            Image("") // 群组(随机组合) / 个人头像
                .resizable()
                .frame(width: 50, height: 50)
                .clipShape(RoundedRectangle(cornerRadius: 25))
            VStack {
                Text("") // 群组 / 个人
                    .font(.custom("PingFangSC-Regular", size: 15))
                    .foregroundStyle(.white)
                Text("") // 最后一条消息
                    .font(.custom("PingFangSC-Regular", size: 13))
                    .foregroundStyle(Color(hes: "#999999"))
            }
        }
        .frame(width: ERIGOSCREEN.WIDTH * 0.7, height: 60)
        .background(.black)
        .clipShape(RoundedRectangle(cornerRadius: 5))
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color(hes: "#FF629D"), lineWidth: 2)
        )
    }
}
