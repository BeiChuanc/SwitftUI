//
//  MondoDiscover.swift
//  Mondo
//
//  Created by 北川 on 2025/4/27.
//

import SwiftUI

// MARK: 指南
enum GUIDETYPE {
    
    case SAFE
    
    case EQUIP
    
    case PROBLEM
}

// MARK: Color
enum WISHCOLOR {
    
    static let ONE = "#FFF564"
    
    static let TWO = "#FFECC3"
}

// MARK: 发现页
struct MondoDiscover: View {
    
    var wishPool = ["1", "2"]
    
    @State var wishMes: String = ""
    
    @State var showWish: Bool = false
    
    @State var guideType: GUIDETYPE = .SAFE
    
    @EnvironmentObject var pageControl: MondoPageControl
    
    var body: some View {
        ZStack {
            Image("discover_bg").resizable()
            VStack {
                HStack {
                    Image("top_find")
                    Spacer()
                }.padding(.top, 60)
                ScrollView(showsIndicators: false) {
                    Button(action: {
                        withAnimation(.interactiveSpring(duration: 0.5, extraBounce: 0.2)) {
                            showWish.toggle()
                        }
                    }) // 许愿
                    { Image("btnWish").resizable().scaledToFill()
                        .frame(width: MONDOSCREEN.WIDTH - 32) }
                        .buttonStyle(MondoReEffort())
                    ZStack {
                        Image("wishCon").resizable().scaledToFill()
                            .frame(width: MONDOSCREEN.WIDTH - 32)
                            .offset(CGSize(width: 0, height: -10))
                        // 许愿池
                        ScrollView(.horizontal, showsIndicators: false) {
                            
                        }
                    }
                    HStack {
                        Image("guide_im").padding(.top, 5)
                        Spacer()
                    }
                    VStack(spacing: 12) {
                        Button(action: { // 安全
                            guideType = .SAFE
                            goGuide(type: guideType, model: MondoGuideM(topTitle: "guide_safe",
                                                                        showBg: "safe_bg",
                                                                        showContent: "safe_content"))
                        }) { Image("Scrue").resizable().scaledToFill()
                            .frame(width: MONDOSCREEN.WIDTH - 32) }
                        .buttonStyle(MondoReEffort())
                        Button(action: { // 装备
                            guideType = .EQUIP
                            goGuide(type: guideType, model: MondoGuideM(topTitle: "guide_eqip",
                                                                        showBg: "eqip_bg",
                                                                        showContent: "equip_content"))
                        }) { Image("Equip").resizable().scaledToFill()
                            .frame(width: MONDOSCREEN.WIDTH - 32) }
                        .buttonStyle(MondoReEffort())
                        Button(action: { // 问题
                            guideType = .PROBLEM
                            goGuide(type: guideType, model: MondoGuideM(topTitle: "guide_problem",
                                                                        showBg: "problem_bg",
                                                                        showContent: "problem_content"))
                        }) { Image("problem").resizable().scaledToFill()
                            .frame(width: MONDOSCREEN.WIDTH - 32) }
                        .buttonStyle(MondoReEffort())
                        Rectangle()
                            .fill(.clear)
                            .frame(height: 130)
                    }
                }
                .padding(.top, 20)
            }.padding(.horizontal, 16)
            if showWish {
                ZStack(alignment: .top) {
                    ZStack {}
                        .frame(width: MONDOSCREEN.WIDTH, height: MONDOSCREEN.HEIGHT)
                        .background(
                            Color(hex: "#111111", alpha: 0.5)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    withAnimation(.interactiveSpring(duration: 0.5, extraBounce: 0.2)) {
                                        showWish.toggle()
                                    }
                                }
                        )
                    ZStack {
                        Image("wish_bgh").resizable().frame(height: 120)
                        VStack(spacing: 15) {
                            HStack {
                                Image("wishTitle")
                                Spacer()
                            }
                            HStack {
                                MondoTextFielfItem(textInput: $wishMes,
                                                   placeholder: "Input",
                                                   interval: 15,
                                                   backgroundColor: UIColor.white,
                                                   textColor: UIColor(hex: "#925EFF", alpha: 0.2),
                                                   placeholderColor: UIColor(hex: "#925EFF", alpha: 0.2),
                                                   bordColor: UIColor(hex: "#925EFF"),
                                                   font: UIFont(name: "PingFangSC-Medium", size: 14)!,
                                                   radius: 8)
                                .frame(height: 30)
                            }
                            HStack {
                                Spacer()
                                Button(action: {
                                    showWish.toggle()
                                }) {  Image("wish_release") }
                            }
                        }.padding(.horizontal, 16)
                    }.padding(.top, 200)
                        .padding(.horizontal, 16)
                }.ignoresSafeArea()
                .transition(.asymmetric(
                    insertion: .move(edge: .top),
                    removal: .move(edge: .top)
                        ))
                .zIndex(1)
            }
        }.ignoresSafeArea()
            .zIndex(showWish ? 1 : 0)
    }
    
    func goGuide(type: GUIDETYPE, model: MondoGuideM) {
        pageControl.route(to: .GUIDE(model))
    }
}

// MARK: 许愿Item
struct MondoWishItem: View {
    
    var wishModel: MondoWishM
    
    var body: some View {
        HStack(spacing: 10) {
            Image("")
                .resizable().scaledToFill()
                .frame(width: 30, height: 30)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .padding(.leading, 10)
            VStack {
                Text(wishModel.content)
                    .frame(maxWidth: 100)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                    .font(.custom("PingFangSC-Medium", size: 12))
                    .foregroundStyle(Color(hex: "#111111"))
            }.padding(.trailing, 10)
        }
    }
}

// MARK: 指南
struct MondoGuide: View {
    
    var guideModel: MondoGuideM
    
    @EnvironmentObject var pageControl: MondoPageControl
    
    var body: some View {
        VStack {
            HStack {
                Button(action: { pageControl.backToLevel() }) { Image("guide_back") }
                Image(guideModel.topTitle)
                Spacer()
            }.padding(.top, 60)
                .padding(.horizontal, 12)
            ScrollView(showsIndicators: false) {
                Image(guideModel.showContent).resizable()
                    .padding(.horizontal, 12)
            }
        }
        .background(content: { Image(guideModel.showBg).resizable().scaledToFill() })
        .ignoresSafeArea()
    }
}
