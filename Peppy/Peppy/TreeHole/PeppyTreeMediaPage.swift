//
//  PeppyTreeMediaPage.swift
//  Peppy
//
//  Created by 北川 on 2025/4/11.
//

import SwiftUI
import AVFoundation

// MARK: 媒体播放
struct PeppyTreeMediaPage: View {
    
    @EnvironmentObject var peppyRouter: PeppyRouteManager
    
    var body: some View {
        ZStack {
             // 嵌入全屏播放器
            VStack {
                HStack {
                    Button(action: {
                        withAnimation(.bouncy) {
                            
                        }
                        peppyRouter.pop()
                    }) {
                        Image("btnBac").frame(width: 24, height: 24)
                    }
                    Spacer()
                }.frame(width: peppyW - 40 , height: 25)
                    .padding(.top, 20)
                Spacer()
                Text("Test")
                    .font(.custom("PingFang SC", size: 12))
                    .foregroundStyle(.white)
                    .padding(.bottom, 20)
                
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.black)
        }
    }
}

#Preview {
    PeppyTreeMediaPage()
}
