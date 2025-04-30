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
    
    let scrollSpeed: CGFloat = 0.8
    
    @State private var offset: CGFloat = 0
    
    @State var wishMes: String = ""
    
    @FocusState var isWish: Bool
    
    @State var showWish: Bool = false
    
    @State var guideType: GUIDETYPE = .SAFE
    
    @State var wishModel: [MondoWishM] = []
    
    @State private var isAnimating = true
    
    var wishLItems: [(index: Int, element: MondoWishM)] {
        wishModel.enumerated()
            .filter { $0.offset.isMultiple(of: 2) }
            .map { (index: $0.offset, element: $0.element) }
    }

    var wishRItems: [(index: Int, element: MondoWishM)] {
        wishModel.enumerated()
            .filter { !$0.offset.isMultiple(of: 2) }
            .map { (index: $0.offset, element: $0.element) }
    }
    
    var monMe = MondoCacheVM.MondoAvCurUser()
    
    @ObservedObject var monLogin = MondoUserVM.shared
    
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
                        VStack(spacing: 20) {
                            HStack(spacing: 20) {
                                ForEach(wishLItems, id: \.element) { item in
                                    MondoWishItem(wishModel: item.element)
                                }
                            }
                            .offset(x: offset)
                            .frame(width: MONDOSCREEN.WIDTH - 42)
                            .onAppear {
                                isAnimating = true
                            }
                            
                            HStack(spacing: 20) {
                                ForEach(wishRItems, id: \.element) { item in
                                    MondoWishItem(wishModel: item.element)
                                }
                            }
                            .offset(x: offset + 80) // 错位10个点
                            .frame(width: MONDOSCREEN.WIDTH - 42)
                            .onAppear {
                                isAnimating = true
                            }
                        }
                        .padding(.top, -30)
                        .onAppear {
                            isAnimating = true
                        }
                        .onReceive(Timer.publish(every: 0.01, on:.main, in:.common).autoconnect(), perform: { _ in
                            if isAnimating {
                                offset -= scrollSpeed
                                if offset <= -(MONDOSCREEN.WIDTH - 42) {
                                    offset = 0
                                }
                            }
                        })
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
                                .frame(width: MONDOSCREEN.WIDTH - 72, height: 30)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color(hex: "#925EFF"), lineWidth: 1)
                                )
                                .focused($isWish)
                            }
                            HStack {
                                Spacer()
                                Button(action: {
                                    guard !wishMes.isEmpty else { isWish = true
                                        return }
                                    if monLogin.loginIn {
                                        MondoUserVM.shared.MondoSvWish(wish: MondoWishM(uid: monMe.uid, content: wishMes))
                                        showWish.toggle()
                                        MondoReloadWish()
                                        wishMes = ""
                                    } else {
                                        pageControl.route(to: .LOGIN)
                                    }
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
            .onAppear {
                MondoReloadWish()
            }
    }
    
    func goGuide(type: GUIDETYPE, model: MondoGuideM) {
        pageControl.route(to: .GUIDE(model))
    }
    
    func MondoReloadWish() {
        wishModel = MondoUserVM.shared.MondoWish()
        print("许愿池子数据:\(wishModel)")
    }
}

// MARK: 许愿Item
struct MondoWishItem: View {
    
    var wishModel: MondoWishM
    
    var monMe = MondoCacheVM.MondoAvCurUser()
    
    @State var uploadImage: UIImage?
    
    @ObservedObject var monLogin = MondoUserVM.shared
    
    var body: some View {
        HStack(spacing: 10) {
            if wishModel.uid == monMe.uid {
                if let image = uploadImage {
                    Image(uiImage: image).resizable().scaledToFill()
                        .frame(width: 30, height: 30)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .padding(.leading, 10)
                } else {
                    Image("monder").resizable().scaledToFill()
                        .frame(width: 30, height: 30)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .padding(.leading, 10)
                }
            } else {
                Image("mondoer\(wishModel.uid - 9)")
                    .resizable().scaledToFill()
                    .frame(width: 30, height: 30)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .padding(.leading, 10)
            }
            VStack {
                Text(wishModel.content)
                    .frame(maxWidth: 100)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                    .font(.custom("PingFangSC-Medium", size: 11))
                    .foregroundStyle(Color(hex: "#111111"))
            }.padding(.trailing, 10)
        }.onAppear {
            if monLogin.loginIn {
                uploadImage = MondoUserVM.shared.MondoAvHead(uid: monMe.uid)
            }
        }
        .frame(width: 166, height: 40)
        .background(Color(hex: wishModel.uid % 2 == 0 ? "#FFF564" : "#FFECC3"))
        .clipShape(RoundedRectangle(cornerRadius: 20))
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
