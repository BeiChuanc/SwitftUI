//
//  ErigoPublish.swift
//  Erigo
//
//  Created by 北川 on 2025/4/21.
//

import SwiftUI

// MARK: 发布页
struct ErigoPublish: View {
    
    var colorGroup: [String] = [
        "#A5242B", "#C73F34", "#CB572C", "#DD9A31", "#E4AE3C", "#F5EA3C", "#DFDE3B", "#9FBD4A",
        "#67A850", "#4F8A49", "#416F42", "#588E58", "#6CAB6A", "#6BAC6D", "#5CA19A", "#5D93CC",
        "#4972B4", "#363580", "#292655", "#582E7A", "#802A7B", "#872254", "#BA2159", "#C52474"]
    
    var nowAcc = ErigoUserDefaults.ErigoAvNowUser()
    
    @State var publishContent: String = ""
    
    @State var showWebView: Bool = false
    
    @State var showLib: Bool = false
    
    @State var isUpload: Bool = false
    
    @FocusState var isContent: Bool
    
    @ObservedObject var loginM = ErigoLoginVM.shared
    
    @EnvironmentObject var router: ErigoRoute
    
    @State var selectMedia: [ErigoMediaM] = []
    
    @State var selectedColors: [String] = []
    
    @State var colorSelected: [Bool] = Array(repeating: false, count: 24)
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: { // 发布
                    if loginM.landComplete {
                        guard !publishContent.isEmpty else { isContent = true
                            return }
                        
                        guard !selectMedia.isEmpty else {
                            return }
                        
                        let group = DispatchGroup()
                        group.enter()
                        let count = ErigoMesAndPubVM.ErigoAVMedias(myMPath: "Erigo_\(nowAcc.uerId!)") + 1
                        print("当前的媒体个数为:\(count)")
                        let mediaUrl = ErigoMesAndPubVM.ErigoSaveMyM(myM: selectMedia[0].mData!,
                                                                     myFPath: "\(count).\(selectMedia[0].type == .IMAGE ? "png" : "mp4")",
                                                                     myMPath: "Erigo_\(nowAcc.uerId!)")
                        var titleModel = ErigoEyeTitleM()
                        titleModel.tid = nowAcc.uerId! + count
                        titleModel.bid = nowAcc.uerId!
                        titleModel.name = nowAcc.name!
                        titleModel.type = selectMedia[0].type.rawValue
                        titleModel.cover = ""
                        titleModel.media = mediaUrl!.path
                        titleModel.content = publishContent
                        titleModel.colors = selectedColors
                        titleModel.views = 0
                        titleModel.likes = 0
                        ErigoUserDefaults.updateUserDetails { eiger in
                            eiger.album?.append(titleModel)
                            return eiger
                        }
                        group.leave()
                        
                        group.notify(queue: DispatchQueue.main) {
                            selectedColors.removeAll()
                            selectMedia.removeAll()
                            publishContent.removeAll()
                            isUpload = false
                        }
                    } else {
                        router.naviTo(to: .LAND)
                    }
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
                .frame(height: 120)
            
            HStack {
                
                if isUpload {
                    ZStack (alignment: .center) {
                        Image(uiImage: selectMedia[0].img!).resizable().clipShape(RoundedRectangle(cornerRadius: 10))
                            .frame(width: 80, height: 80)
                        if selectMedia[0].type == .VIDEO {
                            Button(action: {}) {
                                Image("btnPlay")
                            }
                            .buttonStyle(ReButtonEffect())
                        }
                    }
                }
                
                Button(action: { // 选中媒体
                    showLib = true
                }) {
                    Image("btnUpload")
                }
                Image("publishRow").offset(CGSize(width: 0, height: -50))
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 60)
            .sheet(isPresented: $showLib) {
                YPImagePickerVC(selectedMedia: { item in
                    selectMedia.removeAll()
                    selectMedia.append(item)
                    showLib = false
                    isUpload = true
                }, mediaOption: .PHOTOANDVIDEO)
            }
            
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
                                                .stroke(Color(hes: "#FFFFFF", alpha: colorSelected[index] ? 1 : 0), lineWidth: 1)
                                        }
                                        .onTapGesture {
                                            colorSelected[index].toggle()
                                            if colorSelected[index] {
                                                selectedColors.append(colorGroup[index])
                                            } else {
                                                if let indexToRemove = selectedColors.firstIndex(of: colorGroup[index]) {
                                                    selectedColors.remove(at: indexToRemove)
                                                }
                                            }
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
                .font(.custom("PingFangSC-Regular", size: 15))
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
