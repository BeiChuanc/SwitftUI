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
    
    @State var currentIndex: Int = 0
    
    var userCurrent = PeppyUserManager.PEPPYGetCurrentDancer()
    
    @EnvironmentObject var loginM: PeppyLoginManager
    
    @EnvironmentObject var peppyRouter: PeppyRouteManager
    
    @ObservedObject var dataManager = PeppyUserDataManager.shared
    
    var body: some View {
        ZStack(alignment: .top) {
            Image("home_bg")
                .resizable()
            VStack {
                Spacer().frame(height: 44)
                
                HStack {
                    PeppyUserHeadContentView(head: loginM.isLogin ? userCurrent.head ?? "" : "head_1",
                                             headBgColor: loginM.isLogin ? userCurrent.headColor ?? "" : "#FFFFFF",
                                             headFrame: 48.0)
                    Text(loginM.isLogin ? userCurrent.kickName ?? "" : "Guest") // 用户名字
                        .font(.custom("Marker Felt", size: 25))
                    Spacer()
                }.frame(width: peppyW - 40, height: 60)
                Spacer()
                    .frame(height: 200)
                ZStack(alignment: .bottom) {
                    Image("row_bg").resizable()
                        .frame(height: 86)
                        .padding(.bottom, 10)
                    VStack() {
                        Image("pets_hi")
                            .frame(width: 87, height: 80)
                        ScrollViewReader { proxy in
                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHGrid(rows: [GridItem(.adaptive(minimum: 80, maximum: 80 * 2))], spacing: 80) {
                                    ForEach(Array(dataManager.animailList.enumerated()), id: \.element.id) { index, animal in
                                        PeppyanimalContentView(animalHead: animal.animalHead, index: index)
                                        .id(index)
                                    }
                                }.padding(.horizontal, (peppyW - 80) / 2)
                            }
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.001, execute: {
                                    proxy.scrollTo(8, anchor: .center)
                                })
                            }
                            .onPreferenceChange(CenterDistancePreferenceKey.self) { preferences in
                                if let closest = preferences.min(by: { $0.distance < $1.distance }), closest.distance < 30 {
                                    currentIndex = closest.index
                                }
                            }
                        }
                    }.frame(width: peppyW, height: 210)
                }
                
                Text(dataManager.animailList.count == 0 ? "" : dataManager.animailList[currentIndex].animalName) // 宠物名字
                    .padding(.top, 10)
                    .font(.custom("Marker Felt", size: 20))
                
                Button(action: { // 聊天按钮
                    if loginM.isLogin {
                        peppyRouter.navigate(to: .CHAT(dataManager.animailList[currentIndex]))
                        return
                    }
                    peppyRouter.navigate(to: .LOGIN)
                }) {
                    Image("btnChat")
                }
                .padding(.top, 20)
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

// MARK: 动物子项
struct PeppyanimalContentView: View {
    
    var animalHead: String
    
    var index: Int
    
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        GeometryReader { geometry in
            let frame = geometry.frame(in: .global)
            let screenCenter = peppyW / 2
            let viewCenter = frame.midX
            let distance = abs(screenCenter - viewCenter)
            let scale = max(1.0, 1.6 - (distance / 200))
            
            Image(animalHead)
                .resizable()
                .frame(width: 80, height: 80)
                .scaleEffect(scale)
                .animation(.interpolatingSpring(stiffness: 300, damping: 30, initialVelocity: 0), value: scale)
                .preference(key: CenterDistancePreferenceKey.self, value: [CenterDistance(index: index, distance: distance)])
        }
        .frame(width: 80, height: 80)
    }
}

struct CenterDistance: Equatable {
    
    let index: Int
    
    let distance: CGFloat
}

// 传递距离和索引信息
struct CenterDistancePreferenceKey: PreferenceKey {
    
    static var defaultValue: [CenterDistance] = []

    static func reduce(value: inout [CenterDistance], nextValue: () -> [CenterDistance]) {
        value.append(contentsOf: nextValue())
    }
}
