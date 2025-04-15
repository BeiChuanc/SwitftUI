//
//  PeppyChatAnimalContentView.swift
//  Peppy
//
//  Created by 北川 on 2025/4/14.
//

import SwiftUI

// MARK: 聊天 - 动物
struct PeppyChatAnimalContentView: View {
    
    var chatMould: PeppyChatMould
    
    var animal: PeppyAnimalMould
    
    var currentU = PeppyUserManager.PEPPYCurrentUser()
    
    @State var textWidth: CGFloat = 0
    
    var body: some View {
        ZStack {
            
            if chatMould.isMy { // 用户
                HStack(alignment: .top) {
                    Spacer()
                    Text(chatMould.c)
                        .font(.custom("PingFang SC", size: 12))
                        .foregroundColor(.black)
                        .padding(8)
                        .background(
                            GeometryReader { geo in
                                Color.white
                                    .border(.black, width: 2)
                                    .preference(
                                        key: TextWidthKey.self,
                                        value: geo.size.width
                                    )
                            }
                        )
                        .onPreferenceChange(TextWidthKey.self) { width in
                            textWidth = min(width, peppyW / 2)
                        }
                        .frame(width: textWidth == 0 ? nil : textWidth)
                        .fixedSize(horizontal: textWidth == 0, vertical: true)
                        .modifier(RoundedBorderStyle(cornerRadius: 0, borderColor: .black, borderWidth: 2))
                    Spacer().frame(width: 12)
                    PeppyUserHeadContentView(head: currentU.head!,
                                             headBgColor: currentU.headColor!,
                                             headFrame: 32.0)
                }
            } else { // 动物
                HStack(alignment: .top) {
                    Image("Ah_\(animal.animalId)").resizable()
                        .frame(width: 32, height: 32)
                    Spacer().frame(width: 12)
                    Text(chatMould.c)
                        .font(.custom("PingFang SC", size: 12))
                        .foregroundColor(.black)
                        .padding(8)
                        .background(
                            GeometryReader { geo in
                                Color.white
                                    .border(.black, width: 2)
                                    .preference(
                                        key: TextWidthKey.self,
                                        value: geo.size.width
                                    )
                            }
                        )
                        .onPreferenceChange(TextWidthKey.self) { width in
                            textWidth = min(width, peppyW / 2)
                        }
                        .frame(width: textWidth == 0 ? nil : textWidth)
                        .fixedSize(horizontal: textWidth == 0, vertical: true)
                        .modifier(RoundedBorderStyle(cornerRadius: 0, borderColor: .black, borderWidth: 2))
                    Spacer()
                }
            }
        }
    }
}

struct TextWidthKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
