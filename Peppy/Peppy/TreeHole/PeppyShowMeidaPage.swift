//
//  peppyShowMeidaPage.swift
//  Peppy
//
//  Created by 北川 on 2025/4/10.
//

import SwiftUI

// MARK: 我的媒体子项
struct PeppyShowMeidaPage: View {
    
    @Binding var myMediaData: PeppyMyMedia
    
    var body: some View {
        VStack {
            Image("img_cell_media").padding(.bottom, -10)
            VStack() {
                HStack {
                    // 左
                    VStack {
                        PeppyHeadContentView()
                        Spacer()
                    }
                    Spacer()
                    VStack {
                        AsyncImage(url: myMediaData.mediaUrl) // 媒体URL
                            .modifier(RoundedBorderStyle(cornerRadius: 20, borderColor: .black, borderWidth: 1))
                        
                        Text(myMediaData.mediaContent!) //媒体内容
                            .font(.custom("PingFang SC", size: 12))
                        HStack {
                            Spacer()
                            Text(myMediaData.mediaTime!) // 时间
                        }
                    }
                }.padding(12)
            }
            .frame(width: peppyW - 40, height: 260)
            .background(.white)
            .modifier(RoundedBorderStyle(cornerRadius: 20, borderColor: .black, borderWidth: 1))
        }
    }
}

// MARK: 用户头像
struct PeppyHeadContentView: View {
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Image("UserHead_bg")
                .resizable()
                .frame(width: 48, height: 48)
            Image("Placeholder")
                .frame(width: 40.0, height: 40.0)
                .background(Color.red) // 用户头像底色
                .border(.black, width: 1)
            Image("head_1") // 用户头像
                .resizable()
                .padding(.all, 2.0)
                .frame(width: 40.0, height: 40.0)
        }
        .frame(width: 48, height: 48)
        .padding(.trailing, 10)
    }
}
