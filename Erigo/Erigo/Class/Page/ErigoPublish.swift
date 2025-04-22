//
//  ErigoPublish.swift
//  Erigo
//
//  Created by 北川 on 2025/4/21.
//

import SwiftUI

// MARK: 发布页
struct ErigoPublish: View {
    
    @State var publishContent: String = ""
    
    @State var uploadCom: Bool = false
    
    @State var selectIndex: Int? = nil
    
    @State var showWebView: Bool = false
    
    @FocusState var isContent: Bool
    
    var colorGroup: [String] = [
        "#A5242B", "#C73F34", "#CB572C", "#DD9A31", "#E4AE3C", "#F5EA3C", "#DFDE3B", "#9FBD4A",
        "#67A850", "#4F8A49", "#416F42", "#588E58", "#6CAB6A", "#6BAC6D", "#5CA19A", "#5D93CC",
        "#4972B4", "#363580", "#292655", "#582E7A", "#802A7B", "#872254", "#BA2159", "#C52474"]
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: { // 发布
                    
                }) {
                    Image("btnRelease")
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 60)
            
            ZStack(alignment: .leading) { // 内容
                if publishContent.isEmpty {
                    Text("Tell Us About Your Eye Makeup Experience")
                        .foregroundColor(Color(hes: "#FF629D", alpha: 0.3))
                        .font(.custom("Futura-CondensedExtraBold", size: 18))
                        .padding(.horizontal, 20)
                        .offset(CGSize(width: 0, height: -20))
                }
                TextEditor(text: $publishContent)
                    .frame(height: 80)
                    .font(.custom("Futura-CondensedExtraBold", size: 19))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 15)
                    .focused($isContent)
                    .scrollContentBackground(.hidden)
                    .textFieldStyle(PlainTextFieldStyle())
            }.padding(.top, 50)
            
            HStack {
                
                
                
                Button(action: { // 发布
                    
                }) {
                    Image("btnUpload")
                }
                Image("publishRow").offset(CGSize(width: 0, height: -50))
                Spacer()
            }.padding(.horizontal, 20)
                .padding(.top, 60)
            
            
            VStack {
                HStack {
                    Text("Choose eyeshadow theme color")
                        .font(.custom("PingFangSC-Medium", size: 15))
                        .foregroundStyle(.white)
                    Spacer()
                }
                HStack {
                    VStack {
                        Image("colorPint")
                        Spacer()
                    }
                    
                    VStack {
                        ForEach(0..<3) { row in // 3行
                            HStack {
                                ForEach(0..<8) { col in // 8列
                                    let index = row * 8 + col
                                    Rectangle()
                                        .fill(Color(hes: colorGroup[index]))
                                        .frame(width: 30, height: 16)
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 0)
                                                .stroke(Color(hes: "#FFFFFF", alpha: selectIndex == index ? 1 : 0), lineWidth: 1)
                                        }
                                        .onTapGesture {
                                            selectIndex = index
                                        }
                                }
                            }
                        }
                        Spacer()
                    }
                    
                    Spacer()
                }
            }.padding(.horizontal, 20)
                .padding(.top, 50)
            
            Text("EULA")
                .font(.custom("PingFangSC-Regular", size: 18))
                .foregroundStyle(Color(hes: "#FFFFFF", alpha: 0.4))
                .underline()
                .onTapGesture {
                    showWebView = true
                }
                .fullScreenCover(isPresented: $showWebView) {
                    NavigationStack {
                        WebViewContainer(url: URL(string: ERIGOLINK.EUA)!)
                            .frame(width: ERIGOSCREEN.WIDTH,
                                   height: ERIGOSCREEN.HEIGHT)
                            .toolbar {
                                ToolbarItem(placement: .topBarLeading) {
                                    Button(action: { showWebView = false }) {
                                        Image("web_back")
                                    }
                                }
                            }
                    }
                }
                .padding(.bottom, 160)
            
        }
        .frame(width: ERIGOSCREEN.WIDTH,
                height: ERIGOSCREEN.HEIGHT)
         .ignoresSafeArea()
         .background(.black)
    }
}

#Preview {
    ErigoPublish()
}
