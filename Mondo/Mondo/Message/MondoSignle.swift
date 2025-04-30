//
//  MondoSignle.swift
//  Mondo
//
//  Created by 北川 on 2025/4/29.
//

import SwiftUI

// MARK: 单人聊天
struct MondoSignle: View {
    
    var chatUser: MondoerM
    
    @State var inputMes: String = ""
    
    @State var sendIsEnable: Bool = false
    
    @FocusState var isMes: Bool
    
    @State var showReport: Bool = false
    
    @State var sigleMesList: [MondoChatM] = []
    
    @EnvironmentObject var pageControl: MondoPageControl
    
    var body: some View {
        ZStack {
            Image("message_bg").resizable()
            VStack {
                HStack {
                    Button(action: {
                        pageControl.backToLevel()
                    }) { Image("guide_back") }
                    Text(chatUser.name!) // 用户名
                        .font(.custom("Futura-CondensedExtraBold", size: 20))
                        .foregroundStyle(Color.black)
                    Spacer()
                    Button(action: { // 举报
                        showReport = true
                    }) { Image("btnReport") }
                }
                
                Text("Online " + MondoCurSigleTime()) // 时间
                    .font(.custom("PingFang SC", size: 14))
                    .foregroundStyle(Color(hex: "#333333"))
                    .padding(.top, 30)
                
                /* 聊天列表 */
                ScrollViewReader { proxy in // 消息列表
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVStack (spacing: 20) {
                            ForEach(sigleMesList) { item in
                                MondoChatSideItem(groupMes: item, chatUser: chatUser)
                            }
                        }.padding(.vertical, 10)
                    }.onChange(of: sigleMesList.count) { _ in
                        scrollToBottom(proxy: proxy)
                    }
                }.frame(width: MONDOSCREEN.WIDTH - 32)
                    .padding(.top, 20)
                
                Spacer()
                HStack(spacing: 12) { // 输入框
                    MondoTextFielfItem(textInput: $inputMes,
                                       placeholder: "Say something...",
                                       interval: 15,
                                       backgroundColor: UIColor(hex: "#925EFF"),
                                       textColor: UIColor.white,
                                       placeholderColor: UIColor.white,
                                       bordColor: UIColor.clear,
                                       font: UIFont(name: "PingFangSC-Medium", size: 14)!,
                                       radius: 26)
                        .frame(width: MONDOSCREEN.WIDTH * 0.64, height: 50)
                        .clipShape(RoundedRectangle(cornerRadius: 26))
                        .focused($isMes)
                    Button(action: {
                        guard !inputMes.isEmpty else {
                            isMes = true
                            return
                        }
                        MondoSigleChatMes(mes: inputMes)
                    }) { // 发送
                        Image("btnSend")
                    }
                }.padding(.bottom, 30)
            }.padding(.horizontal, 16)
                .padding(.top, 70)
            if showReport {
                MondoReportItem(isReport: $showReport) {
                    MondoUserVM.shared.monBlockList.append(chatUser.uid!)
                    MondoUserVM.shared.MondoRemoveLike()
                    MondoUserVM.shared.MondoRemoveFollow()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        pageControl.backToLevel()
                    }
                }
            }
        }.ignoresSafeArea()
            .onAppear {
                MondoLoadChat()
            }
    }
    
    /// 聊天时间
    func MondoCurSigleTime() -> String {
        let chatDate = Date()
        let matter = DateFormatter()
        matter.dateFormat = "hh:mm"
        return matter.string(from: chatDate)
    }
    
    /// 单人发消息
    func MondoSigleChatMes(mes: String) {
        var userMes = MondoChatM()
        userMes.isForMe = true
        userMes.mesContent = mes
        userMes.mesTime = MondoCurSigleTime()
        sigleMesList.append(userMes)
        MondoRelMesVM.shared.MondoSaveMes(dialogist: "\(chatUser.uid!)", message: userMes)
        inputMes = ""
        sendIsEnable = true
        
        MondoMesService.shared.MondoChat(message: mes, sid: MondoRelMesVM.shared.MondoGenSid()) { result in
            switch result {
            case .success(let respone):
                
                if let data = respone.data {
                    if data.res != "" {
                        var signleM = MondoChatM()
                        signleM.isForMe = false
                        signleM.mesContent = data.res
                        signleM.mesTime = MondoCurSigleTime()
                        sigleMesList.append(signleM)
                        MondoRelMesVM.shared.MondoSaveMes(dialogist: "\(chatUser.uid!)", message: signleM)
                        sendIsEnable = false
                    }
                }
            case .failure(_):
                sendIsEnable = false
            }
        }
    }
    
    func scrollToBottom(proxy: ScrollViewProxy) {
        guard let lastMessage = sigleMesList.last else { return }
        withAnimation {
            proxy.scrollTo(lastMessage.id, anchor: .bottom)
        }
    }
    
    func MondoLoadChat() {
        sigleMesList = MondoRelMesVM.shared.MondoAvbMes(diaId: "\(chatUser.uid!)")
    }
}

// MARK: 单人
struct MondoChatSideItem: View {
    
    var groupMes: MondoChatM
    
    var chatUser: MondoerM
    
    @State var uploadImage: UIImage?
    
    var monMe = MondoCacheVM.MondoAvCurUser()
    
    var body: some View {
        VStack {
            if groupMes.isForMe! {
                HStack {
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
                }
            } else {
                HStack {
                    VStack(alignment: .leading) {
                        Image(chatUser.head!).resizable().scaledToFill() // 个人头像
                            .frame(width: 50, height: 50)
                            .clipShape(RoundedRectangle(cornerRadius: 25))
                        Text(groupMes.mesContent!) // 聊天内容
                            .font(.custom("PingFang SC", size: 14))
                            .foregroundStyle(Color(hex: "#111111"))
                            .padding(EdgeInsets(top: 15, leading: 20, bottom: 15, trailing: 20))
                            .background(Color(hex: "#FFF565"))
                            .clipShape(MondoRoundItem(radius: 20, corners: [.topRight, .bottomLeft, .bottomRight]))
                    }
                    Spacer()
                }
            }
        }
        .onAppear {
            uploadImage = MondoUserVM.shared.MondoAvHead(uid: monMe.uid)
        }
    }
}
