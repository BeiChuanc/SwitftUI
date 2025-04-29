//
//  ErigoStore.swift
//  Erigo
//
//  Created by 北川 on 2025/4/25.
//

import SwiftUI

// MARK: 商店订阅
struct ErigoStore: View {
    
    @State var vipList: [ErigoStoreM] = []
    
    @State var selectVIP: Int? = nil
    
    @ObservedObject var loginM = ErigoLoginVM.shared
    
    @EnvironmentObject var router: ErigoRoute
    
    var body: some View {
        ZStack {
            Image("first_bg")
                .resizable()
            VStack {
                HStack {
                    Button(action: { // 返回
                        router.previous()
                    }) { Image("global_back") }
                    Image("subTo")
                    Spacer()
                    Button(action: { // 恢复购买
                        ErigoPurchaseVM.shared.ErigoRestore()
                    }) { Image("btnRes") }
                }.padding(.top, 60)
                    .padding(.horizontal, 20)
                
                Image("VIPMe").padding(.top, 10)
                
                Image("storeDes").padding(.top, 20)
                
                VStack(spacing: 15) {
                    ForEach(Array(vipList.enumerated()), id: \.offset) { index, item in
                        ErigoSubItem(vipData: item, isSelect: index == selectVIP) {
                            selectVIP = index
                        }
                    }
                }.padding(.top, 30)
                
                Spacer()
                
                Button(action: { // 订阅
                    guard selectVIP != nil else { return }
                    ErigoPurchaseVM.shared.ErigoAvVIP(vipId: vipList[selectVIP!].gId!)
                }) { Image("btnSuc") }
                
                LinkTextView(firstText: "Terms of Service",
                             secondTxt: "EULA",
                             tarText: "By continuing, you agree to our Terms of Service and EULA.",
                             customFont: .custom("", size: 12),
                             tartColor: Color(hes: "#FFFFFF", alpha: 0.4),
                             higlitColor: Color(hes: "#FFFFFF"),
                             firstLink: URL(string: ERIGOLINK.TER)!,
                             secondLink: URL(string: ERIGOLINK.EUA)!) // 链接Text
                .padding(.top, 10)
                .padding(.bottom, 60)
            }
        }.frame(width: ERIGOSCREEN.WIDTH,
                height: ERIGOSCREEN.HEIGHT)
         .ignoresSafeArea()
         .background(.black)
         .onAppear {
             vipList = ErigoPurchaseVM.shared.vipStoreList
         }
    }
}

// MARK: 订阅Item
struct ErigoSubItem: View {
    
    var vipData: ErigoStoreM
    
    var isSelect: Bool
    
    var onSelect: () -> Void
    
    var body: some View {
        VStack {
            Text("Premium")
                .font(.custom("PingFangSC-Regular", size: 12))
                .foregroundStyle(.black)
            Text("\(vipData.gPrice!)/\(vipData.gName!)")
                .font(.custom("PingFangSC-Medium", size: 20))
                .foregroundStyle(.black)
        }
        .frame(width: ERIGOSCREEN.WIDTH - 40, height: 65)
        .background(isSelect ? .white : Color(hes: "#FCFB4E"))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(isSelect ? Color(hes: "#FF629D") : .clear, lineWidth: 2)
        )
        .onTapGesture {
            onSelect()
        }
    }
}
