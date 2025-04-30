//
//  MondoHotNote.swift
//  Mondo
//
//  Created by 北川 on 2025/4/27.
//

import SwiftUI

// MARK: 热门笔记
struct MondoHotNote: View {
    
    @State var hotTitle: [MondoTitleM] = []
    
    @EnvironmentObject var pageControl: MondoPageControl
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            ZStack {
                Image("notes_bg").resizable().scaledToFill()
                VStack {
                    HStack {
                        Button(action: { pageControl.backToLevel() }) // 返回
                        { Image("titleBack").resizable().frame(width: 30, height: 30) }
                        Spacer()
                    }
                    HStack {
                        Image("ranking")
                        Spacer()
                    }
                    HStack {
                        Image("popular_notes")
                        Spacer()
                    }.padding(.top, 12)
                    Image("notes_top").padding(.top, 70)
                    VStack(spacing: 16) {
                        ForEach(hotTitle) { item in
                            MondoOfficeItem(hotModel: item).environmentObject(pageControl)
                        }
                    }
                }.padding(.top, 60)
                    .padding(.horizontal, 16)
            }.ignoresSafeArea()
                .frame(width: MONDOSCREEN.WIDTH, height: 1280)
        }
        .onAppear {
            hotTitle = Array(MondoUserVM.shared.monTitles.sorted(by: { $0.fires > $1.fires }).prefix(3))
        }
    }
}

// MARK: 官方帖子Item
struct MondoOfficeItem: View {
    
    var hotModel: MondoTitleM
    
    @State var inputCom: String = ""
    
    @FocusState var isCom: Bool
    
    @State var isLike: Bool = false
    
    @ObservedObject var monLogin = MondoUserVM.shared
    
    @EnvironmentObject var pageControl: MondoPageControl
    
    var body: some View {
        VStack {
            VStack {
                ZStack(alignment: .top) {
                    Image(hotModel.cover).resizable()
                        .frame(width: MONDOSCREEN.WIDTH - 32, height: 200)
                        .clipShape(MondoRoundItem(radius: 15, corners: [.topLeft, .topRight]))
                        .onTapGesture {
                            pageControl.route(to: .SHOWDETAIL(hotModel))
                        }
                    HStack(spacing: 12) {
                        ZStack {
                            Image("ranking_firebg").resizable().frame(width: 100, height: 40)
                            HStack {
                                Image("ranking_fire")
                                Text("\(hotModel.fires)") // 热度
                                    .font(.custom("PingFangSC-Semibold", size: 18))
                                    .foregroundStyle(Color(hex: "#4A1500"))
                            }.offset(CGSize(width: -5, height: 0))
                        }
                        Image(hotModel.uHead) // 推荐头像
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 40).background(.white).clipShape(RoundedRectangle(cornerRadius: 20))
                        Text(hotModel.uName)
                            .font(.custom("Futura-CondensedExtraBold", size: 16))
                            .foregroundStyle(.white)
                        Spacer()
                    }.padding(.bottom, 12)
                }
                VStack {
                    ZStack {
                        Text(hotModel.content)
                            .font(.custom("PingFangSC-Medium", size: 15))
                            .foregroundStyle(Color(hex: "#4A1500"))
                            .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                    }.frame(width: MONDOSCREEN.WIDTH - 32)
                    .background(Color(hex: "#FEF564"))
                    HStack {
                        HStack {
                            Spacer().frame(width: 15)
                            TextField("Say Something", text: $inputCom)
                                .font(.custom("PingFangSC-Medium", size: 14))
                                .foregroundStyle(Color(hex: "#111111"))
                                .focused($isCom)
                                .onSubmit {
                                    if monLogin.loginIn {
                                        MondSendComment(com: inputCom)
                                    } else {
                                        guard !inputCom.isEmpty else { isCom = true
                                            return }
                                        pageControl.route(to: .LOGIN)
                                    }
                                }
                            Spacer().frame(width: 15)
                        }.frame(width: MONDOSCREEN.WIDTH * 0.78, height: 40)
                            .background(Color(hex: "#F2F2F2"))
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                        Button(action: { // 点赞
                            if monLogin.loginIn {
                                if MondoUserVM.shared.MondoIsLike(mId: hotModel.mId) {
                                    MondoCacheVM.MondoFixDetails { eiger in
                                        eiger.likes.removeAll(where: { $0.mId == hotModel.mId })
                                        return eiger
                                    }
                                    isLike = false
                                } else {
                                    MondoCacheVM.MondoFixDetails { eiger in
                                        eiger.likes.append(hotModel)
                                        return eiger
                                    }
                                    isLike = true
                                }
                            } else {
                                pageControl.route(to: .LOGIN)
                            }
                        }) { Image(isLike ? "tLike_select" : "tLike").resizable().frame(width: 30, height: 30)
                        }
                    }.padding(.bottom, 15)
                }
            }
        }
        .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .onAppear {
                if monLogin.loginIn {
                    isLike = MondoUserVM.shared.MondoIsLike(mId: hotModel.mId)
                }
            }
    }
    
    /// 发布评论
    func MondSendComment(com: String) {
        MondoUserVM.shared.MondoSvComment(mId: hotModel.mId, comment: com)
        inputCom = ""
    }
}
