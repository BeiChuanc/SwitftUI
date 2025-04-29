//
//  MondoMessage.swift
//  Mondo
//
//  Created by 北川 on 2025/4/28.
//

import SwiftUI

// MARK: 消息列表
struct MondoMessage: View {
    
    @State var userMesList = []
    
    @State var groupMesList = []
    
    @State var isChat: Bool = true
    
    @State var isEmpty: Bool = false
    
    var body: some View {
        ZStack(alignment: .top) {
            Image("mes_bg").resizable()
            VStack(spacing: 30) {
                HStack {
                    Image("mesTitle")
                    Spacer()
                }
                HStack(spacing: 30) {
                    Button(action: { // 用户消息列表
                        isChat.toggle()
                    }) { Image("mes_Chat").opacity(isChat ? 1 : 0.4) }
                    Button(action: { // 群组消息列表
                        isChat.toggle()
                    }) { Image("mes_Group").opacity(isChat ? 0.4 : 1) }
                    Spacer()
                }
                ZStack { // 消息列表 - 用户 / 群组
                    ScrollView(showsIndicators: false) {
                        
                    }
                    if isEmpty {
                        VStack {
                            Image("noData")
                            Text("There is no news yet")
                        }.padding(.bottom, 90)
                    }
                }
            }.padding(.horizontal, 16)
                .padding(.top, 80)
        }.ignoresSafeArea()
    }
}

#Preview {
    MondoMessage()
}

// MARK: 用户消息Item
struct MondoMesUserItem: View {
    var body: some View {
        HStack(spacing: 13) {
            Image("").resizable().scaledToFill() // 头像
                .frame(width: 54, height: 54)
                .background(.black)
                .clipShape(RoundedRectangle(cornerRadius: 27))
            VStack {
                HStack {
                    Text("Jack") // 名字
                        .font(.custom("PingFangSC-Medium", size: 16))
                        .foregroundStyle(Color(hex: "#111111"))
                    Spacer()
                    Text("12:37")
                        .font(.custom("PingFangSC-Regular", size: 12))
                        .foregroundStyle(Color(hex: "#111111"))
                }
                HStack {
                    Text("Do you equip too much before each departure?") // 最后一条消息
                        .lineLimit(1)
                        .font(.custom("PingFangSC-Regular", size: 12))
                        .foregroundStyle(Color(hex: "#111111"))
                        .multilineTextAlignment(.leading)
                    Spacer()
                }
            }
            Spacer()
        }
    }
}

// MARK: 群组消息Item
struct MondoMesGroupItem: View {
    var body: some View {
        ZStack {
            Image("mes_groupItemBg").resizable().scaledToFill()
            VStack {
                HStack {
                    VStack {
                        Image("").resizable().scaledToFill() // 群聊头像
                            .background(.black)
                            .frame(width: 100, height: 80)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    VStack(alignment: .leading) {
                        Text("") // 标题
                            .lineLimit(1)
                            .font(.custom("Futura-CondensedExtraBold", size: 16))
                            .foregroundStyle(Color(hex: "#111111"))
                        Text("") // 内容
                            .lineLimit(1)
                            .font(.custom("PingFangSC-Medium", size: 12))
                            .foregroundStyle(Color(hex: "#111111"))
                    }
                    Spacer()
                }
                Spacer()
                HStack {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: -12) {
                            ForEach(0..<5) { index in
                                Image("").resizable().scaledToFill() // 用户头像
                                    .frame(width: 25, height: 25)
                                    .clipShape(RoundedRectangle(cornerRadius: 12.5))
                            }
                        }
                    }.frame(width: 100, height: 30)
                    Spacer()
                    Button(action: { // 加入群组聊天
                        
                    }) { Image("mes_groupenter") }
                }
            }.padding(EdgeInsets(top: 20, leading: 15, bottom: 20, trailing: 15))
        }.frame(width: MONDOSCREEN.WIDTH - 32, height: 152)
    }
}
