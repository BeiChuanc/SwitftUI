//
//  PeppyRankingPage.swift
//  Peppy
//
//  Created by 北川 on 2025/4/17.
//

import SwiftUI

// MARK: 排行
struct PeppyRankingPage: View {
    
    @State var animalStar: [PeppyAnimalMould] = []
    
    @State var mostStar: Int = 0
    
    @State var secondStar: Int = 0
    
    @State var thirdStar: Int = 0
    
    @State var fourStar: Int = 0
    
    @State var fiveStar: Int = 0
    
    @EnvironmentObject var loginM: PeppyLoginManager
    
    @EnvironmentObject var peppyRouter: PeppyRouteManager
    
    var body: some View {
        ZStack {
            Image("ranking_bg")
                .resizable()
            VStack {
                HStack {
                    Button(action: {
                        peppyRouter.pop()
                    }) {
                        Image("btnBac")
                            .frame(width: 30, height: 30)
                    }
                    Spacer()
                }.padding(.top, 50)
                    .padding(.horizontal, 20)
                ZStack {
                    Image("row_bg").resizable()
                        .frame(height: 80)
                        .offset(CGSize(width: 0, height: 20))
                    Image(animalStar.count == 0 ? "" : animalStar[0].animalHead) // 最多
                        .frame(width: 112, height: 85)
                        .offset(CGSize(width: 0, height: 25))
                    Image("anmalK")
                        .offset(CGSize(width: 20, height: -15))
                }.frame(height: 120)
                
                TextWithHighlight(mainText: "The First!  \(mostStar) People \n Have Unlocked It",
                                  highlightText: "\(mostStar)",
                                  highlightColor: .red,
                                  fontName: "Marker Felt",
                                  fontSize: 18,
                                  defaultColor: .white)
                .multilineTextAlignment(.center)
                .padding(.top, 20)
                
                HStack(spacing: 30) {
                    VStack { // 第二
                        Image(animalStar.count == 0 ? "" : animalStar[1].animalHead)
                            .frame(width: 72, height: 72)
                        HStack(alignment: .bottom) {
                            Image("anmalStar")
                            Text("NO.2")
                                .font(.custom("Marker Felt", size: 18))
                                .foregroundStyle(.white)
                        }
                        TextWithHighlight(mainText: "\(secondStar)  Unlocked!",
                                          highlightText: "\(secondStar) ",
                                          highlightColor: Color(hex: "#F4C343"),
                                          fontName: "Marker Felt",
                                          fontSize: 18,
                                          defaultColor: .white)
                    }
                    VStack { // 第三
                        Image(animalStar.count == 0 ? "" : animalStar[2].animalHead)
                            .frame(width: 72, height: 72)
                        HStack(alignment: .bottom) {
                            Image("anmalStar")
                            Text("NO.3")
                                .font(.custom("Marker Felt", size: 18))
                                .foregroundStyle(.white)
                        }
                        TextWithHighlight(mainText: "\(thirdStar)  Unlocked!",
                                          highlightText: "\(thirdStar) ",
                                          highlightColor: Color(hex: "#F4C343"),
                                          fontName: "Marker Felt",
                                          fontSize: 18,
                                          defaultColor: .white)
                    }
                }.padding(.top, 30)
                
                HStack (alignment: .center) { // 第四
                    Image(animalStar.count == 0 ? "" : animalStar[3].animalHead)
                        .frame(width: 68, height: 68)
                    Text("NO.4")
                        .font(.custom("Marker Felt", size: 18))
                        .foregroundStyle(.white)
                        .padding(.leading, 10)
                    Spacer()
                    Text("\(fourStar)  Unlocked!")
                        .font(.custom("Marker Felt", size: 18))
                        .foregroundStyle(.white)
                }.padding(.top, 40)
                    .padding(.horizontal, 20)
                
                HStack (alignment: .center) { // 第五
                    Image(animalStar.count == 0 ? "" : animalStar[4].animalHead)
                        .frame(width: 68, height: 68)
                    Text("NO.5")
                        .font(.custom("Marker Felt", size: 18))
                        .foregroundStyle(.white)
                        .padding(.leading, 10)
                    Spacer()
                    Text("\(fourStar)  Unlocked!")
                        .font(.custom("Marker Felt", size: 18))
                        .foregroundStyle(.white)
                }.padding(.top, 40)
                    .padding(.horizontal, 20)
                
                Button(action: {
                    if loginM.isLogin {
                        peppyRouter.popRoot()
                    } else {
                        peppyRouter.navigate(to: .LOGIN)
                    }
                }) {
                    Image("btnUnlock")
                        .padding(.top, 40)
                }
                
                Spacer()
            }
        }.ignoresSafeArea()
            .onAppear {
                animalStar = PeppyUserDataManager.shared.peppyAvFrontFive() // 填充数据
                mostStar = animalStar[0].animalStar
                secondStar = animalStar[1].animalStar
                thirdStar = animalStar[2].animalStar
                fourStar = animalStar[3].animalStar
                fiveStar = animalStar[4].animalStar
            }
    }
}

// MARK: 高亮文本
struct TextWithHighlight: View {
    
    let mainText: String
    
    let highlightText: String
    
    let highlightColor: Color
    
    let fontName: String
    
    let fontSize: CGFloat
    
    let defaultColor: Color

    var body: some View {
        var attributedString = AttributedString(mainText)
        if let range = mainText.range(of: highlightText) {
            let attributedRange = Range(range, in: attributedString)!
            attributedString[attributedRange].foregroundColor = highlightColor
        }
        
        return Text(attributedString)
            .font(.custom(fontName, size: fontSize))
            .foregroundStyle(defaultColor)
    }
}
