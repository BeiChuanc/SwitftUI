//
//  MondoOfficeGuide.swift
//  Mondo
//
//  Created by 北川 on 2025/4/28.
//

import SwiftUI

// MARK: 聊天群组ID
enum MONDOGROUPC: Int {
    
    case ONE = 1000
    
    case TWO
    
    case THREE
    
    case FOUR
}

// MARK: 官方引导页
struct MondoOfficeGuide: View {
    
    var group: [MONDOGROUPC] = [.ONE, .TWO, .THREE, .FOUR]
    
    @State var currentGuide: Int = 0
    
    @EnvironmentObject var pageControl: MondoPageControl
    
    var body: some View {
        ZStack {
            Image("OfficeBg").resizable()
            VStack {
                HStack {
                    Button(action: { pageControl.backToLevel() }) { Image("OfficeBack") }
                        .buttonStyle(MondoReEffort())
                    Spacer()
                }.padding(.leading, 16)
                TabView(selection: $currentGuide) {
                    ForEach(0..<4) { index in
                        MondoOfficeGuideItem(currentGuide: "office_\(index + 1)", groupId: group[index].rawValue)
                            .environmentObject(pageControl)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .onChange(of: currentGuide) { newValue in }
                .frame(width: MONDOSCREEN.WIDTH - 32, height: (MONDOSCREEN.WIDTH - 32) * 1.4)
                .padding(.leading, 32)
                .padding(.top, 10)
                MondoIndicator(currentGuide: $currentGuide,
                               totalGuide: 4,
                               currentColor: Color(hex: "#8254E3"),
                               unselectColor: Color(hex: "#000000", alpha: 0.2),
                               currentW: 40,
                               unselectW: 40,
                               normalH: 3)
                .padding(.top, 50)
                Spacer()
            }.padding(.top, 80)
        }.ignoresSafeArea()
    }
}

// MARK: 引导页Item
struct MondoOfficeGuideItem: View {
    
    var currentGuide: String
    
    var groupId: Int
    
    @State var userList: [MondoerM] = []
    
    @State var isLike: Bool = false
    
    @State var uploadImage: UIImage?
    
    @ObservedObject var monLogin = MondoUserVM.shared
    
    @EnvironmentObject var pageControl: MondoPageControl
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Image(currentGuide).resizable().scaledToFill()
            HStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: -12) {
                        if isLike {
                            if MondoCacheVM.MondoAvCurUser().head == "monder" {
                                Image("monder").resizable().scaledToFill() // 个人头像
                                    .frame(width: 25, height: 25)
                                    .clipShape(RoundedRectangle(cornerRadius: 12.5))
                            } else {
                                if let image = uploadImage {
                                    Image(uiImage: image).resizable().scaledToFill() // 个人头像
                                        .frame(width: 25, height: 25)
                                        .clipShape(RoundedRectangle(cornerRadius: 12.5))
                                }
                            }
                        }
                        ForEach(userList) { item in
                            Image(item.head!).resizable().scaledToFill() // 用户头像
                                .frame(width: 25, height: 25)
                                .clipShape(RoundedRectangle(cornerRadius: 12.5))
                        }
                    }
                }.frame(width: 100, height: 30)
                    .padding(.leading, 35)
                Text("+\(isLike ? userList.count + 1 : userList.count) Liked It")
                    .lineLimit(1)
                    .font(.custom("PingFangSC-Medium", size: 12))
                    .foregroundStyle(Color(hex: "#111111")).offset(CGSize(width: -10, height: 0))
                Image("like")
                Button(action: {
                    if monLogin.loginIn {
                        pageControl.route(to: .SIDEGROUP(groupId))
                    } else {
                        pageControl.route(to: .LOGIN)
                    }
                }) { Image("guide_join") }.padding(.trailing, 10)
                    .frame(width: 132)
            }.padding(.bottom, 10)
            Button(action: {
                if monLogin.loginIn {
                    isLike = true
                } else {
                    pageControl.route(to: .LOGIN)
                }
            }) {
                Image("btnLike")
                    .scaleEffect(isLike ? 1.5 : 1.0)
                    .animation(.easeInOut(duration: 0.5), value: isLike)
            }
            .padding(.bottom, (MONDOSCREEN.WIDTH - 32) * 0.52)
            .padding(.leading, (MONDOSCREEN.WIDTH - 32) * 0.75)
        }
        .onAppear() {
            userList = MondoUserVM.shared.monUsers
            if monLogin.loginIn {
                uploadImage = MondoUserVM.shared.MondoAvHead(uid: MondoCacheVM.MondoAvCurUser().uid)
            }
        }
    }
}
