//
//  ErigoDetils.swift
//  Erigo
//
//  Created by 北川 on 2025/4/21.
//

import SwiftUI
import Kingfisher

// MARK: 详情页
struct ErigoDetils: View {
    
    var titleModel: ErigoEyeTitleM
    
    @State var randCount: Int = 0
    
    @State var isLike: Bool = false
    
    @State var headImage: UIImage?
    
    @State var isSendGift: Bool = false
    
    @State var isHiddenSend: Bool = false
    
    @State var loginUser = ErigoUserM()
    
    @State var giftList: [ErigoStoreM] = []
    
    @ObservedObject var LoginVM = ErigoLoginVM.shared
    
    @EnvironmentObject var router: ErigoRoute
    
    var colorRow: Int {
        let itemsPerRow = 8
        return Int(ceil(Double((titleModel.colors ?? []).count) / Double(itemsPerRow)))
    }
    
    var colorH: CGFloat {
        let salary = (titleModel.colors ?? []).count / 8
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
                ZStack (alignment: .center) {
                    if (titleModel.bid ?? 0) == ErigoUserDefaults.ErigoAvNowUser().uerId ?? 0 {
                        if titleModel.type == 0 {
                            if let image = LoginVM.ErigoLoadMyCover(item: titleModel) {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: ERIGOSCREEN.WIDTH, height: ERIGOSCREEN.HEIGHT * 0.45)
                            }
                        } else {
                            let mediaUrl = URL(fileURLWithPath: titleModel.media!)
                            KFImage(mediaUrl)
                                .resizable()
                                .scaledToFill()
                                .frame(width: ERIGOSCREEN.WIDTH, height: ERIGOSCREEN.HEIGHT * 0.45)
                        }
                        
                    } else {
                        Image(titleModel.cover ?? "")
                            .resizable()
                            .scaledToFill()
                            .frame(width: ERIGOSCREEN.WIDTH, height: ERIGOSCREEN.HEIGHT * 0.45)
                    }
                    Image("btnPlay").opacity(titleModel.type == 0 ? 1 : 0)
                }
                .onTapGesture { // 媒体展示页
                    router.naviTo(to: .SHOW(titleModel))
                }
                
                ZStack {
                    Image("title_bg")
                        .resizable()
                        .offset(CGSize(width: 0, height: -40))
                    
                    VStack {
                        HStack(spacing: 15) { // 人物
                            
                            if (titleModel.bid ?? 0) == ErigoUserDefaults.ErigoAvNowUser().uerId ?? 0 {
                                if let head = loginUser.head {
                                    if head == "head_de" {
                                        Image("head_de")
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 70, height: 70)
                                            .clipShape(RoundedRectangle(cornerRadius: 35))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 35)
                                                    .stroke(.black, lineWidth: 1)
                                            )
                                    } else {
                                        if let image = headImage {
                                            Image(uiImage: image)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 64, height: 64)
                                                .clipShape(RoundedRectangle(cornerRadius: 32))
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 32)
                                                        .stroke(.white, lineWidth: 1)
                                                )
                                        }
                                    }
                                }
                            } else {
                                Image("eye_\(titleModel.bid ?? 0)")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 50, height: 50)
                                    .background(.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 25))
                            }
                            Text(titleModel.name ?? "") // 用户名
                                .font(.custom("Futura-CondensedExtraBold", size: 18))
                                .foregroundStyle(.white)
                            Spacer()
                            Button(action: { // 喜欢
                                if LoginVM.landComplete {
                                    if LoginVM.ErigoIsLike(tid: titleModel.tid!) {
                                        ErigoUserDefaults.updateUserDetails { eiger in
                                            eiger.likes!.removeAll(where: { $0.tid == titleModel.tid })
                                            return eiger
                                        }
                                        isLike = false
                                    } else {
                                        
                                        if loginUser.likes!.count > 5 {
                                            guard ErigoUserDefaults.ErigoReadVIP()! else {
                                                ErigoProgressVM.ErigoSymbol(text: "The collection limit has been reached, please subscribe to VIP to collect more!")
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                                    router.naviTo(to: .STORE)
                                                }
                                                return
                                            }
                                        }
                                        ErigoUserDefaults.updateUserDetails { eiger in
                                            eiger.likes!.append(titleModel)
                                            return eiger
                                        }
                                        isLike = true
                                    }
                                } else {
                                    router.naviTo(to: .LAND)
                                }
                            }) {
                                Image(isLike ? "btnLike_se" : "btnLike")
                                    .resizable()
                                    .frame(width: 34, height: 34)
                            }.opacity(titleModel.bid == ErigoUserDefaults.ErigoAvNowUser().uerId ?? 0 ? 0 : 1)
                        }.padding(.top, 20)
                            .padding(.horizontal, 20)
                        
                        Text(titleModel.content ?? "") // 内容
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
                                            ForEach(0..<min(8, titleModel.colors!.count - row * 8), id: \.self) { col in // 8列
                                                let index = row * 8 + col
                                                Rectangle()
                                                    .fill(Color(hes: titleModel.colors![index]))
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
                                if let views = titleModel.views {
                                    Text("\(views + randCount) views") // 浏览次数
                                        .font(.custom("PingFangSC-Regular", size: 13))
                                        .foregroundStyle(Color(hes: "#999999"))
                                        .alignmentGuide(.leading) { d in
                                            d[.trailing]
                                        }
                                }
                            }
                            HStack {
                                Image("likeU")
                                if isLike {
                                    Text("\((titleModel.likes ?? 0) + 1) like") // 喜欢人数
                                        .font(.custom("PingFangSC-Regular", size: 13))
                                        .foregroundStyle(Color(hes: "#999999"))
                                } else {
                                    Text("\(titleModel.likes ?? 0) like") // 喜欢人数
                                        .font(.custom("PingFangSC-Regular", size: 13))
                                        .foregroundStyle(Color(hes: "#999999"))
                                }
                            }
                            Spacer()
                        }
                        .padding(.top, 20)
                        .padding(.horizontal, 20)
                        HStack(alignment: .bottom, spacing: 25) {
                            if !isHiddenSend {
                                Button(action: { // 送礼
                                    withAnimation(.interactiveSpring(duration: 0.5, extraBounce: 0.2)) {
                                        isSendGift.toggle()
                                    }
                                }) { Image("btnGive") }
                            }
                            VStack(spacing: 10) {
                                Image("sayHi")
                                Button(action: { // 单人聊天
                                    if LoginVM.landComplete {
                                        let userModel = LoginVM.ErigoGetAssignUser(uid: titleModel.bid!)
                                        router.previous()
                                        DispatchQueue.main.async {
                                            router.naviTo(to: .SINGLECHAT(userModel))
                                        }
                                    } else {
                                        router.naviTo(to: .LAND)
                                    }
                                }) {
                                    Image("sendMes")
                                }
                            }.opacity(titleModel.bid == ErigoUserDefaults.ErigoAvNowUser().uerId ?? 0 ? 0 : 1)
                        }.padding(.horizontal, 20)
                            .padding(.bottom, ERIGOSCREEN.HEIGHT * 0.15)
                        
                    }
                }.frame(width: ERIGOSCREEN.WIDTH, height: ERIGOSCREEN.HEIGHT * 0.65)
                
                Spacer()
            }
            HStack { // 返回
                Button(action: { router.previous() }) {
                    Image("global_back")
                }
                Spacer()
                Button(action: {
                    ErigoMesAndPubVM.ErigoShowReport {
                        LoginVM.eyeReportList.append(titleModel.tid ?? 0)
                        LoginVM.ErigoRemoveLike()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            router.previous()
                        }
                    }
                }) { // 举报
                    Image("btnReport")
                }.opacity(titleModel.bid == ErigoUserDefaults.ErigoAvNowUser().uerId ?? 0 ? 0 : 1)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, ERIGOSCREEN.HEIGHT * 0.8)
            
            if isSendGift { // 礼物界面
                VStack {
                    VStack {}
                        .frame(width: ERIGOSCREEN.WIDTH,
                               height: ERIGOSCREEN.HEIGHT * 0.7)
                        .background(
                            Color.clear
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    withAnimation(.interactiveSpring(duration: 0.5, extraBounce: 0.2)) {
                                        isSendGift.toggle()
                                    }
                                }
                        )
                    VStack {
                        ZStack {
                            Image("gift_bg")
                                .resizable()
                                .frame(height: ERIGOSCREEN.HEIGHT * 0.3)
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 20) {
                                    ForEach(Array(giftList.enumerated()), id: \.offset) { index, item in
                                        ErigoGiftItem(giftData: item) {
                                            ErigoPurchaseVM.shared.ErigoAvGift(gid: "\(giftList[index].gId!)") {
                                                withAnimation(.interactiveSpring(duration: 0.5, extraBounce: 0.2)) {
                                                    isSendGift.toggle()
                                                    reloadGiftData()
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 30)
                        }.frame(height: ERIGOSCREEN.HEIGHT * 0.3)
                    }
                }
                .frame(width: ERIGOSCREEN.WIDTH,
                       height: ERIGOSCREEN.HEIGHT)
                .ignoresSafeArea()
                .transition(.asymmetric(
                            insertion: .move(edge: .leading),
                            removal: .move(edge: .leading)
                        ))
                .zIndex(1)
            }
        }
        .frame(width: ERIGOSCREEN.WIDTH,
                height: ERIGOSCREEN.HEIGHT)
         .ignoresSafeArea()
         .background(.black)
         .onAppear {
             randCount = Array(5..<10).randomElement()!
             if LoginVM.landComplete {
                 isLike = LoginVM.ErigoIsLike(tid: titleModel.tid!)
                 loginUser = ErigoUserDefaults.ErigoAvNowUser()
                 isHiddenSend = loginUser.uerId! == titleModel.bid!
                 if let uid = loginUser.uerId {
                     headImage = LoginVM.ErigoLoadIamge(uid: uid)
                 }
             }
             reloadGiftData()
         }
         .zIndex(isSendGift ? 0 : 1)
    }
    
    /// 重新拉取礼物数据
    func reloadGiftData() {
        giftList = ErigoPurchaseVM.shared.giftStoreList
        if LoginVM.landComplete {
            loginUser = ErigoUserDefaults.ErigoAvNowUser()
        }
        if let isLimit = ErigoUserDefaults.ErigoGiftLimit(), isLimit {
            giftList = giftList.filter { item in return !item.isLimit! }
        }
    }
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

// MARK: 送礼Item
struct ErigoGiftItem: View {
    
    var giftData: ErigoStoreM
    
    var onSend: () -> Void
    
    var body: some View {
        VStack {
            ZStack {
                if giftData.gId!.contains("pri_pic") {
                    Image("giftHeart").scaledToFit().frame(width: 74, height: 74)
                }
                if giftData.gId!.contains("pri_vid") {
                    Image("giftLetter").scaledToFit().frame(width: 74, height: 74)
                }
                if giftData.gId!.contains("prem") {
                    Image("giftLimit").scaledToFit().frame(width: 74, height: 74)
                }
            }
            Text(giftData.gName!)
                .font(.custom("PingFangSC-Regular", size: 12))
                .foregroundStyle(.white)
            Text(giftData.gPrice!)
                .font(.custom("PingFangSC-Regular", size: 12))
                .foregroundStyle(.white)
            Button(action: {
                onSend()
            }) { Image("btnGift") }
            Spacer()
        }
        .frame(width: 80, height: 160)
    }
}
