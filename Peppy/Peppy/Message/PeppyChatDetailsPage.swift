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
    
    @State var animalMes: [PeppyChatMould] = []
    
    @State var inputMes: String = ""
    
    @State var isEnable: Bool = false
    
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
                        HStack (alignment: .bottom) {
                            Image("\(animal.animalHead)")
                                .resizable()
                                .frame(width: 149, height: 120)
                                .offset(CGSize(width: 0, height: 5))
                            Spacer()
                            Image("chatTips")
                                .frame(width: 166, height: 118)
                            Spacer()
                            VStack {
                                Button(action: { // 举报
                                    PeppyComManager.peppyReport(animalId: animal.animalId) {
                                        PeppyUserDataManager.shared.blockAnimals.append(animal.animalId)
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                            peppyRouter.pop()
                                        }
                                    }
                                }) {
                                    Image("btnreport")
                                        .frame(width: 24, height: 24)
                                }.padding(.top, 10)
                                Spacer()
                            }
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
                        
                        ScrollViewReader { proxy in // 消息列表
                            ScrollView(.vertical, showsIndicators: false) {
                                LazyVStack (spacing: 20) {
                                    ForEach(animalMes) { item in
                                        PeppyChatAnimalContentView(chatMould: item, animal: animal)
                                            .opacity(item.isAnimated ? 1 : 0) // 动画
                                            .offset(y: item.isAnimated ? 0 : 20)
                                            .animation(
                                                .easeInOut(duration: 0.4)
                                                .delay(Double(animalMes.firstIndex(of: item) ?? 0) * 0.1),
                                                value: item.isAnimated
                                            )
                                            .onAppear {
                                                if let index = animalMes.firstIndex(where: { $0.id == item.id }) {
                                                    animalMes[index].isAnimated = true
                                                }
                                            }
                                    }
                                }.padding(.vertical, 10)
                            }.onChange(of: animalMes.count) { _ in
                                scrollToBottom(proxy: proxy)
                            }
                        }.padding(.horizontal, 20)
                        
                        HStack { // 输入&发送
                            ZStack {
                                Image("chatInput").resizable()
                                TextField("What are you thinking now?", text: $inputMes)
                                    .foregroundStyle(Color(hex: "#000000", alpha: 0.2))
                                    .font(.custom("PingFangTC-Semibold", size: 20))
                                    .padding(.horizontal, 8)
                            }.frame(width: peppyW - 97, height: 42)
                            Spacer()
                            Button(action: {
                                if inputMes.isEmpty {
                                    return
                                }
                                sendMessage(mes: inputMes)
                            }) {
                                Image("chatSend")
                            }.disabled(isEnable)
                        }.padding(.horizontal, 20)
                    }
                }.background(Color(hex: "#F7BD0F"))
            }
        }
    }
    
    func sendMessage(mes: String) {
        let userMes = PeppyChatMould(c: mes, isMy: true)
        animalMes.append(userMes)
        inputMes = ""
        isEnable = true
        
        PeppyAnimailsAIChat.share.peppyWithAnimal(message: mes) { result in
            switch result {
            case .success(let respone):
                
                if let data = respone.data {
                    if data.res != "" {
                        let animals = PeppyChatMould(c: data.res!, isMy: false)
                        animalMes.append(animals)
                        isEnable = false
                    }
                }
            case .failure(_):
                isEnable = false
            }
        }
    }
    
    func scrollToBottom(proxy: ScrollViewProxy) {
        guard let lastMessage = animalMes.last else { return }
        withAnimation {
            proxy.scrollTo(lastMessage.id, anchor: .bottom)
        }
    }
}
