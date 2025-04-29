//
//  MondoUser.swift
//  Mondo
//
//  Created by 北川 on 2025/4/28.
//

import SwiftUI

// MARK: 他人中心
struct MondoUser: View {
    
    @State var publishedPicture: Bool = true
    
    @State var isEmpty: Bool = true
    
    @State var isFollow: Bool = false
    
    @EnvironmentObject var pageControl: MondoPageControl
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Image("personal_bg").resizable()
            ZStack {
                VStack {}.frame(width: MONDOSCREEN.WIDTH, height: MONDOSCREEN.HEIGHT * 0.72)
                    .background(.white)
                    .clipShape(MondoRoundItem(radius: 10, corners: [.topLeft, .topRight]))
                VStack {
                    HStack {
                        Image("").resizable().scaledToFill() // 个人头像
                            .frame(width: 62, height: 62)
                            .background(.black)
                            .clipShape(RoundedRectangle(cornerRadius: 31))
                        Spacer()
                    }
                    
                    HStack {
                        Text("Jack") // 用户昵称
                            .font(.custom("PingFangSC-Semibold", size: 20))
                            .foregroundStyle(Color(hex: "#111111"))
                        Spacer()
                        Button(action: { // 关注
                            isFollow.toggle()
                        }) { Image(isFollow ? "btnFollow" : "btnFollowed") }
                        Button(action: { // 发送消息
                            
                        }) { Image("sendMes") }
                    }
                    
                    HStack(spacing: 25) { // 关注 & 粉丝 & 群聊
                        Text("\(0) Followers")
                            .font(.custom("PingFangSC-Regular", size: 12))
                            .foregroundStyle(Color(hex: "#111111"))
                        
                        Text("\(0) Fans")
                            .font(.custom("PingFangSC-Regular", size: 12))
                            .foregroundStyle(Color(hex: "#111111"))
                        
                        Text("\(0) Group Chats")
                            .font(.custom("PingFangSC-Regular", size: 12))
                            .foregroundStyle(Color(hex: "#111111"))
                        Spacer()
                    }
                    
                    HStack(spacing: 25) {
                        Button(action: { withAnimation { publishedPicture = true } }) { Image("publishImage") } // 图片
                            .opacity(publishedPicture ? 1 : 0.6)
                            .buttonStyle(MondoReEffort())
                            .background(content: { Image("wel_print")
                                    .opacity(publishedPicture ? 1 : 0)
                                    .animation(.easeIn(duration: 0.3), value: publishedPicture)
                            })
                        Button(action: { withAnimation { publishedPicture = false } }) { Image("publishVideo") } // 视频
                            .opacity(publishedPicture ? 0.6 : 1)
                            .buttonStyle(MondoReEffort())
                            .background(content: { Image("wel_print")
                                    .opacity(publishedPicture ? 0 : 1)
                                    .animation(.easeIn(duration: 0.3), value: publishedPicture)
                            })
                        Spacer()
                    }.padding(.top, 25)
                    
                    
                    
                    
                    Spacer()
                }.frame(width: MONDOSCREEN.WIDTH - 32, height: MONDOSCREEN.HEIGHT * 0.78)
                if isEmpty {
                    VStack(spacing: 20) {
                        Image("noData")
                        Text("No data yet")
                            .font(.custom("PingFangSC-Regular", size: 14))
                            .foregroundStyle(Color(hex: "#111111"))
                    }
                }
            }
        }.ignoresSafeArea()
    }
}

#Preview {
    MondoUser()
}
