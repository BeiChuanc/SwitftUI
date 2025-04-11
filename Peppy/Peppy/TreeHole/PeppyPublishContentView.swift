//
//  PeppyPublishContentView.swift
//  Peppy
//
//  Created by 北川 on 2025/4/10.
//

import SwiftUI

// MARK: 发布页面
struct PeppyTreePublishContentView: View {
    
    let goBack: () -> Void
    
    var body: some View {
        ZStack(alignment: .top) {
            Image("tree_publish").resizable()
                .ignoresSafeArea()
            VStack {
                VStack(alignment: .leading) {
                    HStack {
                        Spacer()
                        Button(action: {
                            withAnimation(.bouncy) {
                                goBack()
                            }
                        }) {
                            Image("publish_back").frame(width: 25, height: 25)
                        }
                    }
                    .frame(width: peppyW - 80, height: 30)
                    .padding(.top, 20)
                    
                    Image("publish_say").resizable()
                        .frame(width: 182, height: 15)
                    Spacer()
                    
                    // 选择媒体
                    
                }
                .frame(width: peppyW - 40, height: peppyH * 0.6)
                .background(Color(hex: "#F7BD0F"))
                .modifier(RoundedBorderStyle(cornerRadius: 20, borderColor: .black, borderWidth: 1))
                .padding(.top, 44)
                
                Button(action: {
                    print("EULA - Link")
                }) {
                    Image("btnEULA")
                }.padding(.top, 10)
            }
        }
        .onAppear() // 加载数据逻辑
    }
}
