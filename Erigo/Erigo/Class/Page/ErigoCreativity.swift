//
//  ErigoCreativity.swift
//  Erigo
//
//  Created by 北川 on 2025/4/21.
//

import SwiftUI

// MARK: 首页
struct ErigoCreativity: View {
    
    @State var currentPage: Int = 0
    
    @State var isShowGroup: Bool = true
    
    @ObservedObject var LoginVM = ErigoLoginVM.shared
    
    @EnvironmentObject var router: ErigoRoute
    
    var leftItems: [(index: Int, element: ErigoEyeTitleM)] {
        LoginVM.eyeTitles.enumerated()
            .filter { $0.offset.isMultiple(of: 2) }
            .map { (index: $0.offset, element: $0.element) }
    }

    var rightItems: [(index: Int, element: ErigoEyeTitleM)] {
        LoginVM.eyeTitles.enumerated()
            .filter { !$0.offset.isMultiple(of: 2) }
            .map { (index: $0.offset, element: $0.element) }
    }
    
    var body: some View {
        ZStack {
            Image("first_bg")
                .resizable()
            VStack {
                HStack(alignment: .top) {
                    Spacer()
                    Image("eyeShadow").offset(CGSize(width: 15, height: 0))
                    Spacer()
                    Button(action: { // 消息列表
                        router.naviTo(to: .MESLIST)
                    }) {
                        Image("btnMes")
                    }.padding(.trailing, 20)
                }.padding(.top, 50)
                
                ZStack(alignment: .center) {
                    Image("scroll_bg")
                    TabView(selection: $currentPage) { // 推送
                        ForEach(1..<7) { index in
                            Image("rec_\(index)").resizable()
                                .frame(width: 295, height: 128)
                                .background(.black)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(.black, lineWidth: 1)
                                )
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    .onChange(of: currentPage) { newValue in }
                    .frame(width: 295, height: 128)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    Image("mesListFlower")
                        .offset(CGSize(width: -130, height: 50))
                    
                    ZStack {
                        ErigoDetilsIndicator(currentPage: $currentPage,
                                             totalPages: 6,
                                             selectColor: Color(hes: "#FCFB4E"),
                                             normalColor: .white,
                                             selectW: 12, normalW: 6, normalH: 6, isEffect: true)
                        .padding(.top, 90)
                    }
                }
                
                HStack {
                    Spacer()
                    Image("makeUp")
                        .offset(CGSize(width: 0, height: -35))
                }
                
                HStack {
                    Image("popular")
                    Image("firtRow")
                    Spacer()
                    Image("mesStar")
                }
                .padding(.horizontal, 20)
                .offset(CGSize(width: 0, height: -35))
                
                VStack {
                    // 帖子列表
                    ScrollView(showsIndicators: false) {
                        HStack(alignment: .top, spacing: 10) {
                            VStack(alignment: .leading, spacing: 10) {
                                if isShowGroup {
                                    ErigoGroupItem() // 特殊处理群组
                                        .onTapGesture {
                                            if LoginVM.landComplete {
                                                router.naviTo(to: .DISGROUP)
                                            } else {
                                                router.naviTo(to: .LAND)
                                            }
                                        }
                                }
                                ForEach(leftItems, id: \.element.id) { item in
                                    ErigoOtherUserItem(cover: item.element.cover!, head: "eye_\(item.element.bid!)", goTitleDetails: {
                                        router.naviTo(to: .POSTDETAILS(item.element))
                                    }, goUserInfo: {
                                        router.naviTo(to: .USERINFO(LoginVM.ErigoGetAssignUser(uid: item.element.bid!)))
                                    }).id(item.index)
                                }
                            }
                            VStack {
                                ForEach(rightItems, id: \.element.id) { item in
                                    ErigoOtherUserItem(cover: item.element.cover!, head:"eye_\(item.element.bid!)", goTitleDetails: {
                                        router.naviTo(to: .POSTDETAILS(item.element))
                                    }, goUserInfo: {
                                        router.naviTo(to: .USERINFO(LoginVM.ErigoGetAssignUser(uid: item.element.bid!)))
                                    }).id(item.index)
                                }
                            }
                        }
                    }.offset(CGSize(width: 0, height: -40))
                    Spacer()
                }
                .frame(height: ERIGOSCREEN.HEIGHT * 0.53)
            }
            .padding(EdgeInsets(top: 60, leading: 10, bottom: 0, trailing: 10))
        }
        .frame(width: ERIGOSCREEN.WIDTH,
               height: ERIGOSCREEN.HEIGHT)
        .ignoresSafeArea()
        .onAppear {
            if LoginVM.landComplete {
                if let isShow = ErigoUserDefaults.ErigoAvNowUser().isReportG {
                    isShowGroup = !isShow
                }
            }
        }
    }
}

// MARK: 首页群组Item
struct ErigoGroupItem: View {
    var body: some View {
        ZStack(alignment: .topLeading) {
            Image("first_group")
                .resizable()
                .scaledToFill()
                .frame(width: (ERIGOSCREEN.WIDTH - 40) / 2, height: (ERIGOSCREEN.WIDTH - 40) / 2 * 1.12)
            Image("leftFork")
                .offset(CGSize(width: -10, height: -10))
        }
    }
}

// MARK: 其余用户Item
struct ErigoOtherUserItem: View {
    
    var cover: String
    
    var head: String
    
    var goTitleDetails: () -> Void
    
    var goUserInfo: () -> Void
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Image(cover) // cover
                .resizable()
                .scaledToFill()
                .frame(width: (ERIGOSCREEN.WIDTH - 40) / 2, height: (ERIGOSCREEN.WIDTH - 40) / 2 * 1.5)
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color(hes: "#FBFF4A"), lineWidth: 2)
                )
                .onTapGesture {
                    goTitleDetails()
                }
            Image(head) // head
                .resizable()
                .scaledToFill()
                .frame(width: 36, height: 36)
                .clipShape(RoundedRectangle(cornerRadius: 18))
                .padding(EdgeInsets(top: 12, leading: 12, bottom: 0, trailing: 0))
                .onTapGesture {
                    goUserInfo()
                }
        }
    }
}
