//
//  MondoGroup.swift
//  Mondo
//
//  Created by 北川 on 2025/4/29.
//

import SwiftUI

// MARK: 群组聊天
struct MondoGroup: View {
    
    var groupId: Int
    
    @State var inputMes: String = ""
    
    @State var isExit: Bool = false
    
    @FocusState var isMes: Bool
    
    @State var groupMes: [MondoChatM] = []
    
    var monMe = MondoCacheVM.MondoAvCurUser()
    
    @EnvironmentObject var pageControl: MondoPageControl
    
    var body: some View {
        ZStack {
            Image("message_bg").resizable()
            VStack {
                HStack {
                    Button(action: {
                        pageControl.backToLevel()
                    }) { Image("guide_back") }
                    Text("dsdad") // 用户名
                        .font(.custom("Futura-CondensedExtraBold", size: 20))
                        .foregroundStyle(Color.black)
                    Spacer()
                    Button(action: { // 退出群聊 >> 清除数据
                        isExit = true
                    }) { Image("btnClose") }
                        .alert(isPresented: $isExit) {
                            Alert(
                                title: Text("Promot"),
                                message: Text("Are you sure you want to exit the group chat? This will clear the group chat messages."),
                                primaryButton: .default(Text("Exit")) { // 清除记录
                                    pageControl.backToLevel()
                                },
                                secondaryButton: .cancel(Text("Cancel"))
                            )
                        }
                }
                
                Text(MondoCurGroupTime())
                    .font(.custom("PingFang SC", size: 14))
                    .foregroundStyle(Color(hex: "#333333"))
                
                /* 聊天列表 */
                ScrollViewReader { proxy in // 消息列表
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVStack (spacing: 20) {
                            ForEach(groupMes) { item in
                                MondoChatGroupItem(groupMes: item)
                            }
                        }.padding(.vertical, 10)
                    }.onChange(of: groupMes.count) { _ in
                        scrollToBottom(proxy: proxy)
                    }
                }.padding(.horizontal, 20)
                
                Spacer()
                
                HStack(spacing: 12) { // 输入框
                    MondoTextFielfItem(textInput: $inputMes,
                                       placeholder: "Say something...",
                                       interval: 15,
                                       backgroundColor: UIColor(hex: "#925EFF"),
                                       textColor: UIColor.white,
                                       placeholderColor: UIColor.white,
                                       bordColor: UIColor(hex: "#925EFF"),
                                       font: UIFont(name: "PingFangSC-Medium", size: 14)!,
                                       radius: 26)
                    .frame(width: MONDOSCREEN.WIDTH * 0.64, height: 52)
                    .focused($isMes)
                    Button(action: {
                        guard !inputMes.isEmpty else {
                            isMes = true
                            return
                        }
                        MondoGroupSendMes(mes: inputMes)
                    }) { // 发送
                        Image("btnSend")
                    }
                }
                    .padding(.bottom, 50)
            }.padding(.horizontal, 16)
                .padding(.top, 70)
        }.ignoresSafeArea()
            .onAppear {
                groupMes = MondoRelMesVM.shared.MondoAvbMes(diaId: "\(monMe.uid)\(groupId)")
            }
    }
    
    /// 聊天时间
    func MondoCurGroupTime() -> String {
        let chatDate = Date()
        let matter = DateFormatter()
        matter.dateFormat = "hh:mm"
        return matter.string(from: chatDate)
    }
    
    /// 群组发消息
    func MondoGroupSendMes(mes: String) {
        var userMes = MondoChatM()
        userMes.isForMe = true
        userMes.mesContent = mes
        userMes.mesTime = MondoCurGroupTime()
        groupMes.append(userMes)
        MondoRelMesVM.shared.MondoSaveMes(dialogist: "\(monMe.uid)\(groupId)", message: userMes)
        inputMes = ""
    }
    
    func scrollToBottom(proxy: ScrollViewProxy) {
        guard let lastMessage = groupMes.last else { return }
        withAnimation {
            proxy.scrollTo(lastMessage.id, anchor: .bottom)
        }
    }
}

// MARK: 聊天Item - 群组
struct MondoChatGroupItem: View {
    
    var groupMes: MondoChatM
    
    @State var uploadImage: UIImage?
    
    var monMe = MondoCacheVM.MondoAvCurUser()
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 12) {
            Spacer()
            VStack(alignment: .trailing) {
                if monMe.head == "monder" {
                    Image("monder").resizable().scaledToFill() // 个人头像
                        .frame(width: 50, height: 50)
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                } else {
                    if let image = uploadImage {
                        Image(uiImage: image).resizable().scaledToFill() // 个人头像
                            .frame(width: 50, height: 50)
                            .clipShape(RoundedRectangle(cornerRadius: 25))
                    }
                }
                Text(groupMes.mesContent!) // 聊天内容
                    .font(.custom("PingFang SC", size: 14))
                    .foregroundStyle(Color(hex: "#FFFFFF"))
                    .padding(EdgeInsets(top: 15, leading: 20, bottom: 15, trailing: 20))
                    .background(Color(hex: "#925EFF"))
                    .clipShape(MondoRoundItem(radius: 20, corners: [.topLeft, .bottomLeft, .bottomRight]))
            }
            
        }.padding(.horizontal, 20)
            .onAppear {
                uploadImage = MondoUserVM.shared.MondoAvHead(uid: monMe.uid)
            }
    }
}
