//
//  MondoDetilsMe.swift
//  Mondo
//
//  Created by 北川 on 2025/4/28.
//

import SwiftUI
import Kingfisher

// MARK: 自己帖子
struct MondoDetilsMe: View {
    
    var monMeTitle: MondoTitleMeM
    
    @State var monMe = MondoMeM()
    
    @State var inputCom: String = ""
    
    @State var commentData = []
    
    @State var uploadImage: UIImage?
    
    @ObservedObject var monLogin = MondoUserVM.shared
    
    @EnvironmentObject var pageControl: MondoPageControl
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                if monMeTitle.isVideo ?? false {
                    if let image = MondoUserVM.shared.MondoAvVideoThumb(myTitle: monMeTitle) {
                        ZStack {
                            Image(uiImage: image)
                                .resizable().scaledToFill()
                                    .background(.black)
                                    .frame(width: MONDOSCREEN.WIDTH, height: MONDOSCREEN.HEIGHT * 0.4)
                            Image("btnPlay")
                                .buttonStyle(MondoReEffort())
                        }
                    }
                } else {
                    let mediaUrl = URL(fileURLWithPath: monMeTitle.media!)
                    KFImage(mediaUrl).resizable().scaledToFill()
                        .background(.black)
                        .frame(width: MONDOSCREEN.WIDTH, height: MONDOSCREEN.HEIGHT * 0.4)
                }
                Spacer()
            }.background(.clear)
            VStack {
                VStack {}
                    .frame(width: MONDOSCREEN.WIDTH, height: MONDOSCREEN.HEIGHT * 0.35)
                    .background(
                        Color.clear
                            .contentShape(Rectangle())
                    )
                ZStack {
                    Image("details_bg").resizable()
                    VStack {
                        HStack(alignment: .center) {
                            if monMe.head == "monder" { // 头像
                                Image("monder").resizable().scaledToFill() // 头像
                                    .frame(width: 62, height: 62)
                                    .background(.yellow)
                                    .clipShape(RoundedRectangle(cornerRadius: 31))
                            } else {
                                if let image = uploadImage {
                                    Image(uiImage: image).resizable().scaledToFill() // 头像
                                        .frame(width: 62, height: 62)
                                        .background(.yellow)
                                        .clipShape(RoundedRectangle(cornerRadius: 31))
                                }
                            }
                            Text(monMe.name) // 名字
                                .font(.custom("Futura-CondensedExtraBold", size: 16))
                                .foregroundStyle(Color(hex: "#111111"))
                            Spacer()
                        }
                        
                        VStack(alignment: .leading, spacing: 15) {
                            Text(monMeTitle.topic ?? "") // 标题
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.custom("Futura-CondensedExtraBold", size: 20))
                                .foregroundStyle(Color(hex: "#111111"))
                            Text(monMeTitle.content ?? "") // 内容
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.custom("PingFangSC-Regular", size: 13))
                                .foregroundStyle(Color(hex: "#333333"))
                        }.padding(.top, 10)
                        
                        MondoTextFielfItem(textInput: $inputCom,
                                           placeholder: "Comment on it",
                                           interval: 15,
                                           backgroundColor: UIColor.white,
                                           textColor: UIColor(hex: "#111111"),
                                           placeholderColor: UIColor(hex: "#999999"),
                                           bordColor: UIColor(hex: "#925EFF"),
                                           font: UIFont(name: "PingFangSC-Semibold", size: 14)!,
                                           radius: 8)
                        .frame(width: MONDOSCREEN.WIDTH - 32, height: 40)
                        .padding(.top, 15)
                        
                        Spacer()
                    }.frame(width: MONDOSCREEN.WIDTH - 32)
                    .padding(.top, -10)
                    .padding(.horizontal, 32)
                }.frame(width: MONDOSCREEN.WIDTH, height: MONDOSCREEN.HEIGHT * 0.65)
            }
            HStack {
                Button(action: {
                    pageControl.backToLevel()
                }) { Image("backDetails") }
                Spacer()
            }.padding(.horizontal, 16)
                .padding(.top, 60)
        }.ignoresSafeArea()
            .onAppear {
                uploadImage = MondoUserVM.shared.MondoAvHead(uid: MondoCacheVM.MondoAvCurUser().uid)
                monMe = MondoCacheVM.MondoAvCurUser()
            }
    }
}
