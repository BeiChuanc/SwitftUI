//
//  ErigoChatGroup.swift
//  Erigo
//
//  Created by 北川 on 2025/4/21.
//

import SwiftUI

struct ErigoChatGroup: View {
    
    var grouId: Int = 8000
    
    var nowUser = ErigoUserDefaults.ErigoAvNowUser()
    
    @State var groupChatMes: String = ""
    
    @FocusState var groupChat: Bool
    
    @State var headImage: UIImage?
    
    @State var groupMes: [ErigoChatM] = []
    
    @State var groupUser: [ErigoEyeUserM] = []
    
    @EnvironmentObject var router: ErigoRoute
    
    var body: some View {
        VStack {
            HStack {
                Button(action: { router.previous() }) {  // 返回
                    Image("global_back")
                }
                Spacer()
                Image("disCuss")
                Spacer()
                Button(action: {
                    ErigoMesAndPubVM.ErigoShowReport {
                        ErigoUserDefaults.updateUserDetails { erigo in
                            erigo.isReportG = true
                            return erigo
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            router.previous()
                        }
                    }
                }) { // 举报
                    Image("btnReport")
                }
            }
            .padding(.top, 60)
            .padding(.horizontal, 20)
            
            HStack { // 讨论组
                HStack(alignment: .bottom) {
                    if let head = nowUser.head {
                        if head == "head_de" {
                            Image("head_de").resizable().scaledToFill().frame(width: 54, height: 54).background(.black)
                                .clipShape(RoundedRectangle(cornerRadius: 27))
                        } else {
                            if let image = headImage {
                                Image(uiImage: image).resizable().scaledToFill().frame(width: 54, height: 54).background(.black)
                                    .clipShape(RoundedRectangle(cornerRadius: 27))
                            }
                        }
                        
                    } else {
                        Image("head_de").resizable().scaledToFill().frame(width: 54, height: 54).background(.black)
                            .clipShape(RoundedRectangle(cornerRadius: 27))
                    }
                    Text("\(groupUser.count + 1) Online")
                        .font(.custom("PingFang SC", size: 12))
                        .foregroundStyle(Color(hes: "#FCFB4E"))
                }.padding(.leading, 20)
                    .frame(width: ERIGOSCREEN.WIDTH * 0.33)
                Spacer()
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack (alignment: .center, spacing: 10) {
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
            .frame(width: ERIGOSCREEN.WIDTH, height: 78)
            .background(Color(hes: "#FF629D"))
            .padding(.top, 20)
            
            /* 聊天列表 */
            ScrollViewReader { proxy in // 消息列表
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack (spacing: 20) {
                        ForEach(groupMes) { item in
                            ErigoChatGroupItem(groupMes: item, nowUser: nowUser)
                        }
                    }.padding(.vertical, 10)
                }.onChange(of: groupMes.count) { _ in
                    scrollToBottom(proxy: proxy)
                }
            }.padding(.horizontal, 20)
            
            Spacer()
            
            HStack(spacing: 12) { // 输入框
                ChatInputMes(text: $groupChatMes,
                             placeholder: "Say something",
                             leftPadding: 10,
                             textColor: UIColor(hes: "#111111", alpha: 0.3),
                             placeholderColor: UIColor(hes: "#111111", alpha: 0.3),
                             textFont: UIFont(name: "PingFang SC", size: 18)!)
                    .frame(height: 45)
                    .background(Color(hes: "#FCFB4E"))
                    .clipShape(RoundedRectangle(cornerRadius: 22.5))
                    .focused($groupChat)
                Button(action: {
                    guard !groupChatMes.isEmpty else {
                        groupChat = true
                        return
                    }
                    ErigoGroupSendMes(mes: groupChatMes)
                }) { // 发送
                    Image("btnChatSend")
                }
            }.padding(.horizontal, 10)
            .padding(.bottom, 50)
            
        }
        .frame(width: ERIGOSCREEN.WIDTH,
               height: ERIGOSCREEN.HEIGHT)
        .ignoresSafeArea()
        .background(.black)
        .onAppear {
            if let uid = nowUser.uerId {
                headImage = ErigoLoginVM.shared.ErigoLoadIamge(uid: uid)
            }
            groupMes = ErigoMesAndPubVM.shared.ErigoAvbMes(diaId: "\(ErigoUserDefaults.ErigoAvNowUser().uerId!)\(grouId)")
            groupUser = ErigoLoginVM.shared.eyeUsers
        }
    }
    
    /// 聊天时间
    func ErigoCurChatTime() -> String {
        let chatDate = Date()
        let matter = DateFormatter()
        matter.dateFormat = "hh:mm"
        return matter.string(from: chatDate)
    }
    
    /// 群组发消息
    func ErigoGroupSendMes(mes: String) {
        var userMes = ErigoChatM()
        userMes.isForMe = true
        userMes.mesContent = mes
        userMes.mesTime = ErigoCurChatTime()
        groupMes.append(userMes)
        ErigoMesAndPubVM.shared.ErigoSaveMes(dialogist: "\(ErigoUserDefaults.ErigoAvNowUser().uerId!)\(grouId)", message: userMes)
        groupChatMes = ""
    }
    
    func scrollToBottom(proxy: ScrollViewProxy) {
        guard let lastMessage = groupMes.last else { return }
        withAnimation {
            proxy.scrollTo(lastMessage.id, anchor: .bottom)
        }
    }
}

// MARK: 聊天Item - 群组
struct ErigoChatGroupItem: View {
    
    var groupMes: ErigoChatM
    
    var nowUser: ErigoUserM
    
    @State var headImage: UIImage?
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 12) {
            Spacer()
            VStack(alignment: .trailing) {
                Text(groupMes.mesContent!) // 聊天内容
                    .font(.custom("PingFang SC", size: 13))
                    .foregroundStyle(Color(hes: "#111111"))
                    .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                    .background(Color(hes: "#FCFB4E"))
                    .clipShape(RoundedCorner(radius: 20, corners: [.topLeft, .topRight, .bottomLeft]))
                Text("\(groupMes.mesTime!) \(nowUser.name!)") // 时间
                    .font(.custom("PingFang SC", size: 13))
                    .foregroundStyle(Color(hes: "#999999"))
            }
            if let head = nowUser.head {
                if head == "head_de" {
                    Image("head_de")
                        .resizable()
                        .frame(width: 36, height: 36)
                        .background(.black)
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                } else {
                    if let image = headImage {
                        Image(uiImage: image)
                            .resizable()
                            .frame(width: 36, height: 36)
                            .background(.black)
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                    }
                }
                
            } else {
                Image("head_de")
                    .resizable()
                    .frame(width: 36, height: 36)
                    .background(.black)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
            }
        }.padding(.horizontal, 20)
            .onAppear {
                if let uid = nowUser.uerId {
                    headImage = ErigoLoginVM.shared.ErigoLoadIamge(uid: uid)
                }
            }
    }
}
