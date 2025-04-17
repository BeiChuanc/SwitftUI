//
//  PeppyAnimalFeedPage.swift
//  Peppy
//
//  Created by 北川 on 2025/4/17.
//

import SwiftUI

// MARK: 宠物喂养
struct PeppyAnimalFeedPage: View {
    
    @State var feedProgree: Double = 0
    
    @State var animalHead: String = ""
    
    @State var currentAnimal: Int = 0
    
    @State var animalFeed: [PeppyAnimalMould] = []
    
    @State var isUnlock: Bool = false
    
    @State var unlockFeed: [Int] = []
    
    var currentUser = PeppyUserManager.PEPPYCurrentUser()
    
    var animalFeeds = ["feed_1", "feed_2", "feed_3", "feed_4", "feed_5", "feed_6", "feed_7"]
    
    @EnvironmentObject var loginM: PeppyLoginManager
    
    @EnvironmentObject var peppyRouter: PeppyRouteManager
    
    var body: some View {
        ZStack {
            Image("feed_bg").resizable()
            
            VStack {
                HStack(alignment: .bottom, spacing: 40) {
                    VStack {
                        Spacer()
                        Button(action: { // 前一个
                            guard currentAnimal > 0 else { return }
                            currentAnimal -= 1
                            animalHead = animalFeed[currentAnimal].animalHead
                            loadFeedData()
                        }) {
                            Image("btnPre")
                                .padding(.bottom, 50)
                        }.disabled(currentAnimal == 0)
                    }
                    
                    ZStack {
                        VStack{
                            Image(feedProgree > 70 ? "yummy" : "hungry")
                                .offset(CGSize(width: 50, height: 30))
                            Image(animalFeed.count == 0 ? "" : animalFeed[currentAnimal].animalHead)
                                .resizable()
                                .frame(width: 178, height: 135)
                        }
                        Image("feedUlock").frame(width: 260, height: 40) // 解锁
                            .offset(CGSize(width: 0, height: 32))
                            .opacity(isUnlock ? 0 : 1)
                        
                    }
                    
                    VStack {
                        Spacer()
                        Button(action: { // 后一个
                            guard currentAnimal < animalFeed.count - 1 else { return }
                            currentAnimal += 1
                            loadFeedData()
                        }) {
                            Image("btnNex")
                                .padding(.bottom, 50)
                        }
                        .disabled(currentAnimal == animalFeed.count - 1)
                    }
                }.frame(height: 176)
                    .padding(.horizontal, 20)
                HStack {
                    Image("level")
                    Spacer()
                }.padding(.horizontal, 20)
                
                CustomProgressBar(progress: feedProgree) // 进度条
                    .padding(.horizontal, 20)
                
                ZStack { // 食物选择
                    Image("feed_line")
                        .resizable()
                        .frame(height: 50)
                    ScrollViewReader { proxy in
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHGrid(rows: [GridItem(.fixed(50))], spacing: 35) {
                                ForEach(Array(animalFeeds.enumerated()), id: \.offset) { index, feed in
                                    FeedAnimalItem(feedIndex: index)
                                        .id(index)
                                }
                            }.padding(.horizontal, (peppyW - 50) / 2)
                        }
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.001, execute: {
                                proxy.scrollTo(3, anchor: .center)
                            })
                        }
                    }
                }.frame(width: peppyW, height: 80)
                .padding(.top, 50)
                
                Button(action: { // 喂养
                    guard loginM.isLogin else {
                        peppyRouter.navigate(to: .LOGIN)
                        return
                    }
                    
                    guard isUnlock else {
                        PeppyLoadManager.peppyProgressSymbol(text: "You haven't unlocked this pet yet.")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            peppyRouter.popRoot()
                        }
                        return
                    }
                    
                    if feedProgree == 100 {
                        PeppyLoadManager.peppyProgressSymbol(text: "\(animalFeed[currentAnimal].animalName) is already full.")
                        return
                    }
                    feedProgree += 10
                    PeppyUserManager.PEPPYUpdateUserDetails { pey in
                        for (index, dict) in pey.culAnimalList!.enumerated() {
//                            if dict.keys.contains(currentAnimal) {
//                                pey.culAnimalList![index][currentAnimal] = feedProgree
//                                break
//                            }
                            print("第\(index)个的,\(dict.keys)")
                        }
                        return pey
                    }
                }) {
                    Image(isUnlock ? "btnFeed" : "btnUnlock")
                        .padding(.top, 50)
                }
                
                Spacer()
            }.padding(.top, 120)
        }.ignoresSafeArea()
            .onAppear {
                animalFeed = PeppyUserDataManager.shared.animailList
                if loginM.isLogin {
                    unlockFeed = PeppyChatDataManager.shared.peppyGetMessageList()
                    loadFeedData()
                }
            }
    }
    
    func loadFeedData() {
        isUnlock = unlockFeed.contains(animalFeed[currentAnimal].animalId)
        for an in currentUser.culAnimalList! {
            if let pro = an[currentAnimal] {
                feedProgree = pro
            }
        }
    }
}

// MARK: 喂养进度条
struct CustomProgressBar: View {
    
    let progress: Double
    
    let barColor: Color = Color(hex: "#FFC208")
    
    let containerColor: Color = Color.white

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                       .fill(containerColor)
                       .frame(height: 20)
                    Rectangle()
                       .fill(barColor)
                       .frame(width: CGFloat(progress) / 100 * (peppyW - 40), height: 12)
                       .padding(.horizontal, 4)
                       .animation(.easeInOut(duration: 1), value: progress)
                }
               .background(containerColor)
            }
            HStack {
                GeometryReader { geometry in
                    if progress < 100 {
                        Text("\(Int(progress))%")
                            .font(.custom("Marker Felt", size: 18))
                            .foregroundColor(.white)
                            .offset(x: min(CGFloat(progress) / 100 * geometry.size.width, geometry.size.width - 40))
                            .animation(.easeInOut(duration: 1), value: progress)
                    }
                }
                Spacer()
                Text("100%")
                    .font(.custom("Marker Felt", size: 18))
                    .foregroundColor(.white)
            }
            Spacer()
        }.frame(height: 60)
    }
}

// MARK: 喂养动物
struct FeedAnimalItem: View {
    
    var feedIndex: Int
    
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                let frame = geometry.frame(in: .global)
                let screenCenter = peppyW / 2
                let viewCenter = frame.midX
                let distance = abs(screenCenter - viewCenter)
                let scale = max(1.0, 1.6 - (distance / 200))
                
                Image("feed_\(feedIndex + 1)")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .scaleEffect(scale)
                    .animation(.interpolatingSpring(stiffness: 300, damping: 30, initialVelocity: 0), value: scale)
                    .preference(key: CenterDistancePreferenceKey.self, value: [CenterDistance(index: feedIndex, distance: distance)])
            }
            .frame(width: 50, height: 50)
        }
    }
}
