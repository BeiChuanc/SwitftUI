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
    
    @FocusState var isMes: Bool
    
    @EnvironmentObject var pageControl: MondoPageControl
    
    var body: some View {
        ZStack {
            Image("message_bg").resizable()
            VStack {
                HStack {
                    Button(action: {
                        
                    }) { Image("guide_back") }
                    Text("dsdad") // 用户名
                        .font(.custom("Futura-CondensedExtraBold", size: 20))
                        .foregroundStyle(Color.black)
                    Spacer()
                    Button(action: {
                        
                    }) { Image("btnReport") }
                }
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
                        .frame(height: 52)
                        .focused($isMes)
                    Button(action: {
                        guard !inputMes.isEmpty else {
                            isMes = true
                            return
                        }
                        
                    }) { // 发送
                        Image("btnSend")
                    }
                }.padding(.horizontal, 10)
                .padding(.bottom, 50)
            }.padding(.horizontal, 16)
                .padding(.top, 70)
        }.ignoresSafeArea()
    }
}
