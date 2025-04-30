//
//  MondoUser.swift
//  Mondo
//
//  Created by 北川 on 2025/4/28.
//

import SwiftUI
import Kingfisher

// MARK: 他人中心
struct MondoUser: View {
    
    var userModel: MondoerM
    
    @State var publishedPicture: Bool = true
    
    @State var isEmpty: Bool = true
    
    @State var isFollow: Bool = false
    
    @State var showReport: Bool = false
    
    @State var userLibPic: [MondoTitleM] = []
    
    @State var userLib: [MondoTitleM] = []
    
    var userPic: [MondoTitleM] {
        return userLib.filter { !$0.isVideo }
    }
    
    var userVio: [MondoTitleM] {
        return userLib.filter { $0.isVideo }
    }
    
    @ObservedObject var monLogin = MondoUserVM.shared
    
    @EnvironmentObject var pageControl: MondoPageControl
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Image("personal_bg").resizable()
            ZStack(alignment: .bottom) {
                VStack {}.frame(width: MONDOSCREEN.WIDTH, height: MONDOSCREEN.HEIGHT * 0.75)
                    .background(.white)
                    .clipShape(MondoRoundItem(radius: 10, corners: [.topLeft, .topRight]))
                VStack {
                    HStack {
                        Image(userModel.head!).resizable().scaledToFill() // 个人头像
                            .frame(width: 62, height: 62)
                            .background(.black)
                            .clipShape(RoundedRectangle(cornerRadius: 31))
                        Spacer()
                    }
                    
                    HStack {
                        Text(userModel.name!) // 用户昵称
                            .font(.custom("PingFangSC-Semibold", size: 20))
                            .foregroundStyle(Color(hex: "#111111"))
                        Spacer()
                        Button(action: { // 关注
                            if monLogin.loginIn {
                                if MondoUserVM.shared.MondoIsFollow(uId: userModel.uid!) {
                                    MondoCacheVM.MondoFixDetails { mon in
                                        mon.follower.removeAll(where: { $0 == userModel.uid! })
                                        return mon
                                    }
                                    isFollow = false
                                } else {
                                    MondoCacheVM.MondoFixDetails { mon in
                                        mon.follower.append(userModel.uid!)
                                        return mon
                                    }
                                    isFollow = true
                                }
                            } else {
                                pageControl.route(to: .LOGIN)
                            }
                        }) { Image(isFollow ? "btnFollowed" : "btnFollow") }
                        Button(action: { // 发送消息
                            if monLogin.loginIn {
                                pageControl.route(to: .SIDEBYSID(userModel))
                            } else {
                                pageControl.route(to: .LOGIN)
                            }
                        }) { Image("sendMes") }
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
                    }.padding(.top, 5)
                    
                    Spacer()
                    
                    // 相册
                    VStack {
                        if publishedPicture {
                            ZStack {
                                ScrollView(showsIndicators: false) {
                                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) { // 数据
                                        ForEach(userPic) { item in
                                            Image(item.cover)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: (MONDOSCREEN.WIDTH - 44) / 2, height: (MONDOSCREEN.WIDTH - 44) / 2 * 1.3)
                                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                                .onTapGesture {
                                                    pageControl.route(to: .SHOWDETAIL(item))
                                                }
                                        }
                                    }
                                }
                                if userPic.count == 0 {
                                    VStack(spacing: 20) {
                                        Image("noData")
                                        Text("No data yet")
                                            .font(.custom("PingFangSC-Regular", size: 14))
                                            .foregroundStyle(Color(hex: "#111111"))
                                    }
                                }
                            }
                        } else {
                            ZStack {
                                ScrollView(showsIndicators: false) {
                                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) { // 数据
                                        ForEach(userVio) { item in
                                            ZStack {
                                                Image(item.cover)
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: (MONDOSCREEN.WIDTH - 44) / 2, height: (MONDOSCREEN.WIDTH - 44) / 2 * 1.3)
                                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                                Image("btnPlay")
                                                    .buttonStyle(MondoReEffort())
                                            }
                                            .onTapGesture {
                                                pageControl.route(to: .SHOWDETAIL(item))
                                            }
                                        }
                                    }
                                }
                                if userVio.count == 0 {
                                    VStack(spacing: 20) {
                                        Image("noData")
                                        Text("No data yet")
                                            .font(.custom("PingFangSC-Regular", size: 14))
                                            .foregroundStyle(Color(hex: "#111111"))
                                    }
                                }
                            }
                        }
                    }
                }.frame(width: MONDOSCREEN.WIDTH - 32, height: MONDOSCREEN.HEIGHT * 0.78)
    
                HStack {
                    Button(action: {
                        pageControl.backToLevel()
                    }) { Image("guide_back") }
                    Spacer()
                    Button(action: { // 举报
                        showReport = true
                    }) { Image("btnReport") }
                }.padding(.horizontal, 16)
                    .padding(.bottom, MONDOSCREEN.HEIGHT * 0.88)
                if showReport {
                    MondoReportItem(isReport: $showReport) {
                        MondoUserVM.shared.monBlockList.append(userModel.uid!)
                        MondoUserVM.shared.MondoRemoveLike()
                        MondoUserVM.shared.MondoRemoveFollow()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            pageControl.backToLevel()
                        }
                    }
                }
            }
        }.ignoresSafeArea()
            .onAppear {
                userLib = MondoUserVM.shared.MondoGetTitle(uid: userModel.uid!)
                if monLogin.loginIn {
                    isFollow = MondoUserVM.shared.MondoIsFollow(uId: userModel.uid!)
                }
            }
    }
}
