//
//  ErigoChatSingle.swift
//  Erigo
//
//  Created by 北川 on 2025/4/18.
//

import SwiftUI

// MARK: 单人聊天
struct ErigoChatSingle: View {
    
    @State var chatMes: String = ""
    
    var body: some View {
        ZStack {
            Image("chatSignle_bg")
                .resizable()
                .frame(width: ERIGOSCREEN.WIDTH,
                       height: ERIGOSCREEN.HEIGHT * 0.7)
            VStack {
                HStack { // 返回 & 举报
                    Button(action: {}) {
                        Image("global_back")
                    }
                    Text("") // 对话者
                        .font(.custom("Futura-CondensedExtraBold", size: 18))
                        .foregroundStyle(.white)
                    Spacer()
                    Button(action: {}) {
                        Image("btnReport")
                    }
                }.padding(.horizontal, 20)
                
                ZStack {
                    Image("user2") // 对方
                        .resizable()
                        .frame(width: 100, height: 124)
                        .offset(CGSize(width: 40, height: 0))
                    Image("user1")
                        .resizable() // 用户
                        .frame(width: 100, height: 124)
                        .offset(CGSize(width: -40, height: 0))
                }.padding(.top, 60)
                
                /* 聊天列表 */
                
                Spacer()
                
                HStack(spacing: 12) {
                    ChatInputMes(text: $chatMes,
                                 placeholder: "Say something",
                                 leftPadding: 10,
                                 textColor: UIColor(hes: "#111111", alpha: 0.3),
                                 placeholderColor: UIColor(hes: "#111111", alpha: 0.3),
                                 textFont: UIFont(name: "PingFang SC", size: 18)!)
                        .frame(height: 45)
                        .background(Color(hes: "#FCFB4E"))
                        .clipShape(RoundedRectangle(cornerRadius: 22.5))
                    Button(action: {}) {
                        Image("btnChatSend")
                    }
                }.padding(.horizontal, 10)
                .padding(.bottom, 50)
                
            }.padding(.top, 65)
        }
        .frame(width: ERIGOSCREEN.WIDTH,
               height: ERIGOSCREEN.HEIGHT)
        .ignoresSafeArea()
        .background(.black)
    }
}

#Preview {
    ErigoChatSingle()
}

// MARK: 聊天Item
struct ErigoChatItem: View {
    
    @State var sender: Bool = false
    
    var body: some View {
        if sender { // 用户
            HStack(alignment: .bottom, spacing: 12) {
                VStack(alignment: .trailing) {
                    Text("") // 聊天内容
                        .font(.custom("PingFang SC", size: 13))
                        .foregroundStyle(Color(hes: "#111111"))
                        .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                        .background(Color(hes: "#FCFB4E"))
                        .clipShape(RoundedCorner(radius: 20, corners: [.topLeft, .topRight, .bottomLeft]))
                    Text("") // 时间
                        .font(.custom("PingFang SC", size: 13))
                        .foregroundStyle(Color(hes: "#999999"))
                }
                Image("") // 头像
                    .resizable()
                    .frame(width: 36, height: 36)
                    .background(.black)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
            }.padding(.horizontal, 20)
        } else { // 对方
            HStack(alignment: .bottom, spacing: 12) {
                Image("") // 头像
                    .resizable()
                    .frame(width: 36, height: 36)
                    .background(.black)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                VStack(alignment: .leading) {
                    Text("") // 聊天内容
                        .font(.custom("PingFang SC", size: 13))
                        .foregroundStyle(Color(hes: "#111111"))
                        .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                        .background(.white)
                        .clipShape(RoundedCorner(radius: 20, corners: [.topLeft, .topRight, .bottomRight]))
                    Text("") // 时间
                        .font(.custom("PingFang SC", size: 13))
                        .foregroundStyle(Color(hes: "#999999"))
                }
            }.padding(.horizontal, 20)
        }
    }
}
