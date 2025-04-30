//
//  MondoMessage.swift
//  Mondo
//
//  Created by 北川 on 2025/4/28.
//

import SwiftUI

// MARK: 消息列表
struct MondoMessage: View {
    
    @State var isChat: Bool = true
    
    @ObservedObject var monLogin = MondoUserVM.shared
    
    @EnvironmentObject var pageControl: MondoPageControl
    
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
                        isChat = true
                    }) { Image("mes_Chat").opacity(isChat ? 1 : 0.4) }
                    Button(action: { // 群组消息列表
                        isChat = false
                    }) { Image("mes_Group").opacity(isChat ? 0.4 : 1) }
                    Spacer()
                }
                ZStack { // 消息列表 - 用户 / 群组
                    if isChat {
                        ScrollView(showsIndicators: false) {
                            VStack(spacing: 30) {
                                ForEach(MondoRelMesVM.shared.MondoAvChatUsers()) { item in
                                    MondoMesUserItem(chatM: item)
                                        .frame(width: MONDOSCREEN.WIDTH - 32)
                                        .onTapGesture {
                                            pageControl.route(to: .SIDEBYSID(item))
                                        }
                                }
                            }
                            
                        }
                        if MondoRelMesVM.shared.MondoAvChatUsers().count == 0 {
                            VStack {
                                Image("noData")
                                Text("There is no news yet")
                            }.padding(.bottom, 90)
                        }
                    } else {
                        ScrollView(showsIndicators: false) {
                            VStack(spacing: 30) {
                                ForEach(MondoRelMesVM.shared.MondoAvGroup(), id: \.self) { item in
                                    MondoMesGroupItem(groupId: item) {
                                        pageControl.route(to: .SIDEGROUP(item))
                                    }
                                        .frame(width: MONDOSCREEN.WIDTH - 32)
                                }
                            }
                        }
                        if MondoRelMesVM.shared.MondoAvGroup().count == 0 {
                            VStack {
                                Image("noData")
                                Text("There is no news yet")
                            }.padding(.bottom, 90)
                        }
                    }
                }
            }.padding(.horizontal, 16)
                .padding(.top, 80)
        }.ignoresSafeArea()
    }
}

// MARK: 用户消息Item
struct MondoMesUserItem: View {
    
    var chatM: MondoerM
    
    @State var lastMes: String = ""
    
    @State var lastTime: String = ""
    
    var body: some View {
        HStack(spacing: 13) {
            Image(chatM.head!).resizable().scaledToFill() // 头像
                .frame(width: 54, height: 54)
                .background(.black)
                .clipShape(RoundedRectangle(cornerRadius: 27))
            VStack {
                HStack {
                    Text(chatM.name!) // 名字
                        .font(.custom("PingFangSC-Medium", size: 16))
                        .foregroundStyle(Color(hex: "#111111"))
                    Spacer()
                    Text(lastTime)
                        .font(.custom("PingFangSC-Regular", size: 12))
                        .foregroundStyle(Color(hex: "#111111"))
                }
                HStack {
                    Text(lastMes) // 最后一条消息
                        .lineLimit(1)
                        .font(.custom("PingFangSC-Regular", size: 12))
                        .foregroundStyle(Color(hex: "#111111"))
                        .multilineTextAlignment(.leading)
                    Spacer()
                }
            }
            Spacer()
        }
        .onAppear {
            if let model = MondoRelMesVM.shared.MondoAvLastMes(dialogistId: "\(chatM.uid!)") {
                lastMes = model.mesContent!
                lastTime = model.mesTime!
            }
        }
    }
}

// MARK: 群组消息Item
struct MondoMesGroupItem: View {
    
    var groupId: Int
    
    var enterGroup: () -> Void
    
    @State var groupName: String = ""
    
    let groupTye: MONDOGROUPC = .ONE
    
    @State var groupUser: [MondoerM] = []
    
    var body: some View {
        ZStack {
            Image("mes_groupItemBg").resizable().scaledToFill()
            VStack {
                HStack {
                    VStack {
                        Image("\(groupId)_bg").resizable().scaledToFill() // 群聊头像
                            .background(.black)
                            .frame(width: 100, height: 80)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    VStack(alignment: .leading) {
                        Text(groupName) // 标题
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
                            ForEach(groupUser) { item in
                                Image(item.head!).resizable().scaledToFill() // 用户头像
                                    .frame(width: 25, height: 25)
                                    .clipShape(RoundedRectangle(cornerRadius: 12.5))
                            }
                        }
                    }.frame(width: 100, height: 30)
                    Spacer()
                    Button(action: enterGroup) { Image("mes_groupenter") } // 进入群组聊天
                }
            }.padding(EdgeInsets(top: 20, leading: 15, bottom: 20, trailing: 15))
        }.frame(width: MONDOSCREEN.WIDTH - 32, height: 152)
            .onAppear {
                groupUser = MondoUserVM.shared.monUsers
                MondGroupData()
            }
    }
    
    
    /// 获取名字
    func MondGroupData() {
        switch groupTye {
        case .ONE: 
            groupName = "Mount Kilimanjaro, Tanzania"
            break
        case .TWO:
            groupName = "Inca Trail, Peru"
            break
        case .THREE:
            groupName = "Everest Base Camp Trek, Nepal"
            break
        case .FOUR:
            groupName = "Torres del Paine Circuit, Chile"
            break
        }
    }
}
