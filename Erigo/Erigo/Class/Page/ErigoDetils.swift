//
//  ErigoDetils.swift
//  Erigo
//
//  Created by 北川 on 2025/4/21.
//

import SwiftUI

// MARK: 详情页
struct ErigoDetils: View {
    
    @State var mediaArr: [ErigoMeidiaM] = []
    
    let colors: [Color] = [.red, .green, .blue, .yellow]
    
    @State var currentPage: Int = 0
    
    @State var colorGroup: [String] = []
    
    @State var viewCount: Int = 0
    
    @State var likeS: Int = 0
    
    var colorRow: Int {
        let itemsPerRow = 8
        return Int(ceil(Double(colorGroup.count) / Double(itemsPerRow)))
    }
    
    var colorH: CGFloat {
        let salary = colorGroup.count / 8
        let isSingleOrNoRow = salary == 0 || salary == 1
        
        if isSingleOrNoRow {
            return 16.0
        } else {
            let firstPart = CGFloat(salary) * 16.0
            let secondPart = CGFloat(salary - 1) * 15.0
            return firstPart + secondPart
        }
    }
    
    var body: some View {
        ZStack {
            VStack {
                ZStack (alignment: .bottomLeading) {
                    TabView(selection: $currentPage) {
                        ForEach(0..<colors.count, id: \.self) { index in
                            colors[index]
                                .tag(index)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    .onChange(of: currentPage) { newValue in }
                    
                    ErigoDetilsIndicator(currentPage: $currentPage,
                                         totalPages: colors.count,
                                         selectColor: .white,
                                         normalColor: Color(hes: "#FFFFFF", alpha: 0.4),
                                         selectW: 24, normalW: 9, normalH: 4)
                        .padding(.leading, 20)
                        .padding(.bottom, 55)
                }.frame(width: ERIGOSCREEN.WIDTH, height: ERIGOSCREEN.HEIGHT * 0.45)
                
                ZStack {
                    Image("title_bg")
                        .resizable()
                        .offset(CGSize(width: 0, height: -40))
                    
                    VStack {
                        HStack(spacing: 15) { // 人物
                            Image("")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .background(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 25))
                            Text("") // 用户名
                                .font(.custom("Futura-CondensedExtraBold", size: 18))
                                .foregroundStyle(.white)
                            Spacer()
                            Button(action: {
                                
                            }) {
                                Image("btnLike")
                                    .resizable()
                                    .frame(width: 34, height: 34)
                            }
                        }.padding(.top, 20)
                            .padding(.horizontal, 20)
                        
                        Text("") // 内容
                            .font(.custom("PingFangSC-Medium", size: 18))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 20)
                            .padding(.top, 10)
                        
                        VStack(alignment: .leading) {
                            HStack {
                                VStack {
                                    Image("colorPint")
                                    Spacer()
                                }
                                VStack(alignment: .leading) {
                                    ForEach(Array(0..<colorRow), id: \.self) { row in // 3行
                                        HStack(spacing: 0) {
                                            ForEach(0..<min(8, colorGroup.count - row * 8), id: \.self) { col in // 8列
                                                let index = row * 8 + col
                                                Rectangle()
                                                    .fill(Color(hes: colorGroup[index]))
                                                    .frame(width: 30, height: 16)
                                            }
                                        }
                                    }
                                    Spacer()
                                }
                                Spacer()
                            }.frame(height: colorH)
                            HStack {
                                Image("viewU")
                                Text("\(viewCount) views") // 浏览次数
                                    .font(.custom("PingFangSC-Regular", size: 13))
                                    .foregroundStyle(Color(hes: "#999999"))
                            }
                            HStack {
                                Image("likeU")
                                Text("\(likeS) like") // 喜欢人数
                                    .font(.custom("PingFangSC-Regular", size: 13))
                                    .foregroundStyle(Color(hes: "#999999"))
                            }
                            Spacer()
                        }.padding(.horizontal, 20)
                        VStack(spacing: 10) {
                            Image("sayHi")
                            Button(action: {
                                
                            }) {
                                Image("sendMes")
                            }
                        }.padding(.bottom, ERIGOSCREEN.HEIGHT * 0.15)
                        
                    }
                }.frame(width: ERIGOSCREEN.WIDTH, height: ERIGOSCREEN.HEIGHT * 0.65)
                
                Spacer()
            }
            HStack { // 返回
                Button(action: {}) {
                    Image("global_back")
                }
                Spacer()
                Button(action: {}) { // 举报
                    Image("btnReport")
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, ERIGOSCREEN.HEIGHT * 0.8)
        }
        .frame(width: ERIGOSCREEN.WIDTH,
                height: ERIGOSCREEN.HEIGHT)
         .ignoresSafeArea()
         .background(.black)
         .onAppear {
             colorGroup = []
         }
    }
}

#Preview {
    ErigoDetils()
}

// MARK: 指示器
struct ErigoDetilsIndicator: View {
    
    @Binding var currentPage: Int
    
    let totalPages: Int
    
    var selectColor: Color
    
    var normalColor: Color
    
    var selectW: CGFloat
    
    var normalW: CGFloat
    
    var normalH: CGFloat
    
    var isEffect: Bool = false
    
    var body: some View {
        if isEffect {
            ZStack {
                HStack(spacing: 8) {
                    ForEach(0..<totalPages, id: \.self) { index in
                        RoundedRectangle(cornerRadius: 4)
                            .fill(index == currentPage ? selectColor : normalColor)
                            .frame(width: index == currentPage ? selectW : normalW, height: normalH)
                    }
                }
            }
            .padding(EdgeInsets(top: 4, leading: 6, bottom: 4, trailing: 6))
            .background(
                // 添加高斯模糊效果
                VisualEffectView(effect: UIBlurEffect(style:.systemMaterial))
                    .cornerRadius(10)
            )
        } else {
            HStack(spacing: 8) {
                ForEach(0..<totalPages, id: \.self) { index in
                    RoundedRectangle(cornerRadius: 4)
                        .fill(index == currentPage ? selectColor : normalColor)
                        .frame(width: index == currentPage ? selectW : normalW, height: normalH)
                }
            }
        }
    }
}

// MARK: 媒体Item
struct ErigoMeidiaItem: View {
    var body: some View {
        VStack {
            
        }
    }
}

// MARK: 高斯模糊
struct VisualEffectView: UIViewRepresentable {
    let effect: UIBlurEffect?
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: effect)
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = effect
    }
}
