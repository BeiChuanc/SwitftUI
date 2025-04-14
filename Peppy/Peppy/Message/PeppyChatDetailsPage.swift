//
//  PeppyChatDetailsPage.swift
//  Peppy
//
//  Created by 北川 on 2025/4/11.
//

import SwiftUI

// MARK: 聊天详情
struct PeppyChatDetailsPage: View {
    
    var animal: PeppyAnimalMould
    
    var body: some View {
        PeppyChatDetailsContentView(animal: animal)
    }
}

struct PeppyChatDetailsContentView: View {
    
    var animal: PeppyAnimalMould
    
    @State var inputMes: String = ""
    
    @EnvironmentObject var peppyRouter: PeppyRouteManager
    
    var body: some View {
        ZStack {
            Image("chatBg")
                .resizable()
                .ignoresSafeArea()
            VStack {
                HStack {
                    VStack {
                        Spacer().frame(height: 30)
                        Button(action: {
                            peppyRouter.pop()
                        }) {
                            Image("btnBac").frame(width: 24, height: 24)
                        }
                        Spacer()
                    }
                    Spacer()
                    VStack {
                        Spacer()
                        HStack(alignment: .bottom) {
                            Image("\(animal.animalHead)")
                                .frame(width: 119, height: 90)
                                .offset(CGSize(width: 0, height: 10))
                            Spacer()
                            Image("chatTips")
                                .frame(width: 166, height: 118)
                        }.offset(CGSize(width: 0, height: 10))
                    }
                }
                .padding(.horizontal, 20)
                .frame(height: 156)
                
                ZStack {
                    VStack {
                        Rectangle()
                                   .fill(Color.black)
                                   .frame(height: 4)
                                   .frame(maxWidth: .infinity)
                        Text(PeppyComManager.peppyGetCurrentTime()) // 当前时间
                        Spacer()
                        
                        VStack { // 消息列表

                        }
                        HStack { // 输入&发送
                            ZStack {
                                Image("chatInput").resizable()
                                TextField("What are you thinking now?", text: $inputMes)
                                    .foregroundStyle(Color(hex: "#000000", alpha: 0.2))
                                    .font(.custom("Marker Felt", size: 20))
                                    .padding(.leading, 8)
                            }.frame(width: peppyW - 97, height: 42)
                            Spacer()
                            Button(action: {
                                if inputMes.isEmpty {
                                    return
                                }
                                inputMes = ""
                            }) {
                                Image("chatSend")
                            }
                        }.padding(.horizontal, 20)
                    }
                }.background(Color(hex: "#F7BD0F"))
            }
        }
    }
}
