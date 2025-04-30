//
//  MondoDetials.swift
//  Mondo
//
//  Created by 北川 on 2025/4/28.
//

import SwiftUI

// MARK: 帖子详情
struct MondoDetials: View {
    
    var titleModel: MondoTitleM
    
    @State var showReport: Bool = false
    
    @State var inputCom: String = ""
    
    @FocusState var isCom: Bool
    
    @State var isLike: Bool = false
    
    @State var commentList: [String] = []
    
    @ObservedObject var monLogin = MondoUserVM.shared
    
    @EnvironmentObject var pageControl: MondoPageControl
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                if titleModel.isVideo {
                    ZStack {
                        Image(titleModel.cover).resizable().scaledToFill()
                            .background(.black)
                            .frame(width: MONDOSCREEN.WIDTH, height: MONDOSCREEN.HEIGHT * 0.4)
                        if titleModel.isVideo {
                            Image("btnPlay")
                                .buttonStyle(MondoReEffort())
                        }
                    }.onTapGesture {
                        pageControl.route(to: .SAFEVIDEO(titleModel.media, 1, false, 0))
                    }
                } else {
                    ZStack {
                        Image(titleModel.cover).resizable().scaledToFill()
                            .background(.black)
                            .frame(width: MONDOSCREEN.WIDTH, height: MONDOSCREEN.HEIGHT * 0.4)
                    }.onTapGesture {
                        pageControl.route(to: .SAFEVIDEO(titleModel.media, 0, false, 0))
                    }
                }
                Spacer()
            }.background(.clear)
            VStack {
                ZStack {
                    Image("details_bg").resizable()
                    VStack {
                        HStack(alignment: .bottom) {
                            Image(titleModel.uHead).resizable().scaledToFill() // 头像
                                .frame(width: 62, height: 62)
                                .clipShape(RoundedRectangle(cornerRadius: 31))
                                .onTapGesture {
                                    pageControl.backToLevel()
                                    pageControl.route(to: .OTHERONE(MondoUserVM.shared.MondoGetAssignUser(uid: titleModel.uId)))
                                }
                            Text(titleModel.uName) // 名字
                                .font(.custom("Futura-CondensedExtraBold", size: 16))
                                .foregroundStyle(Color(hex: "#111111"))
                            Spacer()
                            Button(action: { // 发送消息
                                if monLogin.loginIn {
                                    pageControl.route(to: .SIDEBYSID(MondoUserVM.shared.MondoGetAssignUser(uid: titleModel.uId)))
                                } else {
                                    pageControl.route(to: .LOGIN)
                                }
                            }) { Image("details_send").resizable() }
                                .frame(width: 194, height: 40)
                                .offset(CGSize(width: 10, height: 0))
                        }
                        
                        VStack(alignment: .leading, spacing: 15) {
                            Text(titleModel.topic) // 标题
                                .font(.custom("Futura-CondensedExtraBold", size: 20))
                                .foregroundStyle(Color(hex: "#111111"))
                            Text(titleModel.content) // 内容
                                .font(.custom("PingFangSC-Regular", size: 13))
                                .foregroundStyle(Color(hex: "#333333"))
                        }.padding(.top, 10)
                        
                        VStack {
                            HStack {
                                HStack { // 评论
                                    Spacer().frame(width: 15)
                                    TextField("Comment on it", text: $inputCom)
                                        .font(.custom("PingFangSC-Medium", size: 14))
                                        .foregroundStyle(Color(hex: "#999999"))
                                        .focused($isCom)
                                    Spacer().frame(width: 15)
                                }.frame(height: 40)
                                .background(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color(hex: "#925EFF"), lineWidth: 2)
                                )
                                Spacer()
                                Button(action: {
                                    guard !inputCom.isEmpty else { isCom = true
                                        return }
                                    if monLogin.loginIn {
                                        MondoUserVM.shared.MondoSvComment(mId: titleModel.mId, comment: inputCom)
                                        MondoLoadComment()
                                        inputCom = ""
                                    } else {
                                        pageControl.route(to: .LOGIN)
                                    }
                                }) { Text("Send")
                                        .font(.custom("PingFangSC-Medium", size: 14))
                                        .foregroundStyle(Color(hex: "#FFFFFF"))}
                                .frame(width: 60, height: 40)
                                .background(.yellow)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                        }.padding(.top, 15)
                        
                        ScrollView(showsIndicators: false) {
                            VStack(spacing: 16) {
                                ForEach(commentList, id: \.self) { item in
                                    MondoCommentItem(comment: item)
                                        .frame(width: MONDOSCREEN.WIDTH - 32)
                                }
                            }
                        }.padding(.top, 10)
                        
                        Spacer()
                    }
                    .padding(.top, -10)
                    .padding(.horizontal, 16)
                }.frame(width: MONDOSCREEN.WIDTH, height: MONDOSCREEN.HEIGHT * 0.65)
            }.frame(width: MONDOSCREEN.WIDTH, height: MONDOSCREEN.HEIGHT * 0.7)
            HStack {
                Button(action: {
                    pageControl.backToLevel()
                }) { Image("backDetails") }
                
                Spacer()
                
                Button(action: { // 举报
                    showReport = true
                }) { Image("btnReport") }
            }.padding(.horizontal, 32)
                .padding(.bottom, MONDOSCREEN.HEIGHT * 0.88)
            
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
                
            }) {
                ZStack {
                    Image("like_bg").resizable().scaledToFill()
                        .frame(width: MONDOSCREEN.WIDTH * 0.4, height: 50)
                    HStack(alignment: .center, spacing: 8) {
                        Image("like_white")
                        Text("Like")
                            .font(.custom("PingFangSC-Regular", size: 14))
                            .foregroundStyle(Color(hex: "#FFFFFF"))
                        Text("\(isLike ? titleModel.likes + 1 : titleModel.likes)")
                            .font(.custom("PingFangSC-Regular", size: 14))
                            .foregroundStyle(Color(hex: "#FFFFFF"))
                    }.padding(.bottom, 10)
                }
            }
                .padding(.bottom, 40)
            if showReport {
                MondoReportItem(isReport: $showReport) {
                    MondoUserVM.shared.monReportList.append(titleModel.mId)
                    MondoUserVM.shared.MondoRemoveLike()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        pageControl.backToLevel()
                    }
                }
            }
        }.ignoresSafeArea()
            .onAppear {
                if monLogin.loginIn {
                    MondoLoadComment()
                    isLike = MondoUserVM.shared.MondoIsLike(mId: titleModel.mId)
                }
            }
    }
    
    /// 获取评论
    func MondoLoadComment() {
        commentList = MondoUserVM.shared.MondoGetCommentList(mId: titleModel.mId)
    }
}

// MARK: 评论
struct MondoCommentItem: View {
    
    @State var uploadImage: UIImage?
    
    var monMe = MondoCacheVM.MondoAvCurUser()
    
    var comment: String
    
    var body: some View {
        VStack {
            HStack {
                if let image = uploadImage {
                    Image(uiImage: image).resizable().scaledToFill() // 头像
                        .frame(width: 44, height: 44)
                        .clipShape(RoundedRectangle(cornerRadius: 22))
                } else {
                    Image("monder").resizable().scaledToFill() // 头像
                        .frame(width: 44, height: 44)
                        .clipShape(RoundedRectangle(cornerRadius: 22))
                }
                VStack(alignment: .leading) {
                    Text(monMe.name) // 名字
                        .font(.custom("PingFangSC-Medium", size: 14))
                        .foregroundStyle(Color(hex: "#111111"))
                    Text(comment) // 评论
                        .font(.custom("PingFangSC-Regular", size: 12))
                        .foregroundStyle(Color(hex: "#111111"))
                }
                Spacer()
            }
        }.onAppear {
            uploadImage = MondoUserVM.shared.MondoAvHead(uid: monMe.uid)
        }
    }
}
