//
//  MondoDetials.swift
//  Mondo
//
//  Created by 北川 on 2025/4/28.
//

import SwiftUI

// MARK: 帖子详情
struct MondoDetials: View {
    
    var titleModel: MondoTitleM
    
    @State var showReport: Bool = false
    
    @State var inputCom: String = ""
    
    @EnvironmentObject var pageControl: MondoPageControl
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                Image(titleModel.cover).resizable().scaledToFill()
                    .background(.black)
                    .frame(width: MONDOSCREEN.WIDTH, height: MONDOSCREEN.HEIGHT * 0.4)
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
                        HStack(alignment: .bottom) {
                            Image(titleModel.uHead).resizable().scaledToFill() // 头像
                                .frame(width: 62, height: 62)
                                .clipShape(RoundedRectangle(cornerRadius: 31))
                            Text(titleModel.uName) // 名字
                                .font(.custom("Futura-CondensedExtraBold", size: 16))
                                .foregroundStyle(Color(hex: "#111111"))
                            Spacer()
                            Button(action: { // 发送消息
                                
                            }) { Image("details_send").resizable() }
                                .frame(width: 194, height: 40)
                                .offset(CGSize(width: 10, height: 0))
                        }
                        
                        VStack(alignment: .leading, spacing: 15) {
                            Text(titleModel.topic) // 标题
                                .font(.custom("Futura-CondensedExtraBold", size: 20))
                                .foregroundStyle(Color(hex: "#111111"))
                            Text(titleModel.content) // 内容
                                .font(.custom("PingFangSC-Regular", size: 13))
                                .foregroundStyle(Color(hex: "#333333"))
                        }.padding(.top, 10)
                        
                        MondoTextFielfItem(textInput: $inputCom,
                                           placeholder: "Comment on it",
                                           interval: 15,
                                           backgroundColor: UIColor.white,
                                           textColor: UIColor(hex: "#999999"),
                                           placeholderColor: UIColor(hex: "#999999"),
                                           bordColor: UIColor(hex: "#925EFF"),
                                           font: UIFont(name: "PingFangSC-Medium", size: 14)!,
                                           radius: 8)
                        .frame(height: 40)
                        .padding(.top, 15)
                        
                        Spacer()
                        
                        Button(action: {
                            
                        }) { Image("detailsLike") }
                            .padding(.bottom, 40)
                        
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
                Button(action: { // 举报
                    showReport = true
                }) { Image("btnReport") }
            }.padding(.horizontal, 16)
                .padding(.top, 60)
            if showReport {
                MondoReportItem(isReport: $showReport) {
                    MondoUserVM.shared.monReportList.append(titleModel.mId)
                    MondoUserVM.shared.MondoRemoveLike()
                    MondoUserVM.shared.MondoRemoveFollow()
                }
            }
        }.ignoresSafeArea()
    }
}
