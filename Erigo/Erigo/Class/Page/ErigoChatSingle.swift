//
//  ErigoChatSingle.swift
//  Erigo
//
//  Created by 北川 on 2025/4/18.
//

import SwiftUI

// MARK: 单人聊天
struct ErigoChatSingle: View {
    
    var chatUser: ErigoEyeUserM
    
    @State var sendIsEnable: Bool = false
    
    @State var headImage: UIImage?
    
    @State var chatMes: String = ""
    
    @FocusState var isMes: Bool
    
    @State var signleMes: [ErigoChatM] = []
    
    @EnvironmentObject var router: ErigoRoute
    
    var body: some View {
        ZStack {
            Image("chatSignle_bg")
                .resizable()
                .frame(width: ERIGOSCREEN.WIDTH,
                       height: ERIGOSCREEN.HEIGHT * 0.7)
            VStack {
                HStack { // 返回 & 举报
                    Button(action: { router.previous() }) {
                        Image("global_back")
                    }
                    Text(chatUser.name ?? "") // 对话者
                        .font(.custom("Futura-CondensedExtraBold", size: 18))
                        .foregroundStyle(.white)
                    Spacer()
                    Button(action: {
                        ErigoMesAndPubVM.ErigoShowReport {
                            ErigoLoginVM.shared.eyeBlockList.append(chatUser.uid ?? 0)
                            ErigoMesAndPubVM.shared.ErigoDelAvMes(uid: chatUser.uid ?? 0)
                            ErigoLoginVM.shared.ErigoRemoveLike()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                router.previous()
                            }
                        }
                    }) { // 举报
                        Image("btnReport")
                    }
                }.padding(.horizontal, 20)
                
                HStack(spacing: 20) {
                    Image("eye_\(chatUser.uid ?? 0)") // 对方
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 140)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.white, lineWidth: 2)
                        )
                        .rotationEffect(Angle(degrees: -15))
                    if let head = ErigoUserDefaults.ErigoAvNowUser().head {
                        if head == "head_de" {
                            Image("head_de").resizable().scaledToFill().frame(width: 100, height: 140)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(.white, lineWidth: 2)
                                )
                                .rotationEffect(Angle(degrees: 15))
                        } else {
                            if let image = headImage {
                                Image(uiImage: image).resizable().scaledToFill().frame(width: 100, height: 140)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(.white, lineWidth: 2)
                                    )
                                    .rotationEffect(Angle(degrees: 15))
                            }
                        }
                        
                    } else {
                        Image("head_de").resizable().scaledToFill().frame(width: 100, height: 140)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.white, lineWidth: 2)
                            )
                            .rotationEffect(Angle(degrees: 15))
                    }
                }.padding(.top, 60)
                
                /* 聊天列表 */
                ScrollViewReader { proxy in // 消息列表
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVStack (spacing: 20) {
                            ForEach(signleMes) { item in
                                ErigoChatItem(sigleModl: item, diaUser: chatUser)
                            }
                        }.padding(.vertical, 10)
                    }.onChange(of: signleMes.count) { _ in
                        scrollToBottom(proxy: proxy)
                    }
                }.padding(.horizontal, 20)
                
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
                        .focused($isMes)
                    Button(action: {
                        guard !chatMes.isEmpty else {
                            isMes = true
                            return
                        }
                        ErigoSigleChatMes(mes: chatMes)
                    }) { // 发送
                        Image("btnChatSend")
                    }.disabled(sendIsEnable)
                }.padding(.horizontal, 10)
                .padding(.bottom, 50)
                
            }.padding(.top, 65)
        }
        .frame(width: ERIGOSCREEN.WIDTH,
               height: ERIGOSCREEN.HEIGHT)
        .ignoresSafeArea()
        .background(.black)
        .onAppear {
            if let uid = ErigoUserDefaults.ErigoAvNowUser().uerId {
                headImage = ErigoLoginVM.shared.ErigoLoadIamge(uid: uid)
            }
            ErigoLoadChat()
        }
    }
    
    /// 聊天时间
    func ErigoCurChatTime() -> String {
        let chatDate = Date()
        let matter = DateFormatter()
        matter.dateFormat = "hh:mm"
        return matter.string(from: chatDate)
    }
    
    /// 单人发消息
    func ErigoSigleChatMes(mes: String) {
        var userMes = ErigoChatM()
        userMes.isForMe = true
        userMes.mesContent = mes
        userMes.mesTime = ErigoCurChatTime()
        signleMes.append(userMes)
        ErigoMesAndPubVM.shared.ErigoSaveMes(dialogist: "\(chatUser.uid!)", message: userMes)
        chatMes = ""
        sendIsEnable = true
        
        ErigoMesService.shared.ErigoChat(message: mes, sid: ErigoMesAndPubVM.shared.ErigoGenSid()) { result in
            switch result {
            case .success(let respone):
                
                if let data = respone.data {
                    if data.res != "" {
                        var signleM = ErigoChatM()
                        signleM.isForMe = false
                        signleM.mesContent = data.res
                        signleM.mesTime = ErigoCurChatTime()
                        signleMes.append(signleM)
                        ErigoMesAndPubVM.shared.ErigoSaveMes(dialogist: "\(chatUser.uid!)", message: signleM)
                        sendIsEnable = false
                    }
                }
            case .failure(_):
                sendIsEnable = false
            }
        }
    }
    
    func scrollToBottom(proxy: ScrollViewProxy) {
        guard let lastMessage = signleMes.last else { return }
        withAnimation {
            proxy.scrollTo(lastMessage.id, anchor: .bottom)
        }
    }
    
    func ErigoLoadChat() {
        signleMes = ErigoMesAndPubVM.shared.ErigoAvbMes(diaId: "\(chatUser.uid!)")
    }
}

// MARK: 聊天Item - 单人
struct ErigoChatItem: View {
    
    var sigleModl: ErigoChatM
    
    var diaUser: ErigoEyeUserM
    
    var nowUser = ErigoUserDefaults.ErigoAvNowUser()
    
    @State var headImage: UIImage?
    
    var body: some View {
        if sigleModl.isForMe! { // 用户
            HStack(alignment: .bottom, spacing: 12) {
                Spacer()
                VStack(alignment: .trailing) {
                    Text(sigleModl.mesContent!) // 聊天内容
                        .font(.custom("PingFang SC", size: 13))
                        .foregroundStyle(Color(hes: "#111111"))
                        .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                        .background(Color(hes: "#FCFB4E"))
                        .clipShape(RoundedCorner(radius: 20, corners: [.topLeft, .topRight, .bottomLeft]))
                    Text("\(sigleModl.mesTime!) \(nowUser.name!)") // 时间
                        .font(.custom("PingFang SC", size: 13))
                        .foregroundStyle(Color(hes: "#999999"))
                }
                if let head = nowUser.head {
                    if head == "head_de" {
                        Image("head_de").resizable().frame(width: 36, height: 36).background(.black)
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                    } else {
                        if let image = headImage {
                            Image(uiImage: image).resizable().frame(width: 36, height: 36).background(.black)
                                .clipShape(RoundedRectangle(cornerRadius: 18))
                        }
                    }
                    
                } else {
                    Image("head_de").resizable().frame(width: 36, height: 36).background(.black)
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                }
            }.padding(.horizontal, 20)
                .onAppear {
                    if let uid = nowUser.uerId {
                        headImage = ErigoLoginVM.shared.ErigoLoadIamge(uid: uid)
                    }
                }
        } else { // 对方
            HStack(alignment: .bottom, spacing: 12) {
                Image("eye_\(diaUser.uid!)") // 头像
                    .resizable()
                    .scaledToFill()
                    .frame(width: 36, height: 36)
                    .background(.black)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                VStack(alignment: .leading) {
                    Text(sigleModl.mesContent!) // 聊天内容
                        .font(.custom("PingFang SC", size: 13))
                        .foregroundStyle(Color(hes: "#111111"))
                        .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                        .background(.white)
                        .clipShape(RoundedCorner(radius: 20, corners: [.topLeft, .topRight, .bottomRight]))
                    Text("\(diaUser.name!) \(sigleModl.mesTime!)") // 时间
                        .font(.custom("PingFang SC", size: 13))
                        .foregroundStyle(Color(hes: "#999999"))
                }
                Spacer()
            }.padding(.horizontal, 20)
        }
    }
}
