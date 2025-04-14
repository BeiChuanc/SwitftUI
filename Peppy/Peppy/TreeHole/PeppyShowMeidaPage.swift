//
//  peppyShowMeidaPage.swift
//  Peppy
//
//  Created by 北川 on 2025/4/10.
//

import SwiftUI

// MARK: 我的媒体子项
struct PeppyShowMeidaPage: View {
    
    var myMediaData: PeppyMyMedia
    
    var userCurrent = PeppyUserManager.PEPPYGetCurrentDancer()
    
    var body: some View {
        VStack {
            Image("img_cell_media").padding(.bottom, -10)
            VStack() {
                HStack {
                    // 左
                    VStack {
                        PeppyUserHeadContentView(head: userCurrent.head ?? "",
                                                 headBgColor: userCurrent.headColor ?? "",
                                                 headFrame: 48.0)
                        Spacer()
                    }
                    Spacer()
                    VStack {
                        
//                        let url = myMediaData.mediaUrl
//                        let imageData = try? Data(contentsOf: url!)
//                        let uiImage = UIImage(data: imageData!)
//                        Image(uiImage: uiImage!) // 媒体URL
//                            .modifier(RoundedBorderStyle(cornerRadius: 20, borderColor: .black, borderWidth: 1))
                        
                        if let imageURL = URL(string: "file:///Users/beichuan/Library/Developer/CoreSimulator/Devices/27A041FE-5673-45A3-86E9-5D424C2B792D/data/Containers/Data/Application/432CA253-9A4F-45C4-85DD-900F446667A5/Documents/media_135/1.png"),
                                   let imageData = try? Data(contentsOf: imageURL),
                                   let uiImage = UIImage(data: imageData) {
                                    Image(uiImage: uiImage)
                                       .resizable()
                                       .aspectRatio(contentMode: .fit)
                                } else {
                                    Text("无法加载图片")
                                }
                        
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
            .modifier(RoundedBorderStyle(cornerRadius: 20, borderColor: .black, borderWidth: 2))
        }
    }
}
