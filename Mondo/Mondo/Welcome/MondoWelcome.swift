//
//  MondoWelcome.swift
//  Mondo
//
//  Created by 北川 on 2025/4/27.
//

import SwiftUI

// MARK: 首页
struct MondoWelcome: View {
    
    var monMe = MondoCacheVM.MondoAvCurUser()
    
    @State var isPicture: Bool = true
    
    @ObservedObject var monLogin = MondoUserVM.shared
    
    @EnvironmentObject var pageControl: MondoPageControl
    
    var imageItems: [(index: Int, element: MondoTitleM)] {
        monLogin.monTitles.enumerated()
            .filter { !$0.element.isVideo }
            .map { (index: $0.offset, element: $0.element) }
    }

    var videoItems: [(index: Int, element: MondoTitleM)] {
        monLogin.monTitles.enumerated()
            .filter { $0.element.isVideo }
            .map { (index: $0.offset, element: $0.element) }
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Image("welcome_bg")
                .resizable()
            VStack(spacing: 20) {
                HStack {
                    Image("welcome_topic").padding(.leading, 16)
                    Spacer()
                }.frame(width: MONDOSCREEN.WIDTH)
                    .padding(.top, 60)
                ScrollView {
                    VStack(spacing: 20) {
                        Button(action: { // 官方登山指南
                            pageControl.route(to: .SAFEGUIDE)
                        }) { Image("offic_guide").resizable()
                            .frame(width: MONDOSCREEN.WIDTH - 32, height: (MONDOSCREEN.WIDTH - 32) * 0.6) }
                            .buttonStyle(MondoReEffort())
                        
                        Button(action: { // 排行
                            pageControl.route(to: .HOTNOTES)
                        }) { Image("top_list").resizable()
                            .frame(width: MONDOSCREEN.WIDTH - 32, height: (MONDOSCREEN.WIDTH - 32) * 0.32) }
                            .buttonStyle(MondoReEffort())
                        
                        HStack(spacing: 25) {
                            Button(action: { withAnimation { isPicture = true } }) { Image("wel_pice") } // 图片
                                .buttonStyle(MondoReEffort())
                                .background(content: { Image("wel_print")
                                        .opacity(isPicture ? 1 : 0)
                                        .animation(.easeIn(duration: 0.3), value: isPicture)
                                })
                            Button(action: { withAnimation { isPicture = false } }) { Image("wel_video") } // 视频
                                .buttonStyle(MondoReEffort())
                                .background(content: { Image("wel_print")
                                        .opacity(isPicture ? 0 : 1)
                                        .animation(.easeIn(duration: 0.3), value: isPicture)
                                })
                            Spacer()
                        }.padding(.leading, 5)
                            .frame(width: MONDOSCREEN.WIDTH - 32)
                        
                        if isPicture { // 帖子数据
                            ZStack {
                                ScrollView(showsIndicators: false) {
                                    ForEach(imageItems, id: \.element.id) { item in
                                        VStack(spacing: 16) {
                                            MondoTitleItem(titleModel: item.element)
                                        }
                                    }
                                }
                                if imageItems.isEmpty {
                                    VStack {
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
                                    ForEach(videoItems, id: \.element.id) { item in
                                        VStack(spacing: 16) {
                                            MondoTitleItem(titleModel: item.element)
                                        }
                                    }
                                }
                                if videoItems.isEmpty {
                                    VStack {
                                        Image("noData")
                                        Text("No data yet")
                                            .font(.custom("PingFangSC-Regular", size: 14))
                                            .foregroundStyle(Color(hex: "#111111"))
                                    }
                                }
                            }
                        }
                        
                        Spacer()
                    }
                        .padding(.horizontal, 16)
                }
                Spacer()
            }
            Button(action: { // 发布页
                pageControl.route(to: .RELEASE)
            }) { Image("btnPost") }.padding(.bottom, 105)
        }
        .ignoresSafeArea()
    }
}

// MARK: 帖子展示Item
struct MondoTitleItem: View {
    
    var titleModel: MondoTitleM
    
    var monMe = MondoCacheVM.MondoAvCurUser()
    
    @State var isLike: Bool = false
    
    @State var isReport: Bool = false
    
    @ObservedObject var monLogin = MondoUserVM.shared
    
    @EnvironmentObject var pageControl: MondoPageControl
    
    var body: some View {
        VStack {
            HStack {
                Image(titleModel.uHead) // 用户头像
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                VStack(alignment: .leading) {
                    Text(titleModel.uName) // 名字
                        .font(.custom("Futura-CondensedExtraBold", size: 16))
                        .foregroundStyle(Color(hex: "#111111"))
                    Text(titleModel.time) // 发布时间
                        .font(.custom("PingFangSC-Regular", size: 12))
                        .foregroundStyle(Color(hex: "#999999"))
                }
                Spacer()
            }.padding(.horizontal, 16)
            HStack {
                VStack { Image(titleModel.cover) // 媒体图片
                        .resizable()
                        .scaledToFill()
                        .frame(width: MONDOSCREEN.WIDTH - 80, height: (MONDOSCREEN.WIDTH - 80) * 0.8)
                        .clipShape(RoundedRectangle(cornerRadius: 12)) }

                Spacer()
                ZStack {
                    VStack(spacing: 25) {
                        Button(action: { // 喜欢
                            if monLogin.loginIn {
                                if MondoUserVM.shared.MondoIsLike(mId: titleModel.mId) {
                                    MondoCacheVM.MondoFixDetails { eiger in
                                        eiger.likes.removeAll(where: { $0.mId == titleModel.mId })
                                        return eiger
                                    }
                                    isLike = false
                                } else {
                                    MondoCacheVM.MondoFixDetails { eiger in
                                        eiger.likes.append(titleModel)
                                        return eiger
                                    }
                                    isLike = true
                                }
                            } else {
                                pageControl.route(to: .LOGIN)
                            }
                        }) { Image(isLike ? "tLike_select" : "tLike") }
        
                        Button(action: { // 举报
                            isReport = true
                        }) { Image("btnReport") }
                        
                        Button(action: { // 评论
                            pageControl.route(to: .SHOWDETAIL(titleModel))
                        }) { Image("btnComment") }
                    }
                    if isReport {
                        MondoReportItem(isReport: $isReport) {
                            MondoUserVM.shared.monReportList.append(titleModel.mId)
                        }
                    }
                }
            }.padding(.horizontal, 16)
        }
        .onAppear {
            if monLogin.loginIn {
                isLike = MondoUserVM.shared.MondoIsLike(mId: titleModel.mId)
            }
        }
    }
}
