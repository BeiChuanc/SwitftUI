//
//  ErigoBoxDetail.swift
//  Erigo
//
//  Created by 北川 on 2025/4/22.
//

import SwiftUI

// MARK: 群组人员详情
struct ErigoBoxDetail: View {
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                Image("set_bg")
                    .resizable()
                    .frame(height: ERIGOSCREEN.HEIGHT * 0.18)
                
                // 用户列表
                
                
                Spacer()
            }
            HStack {
                Button(action: {
                    
                }) {
                    Image("global_back")
                }
                Image("chatAllUser")
                Spacer()
            }.padding(.top, 70)
                .padding(.leading, 20)
        }
        .frame(width: ERIGOSCREEN.WIDTH,
               height: ERIGOSCREEN.HEIGHT)
        .ignoresSafeArea()
        .background(.black)
    }
}

#Preview {
    ErigoBoxDetail()
}

// MARK: 用户Item
struct ErigoChatUserItem: View {
    
    var chatUserHead: String
    
    var chatUserName: String
    
    var chatCallBack: () -> Void
    
    var body: some View {
        HStack {
            Image("") // 头像地址
                .resizable()
                .frame(width: 54, height: 54)
                .clipShape(RoundedRectangle(cornerRadius: 27))
            Text("kjdyasdasdad") // 用户名
                .foregroundColor(.white)
                .font(.custom("Futura-CondensedExtraBold", size: 18))
            Spacer()
            Button(action: { // 去单人聊天
                chatCallBack()
            }) {
                Image("btnChat")
            }
        }.padding(.horizontal, 20)
    }
}
