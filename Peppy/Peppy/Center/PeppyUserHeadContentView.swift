//
//  PeppyUserHeadContentView.swift
//  Peppy
//
//  Created by 北川 on 2025/4/14.
//

import SwiftUI

// MARK: 用户头像
struct PeppyUserHeadContentView: View {
    
    var head: String
    
    var headBgColor: String
    
    var headFrame: CGFloat
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Image("UserHead_bg")
                .resizable()
                .frame(width: headFrame,
                       height: headFrame)
            ZStack{}
                .frame(width: headFrame * 0.83,
                       height: headFrame * 0.83)
                .background(Color(hex: headBgColor)) // 用户头像底色
                .border(.black, width: 1)
            Image(head) // 用户头像
                .resizable()
                .padding(.all, 2.0)
                .frame(width: headFrame * 0.83,
                       height: headFrame * 0.83)
        }
        .frame(width: headFrame * 0.83,
               height: headFrame * 0.83)
        .padding(.trailing, 10)
    }
}
