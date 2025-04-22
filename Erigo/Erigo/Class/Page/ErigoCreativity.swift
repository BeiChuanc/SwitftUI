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
    
    @State var users = []
    
    @ObservedObject var LoginVM = ErigoLoginVM.shared
    
    @EnvironmentObject var router: ErigoRoute
    
    var body: some View {
        ZStack {
            Image("first_bg")
                .resizable()
            VStack {
                HStack(alignment: .top) {
                    Image("eyeShadow")
                    Button(action: { // 消息列表
                        if LoginVM.landComplete {
                            
                        } else {
                            router.naviTo(to: .LAND)
                            print("进入消息列表 - 需要登陆")
                        }
                    }) {
                        Image("btnMes")
                    }
                }
                
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
                    Image("makeUp").offset(CGSize(width: 0, height: -35))
                }
                
                HStack {
                    Image("popular")
                    Image("firtRow")
                    Spacer()
                    Image("mesStar")
                }.padding(.horizontal, 20)
                    .offset(CGSize(width: 0, height: -35))
                
                // 用户列表
                
                Spacer()
            }
            .padding(EdgeInsets(top: 60, leading: 10, bottom: 0, trailing: 10))
        }
        .frame(width: ERIGOSCREEN.WIDTH,
                height: ERIGOSCREEN.HEIGHT)
         .ignoresSafeArea()
    }
}

// MARK: 首页群组Item
struct ErigoGroupItem: View {
    var body: some View {
        ZStack {
            Image("first_group")
        }
    }
}

// MARK: 其余用户Item
struct ErigoOtherUserItem: View {
    var body: some View {
        ZStack(alignment: .topLeading) {
            Image("")
                .resizable()
                .frame(width: 161, height: 240)
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color(hes: "#FBFF4A"), lineWidth: 2)
                )
            Image("")
                .resizable()
                .frame(width: 24, height: 24)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(EdgeInsets(top: 15, leading: 15, bottom: 0, trailing: 0))
        }
    }
}
