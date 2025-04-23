//
//  ErigoChatGroup.swift
//  Erigo
//
//  Created by 北川 on 2025/4/21.
//

import SwiftUI

struct ErigoChatGroup: View {
    
    @State var groupChatMes: String = ""
    
    @FocusState var groupChat: Bool
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {}) {  // 返回
                    Image("global_back")
                }
                Spacer()
                Image("disCuss")
                Spacer()
                Button(action: {}) { // 举报
                    Image("btnReport")
                }
            }
            .padding(.top, 60)
            .padding(.horizontal, 20)
            
            HStack { // 讨论组
                HStack(alignment: .bottom) {
                    Image("") // 用户的头像
                        .frame(width: 54, height: 54)
                        .clipShape(RoundedRectangle(cornerRadius: 27))
                        .padding(.leading, 20)
                    Text("60 Online")
                        .font(.custom("PingFang SC", size: 12))
                        .foregroundStyle(Color(hes: "#FCFB4E"))
                    
                }
                Spacer()
                
            }
            .frame(width: ERIGOSCREEN.WIDTH, height: 78)
            .background(Color(hes: "#FF629D"))
            .padding(.top, 20)
            
            /* 聊天列表 */
              
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
                Button(action: {}) {
                    Image("btnChatSend")
                }
            }.padding(.horizontal, 10)
            .padding(.bottom, 50)
            
        }
        .frame(width: ERIGOSCREEN.WIDTH,
               height: ERIGOSCREEN.HEIGHT)
        .ignoresSafeArea()
        .background(.black)
    }
    
    /// 聊天时间
    func ErigoCurChatTime() -> String {
        let chatDate = Date()
        let matter = DateFormatter()
        matter.dateFormat = "hh:mm"
        return matter.string(from: chatDate)
    }
}
