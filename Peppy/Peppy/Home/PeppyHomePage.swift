//
//  PeppyHomeContentView.swift
//  Peppy
//
//  Created by 北川 on 2025/4/9.
//

import SwiftUI

// MARK: 首页
struct PeppyHomePage: View {
    var body: some View {
        PeppyHomeContentView()
    }
}

struct PeppyHomeContentView: View {
    
    @State var currentIndex: Int?
    @State private var scrollOffset: CGFloat = 0
    
    @EnvironmentObject var loginM: PeppyLoginManager
    
    @EnvironmentObject var peppyRouter: PeppyRouteManager
    
    @ObservedObject var dataManager = PeppyUserDataManager.shared
    
    var body: some View {
        ZStack(alignment: .top) {
            Image("home_bg")
                .resizable()
            VStack {
                Spacer().frame(height: 44)
                HStack() {
                    ZStack(alignment: .topLeading) {
                        Image("UserHead_bg")
                            .resizable()
                            .frame(width: 48, height: 48)
                        Image("Placeholder")
                            .frame(width: 40.0, height: 40.0)
                            .background(Color.red) // 用户头像底色
                            .border(.black, width: 1)
                        Image("head_1") // 用户头像
                            .resizable()
                            .padding(.all, 2.0)
                            .frame(width: 40.0, height: 40.0)
                    }
                    .frame(width: 48, height: 48)
                    .padding(.trailing, 10)
                    Text(loginM.isLogin ? "" : "Guest") // 用户名字
                        .font(.custom("Marker Felt", size: 25))
                    Spacer()
                }.frame(width: peppyW - 40, height: 60)
                
                Spacer()
                    .frame(height: 200)
                ZStack(alignment: .bottom) {
                    HStack {}.frame(width: peppyW, height: 100)
                        .background(Color(hex: "#F54337"))
                        .padding(.bottom, 10)
                    VStack() {
                        Image("pets_hi")
                            .frame(width: 87, height: 80)
                        ScrollViewReader { proxy in
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 60) {
                                    ForEach(Array(dataManager.animailList.enumerated()), id: \.element.id) { index, animal in
                                        PeppyanimalContentView(animalHead: animal.animalHead, onCenter: { isCenter in
                                            if isCenter {
                                                currentIndex = index
                                                print("当前索引值:", currentIndex ?? "nil")
                                            }
                                        })
                                            .id(index)
                                    }
                                }
                                .padding(.horizontal, (peppyW - 80) / 2)
                                .frame(height: 120)
                            }
                            .scrollTargetBehavior(.viewAligned)
                            .scrollTargetLayout()
                        }
                    }.frame(width: peppyW, height: 210)
                }
                
                Text(currentIndex != nil ? dataManager.animailList[currentIndex!].animalName : "") // 宠物名字
                    .padding(.top, 20)
                    .font(.custom("Marker Felt", size: 20))
                
                Button(action: { // 聊天按钮
                    if loginM.isLogin {
                        print("聊天啰")
                    } else {
                        peppyRouter.navigate(to: .PLAYMEDIA)
                    }
                }) {
                    Image("btnChat")
                }
                .padding(.top, 20)
            }
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            print("当前登陆状态:\(loginM.isLogin)")
            currentIndex = 0
        }
    }
}

// MARK: 动物子项
struct PeppyanimalContentView: View {
    var animalHead: String
    var onCenter: (Bool) -> Void
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        GeometryReader { geometry in
            let frame = geometry.frame(in: .global)
            let screenCenter = peppyW / 2
            let viewCenter = frame.midX
            let distance = abs(screenCenter - viewCenter)
            let scale = max(1.0, 1.5 - (distance / 200))
            
            Image(animalHead)
                .resizable()
                .frame(width: 80, height: 80)
                .scaleEffect(scale)
                .animation(.interpolatingSpring(stiffness: 300, damping: 30, initialVelocity: 0), value: scale)
                .onChange(of: distance) { newDistance in
                    onCenter(newDistance < 40) // 当距离小于40时认为在中心
                }
        }
        .frame(width: 80, height: 80)
    }
}
