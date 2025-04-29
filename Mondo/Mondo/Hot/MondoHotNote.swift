//
//  MondoHotNote.swift
//  Mondo
//
//  Created by 北川 on 2025/4/27.
//

import SwiftUI

// MARK: 热门笔记
struct MondoHotNote: View {
    
    @EnvironmentObject var pageControl: MondoPageControl
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            ZStack {
                Image("notes_bg").resizable().scaledToFill()
                VStack {
                    HStack {
                        Button(action: { pageControl.backToLevel() }) // 返回
                        { Image("titleBack").resizable().frame(width: 30, height: 30) }
                        Spacer()
                    }
                    HStack {
                        Image("ranking")
                        Spacer()
                    }
                    HStack {
                        Image("popular_notes")
                        Spacer()
                    }.padding(.top, 12)
                    Image("notes_top").padding(.top, 70)
                    ForEach(0..<3) { item in
                        MondoOfficeItem()
                    }
                    Spacer()
                }.padding(.top, 60)
                    .padding(.horizontal, 16)
            }.ignoresSafeArea()
                .frame(width: MONDOSCREEN.WIDTH, height: 1250)
        }
    }
}

// MARK: 官方帖子Item
struct MondoOfficeItem: View {
    
    @State var inputCom: String = ""
    
    @State var isLike: Bool = false
    
    var body: some View {
        VStack {
            VStack {
                ZStack(alignment: .top) {
                    Image("ranking_pic1").resizable().frame(height: 180)
                    HStack(spacing: 12) {
                        ZStack {
                            Image("ranking_firebg").resizable().frame(width: 100, height: 40)
                            HStack {
                                Image("ranking_fire")
                                Text("999") // 热度
                                    .font(.custom("PingFangSC-Semibold", size: 18))
                                    .foregroundStyle(Color(hex: "#4A1500"))
                            }.offset(CGSize(width: -5, height: 0))
                        }
                        Image("") // 推荐头像
                            .scaledToFill()
                            .frame(width: 40, height: 40).background(.white).clipShape(RoundedRectangle(cornerRadius: 20))
                        Text("Jack")
                            .font(.custom("Futura-CondensedExtraBold", size: 16))
                            .foregroundStyle(.white)
                        Spacer()
                    }.padding(.top, 12)
                }
                VStack {
                    ZStack {
                        Text("Sharing the journey and the stunning views with friends makes the climb worth every step.")
                            .font(.custom("PingFangSC-Medium", size: 15))
                            .foregroundStyle(Color(hex: "#4A1500"))
                            .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                    }.frame(width: MONDOSCREEN.WIDTH - 32)
                    .background(Color(hex: "#FEF564"))
                    HStack {
                        MondoTextFielfItem(textInput: $inputCom,
                                           placeholder: "Say Something",
                                           interval: 15,
                                           backgroundColor: UIColor(hex: "#F2F2F2"),
                                           textColor: UIColor(hex: "#111111"),
                                           placeholderColor: UIColor(hex: "#999999"),
                                           font: UIFont(name: "PingFangSC-Medium", size: 14)!,
                                           radius: 15)
                        .frame(height: 30)
                        Button(action: { // 点赞
                            isLike.toggle()
                        }) { Image(isLike ? "btnLike_select" : "btnLike") }
                    }.padding(.bottom, 15)
                }
            }
        }
        .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
