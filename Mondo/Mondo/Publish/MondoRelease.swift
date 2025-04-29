//
//  MondoRelease.swift
//  Mondo
//
//  Created by 北川 on 2025/4/28.
//

import SwiftUI

// MARK: 发布
struct MondoRelease: View {
    
    @State var inputTitle: String = ""
    
    @FocusState var isTitle: Bool
    
    @State var inputContent: String = ""
    
    @FocusState var isContent: Bool
    
    @State var isEULA: Bool = false
    
    @State var uploadMedia: [MondoLibM] = []
    
    @State var isShowLib: Bool = false
    
    @State var completeUpload: Bool = false
    
    var monMe = MondoCacheVM.MondoAvCurUser()
    
    @ObservedObject var monLogin = MondoUserVM.shared
    
    @EnvironmentObject var pageControl: MondoPageControl
    
    var body: some View {
        ZStack {
            Image("release_bg").resizable()
            VStack {
                HStack {
                    Image("topRelease")
                    Spacer()
                    Button(action: { pageControl.backToLevel() }) { Image("btnClose") }
                }
                VStack { // 标题 & 内容
                    MondoTextFielfItem(textInput: $inputTitle,
                                       placeholder: "Fill in the title",
                                       interval: 15,
                                       backgroundColor: UIColor.clear,
                                       textColor: UIColor(hex: "#111111", alpha: 0.2),
                                       placeholderColor: UIColor(hex: "#111111", alpha: 0.2),
                                       bordColor: UIColor(hex: "#925EFF"),
                                       font: UIFont(name: "PingFangSC-Medium", size: 14)!,
                                       radius: 22.5)
                    .frame(height: 45)
                    .focused($isTitle)
                    ZStack(alignment: .topLeading) { // 内容
                        if inputContent.isEmpty {
                            Text("Fill in the content")
                                .foregroundColor(Color(hex: "#111111", alpha: 0.2))
                                .font(.custom("PingFangSC-Medium", size: 14))
                                .padding(.horizontal, 20)
                                .offset(CGSize(width: -5, height: 0))
                        }
                        TextEditor(text: $inputContent)
                            .frame(height: (MONDOSCREEN.WIDTH - 32) * 0.44)
                            .font(.custom("PingFangSC-Medium", size: 14))
                            .foregroundColor(Color(hex: "#111111", alpha: 0.2))
                            .multilineTextAlignment(.leading)
                            .padding(.horizontal, 15)
                            .focused($isContent)
                            .scrollContentBackground(.hidden)
                            .textFieldStyle(PlainTextFieldStyle())
                            .offset(CGSize(width: -5, height: -10))
                    }.padding(.top, 50)
                        .frame(height: 120)
                        .frame(width: MONDOSCREEN.WIDTH - 32,
                               height: (MONDOSCREEN.WIDTH - 32) * 0.44)
                        .clipShape(RoundedRectangle(cornerRadius: 30))
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color(hex: "#925EFF"), lineWidth: 1)
                        )
                }.padding(.top, 15)
                VStack(spacing: 15) {
                    ZStack {
                        Button(action: { // 上传
                            isShowLib = true
                        }) { Image("btnUpload").resizable().frame(width: MONDOSCREEN.WIDTH - 160, height: (MONDOSCREEN.WIDTH - 160) * 1.4) }
                            .sheet(isPresented: $isShowLib) {
                                YPImagePickerVC(selectedMedia: { item in
                                    uploadMedia.removeAll()
                                    uploadMedia.append(item)
                                    isShowLib = false
                                    completeUpload = true
                                }, mediaOption: .PHOTOANDVIDEO)
                            }
                        if completeUpload {
                            ZStack (alignment: .center) {
                                Image(uiImage: uploadMedia[0].img).resizable().clipShape(RoundedRectangle(cornerRadius: 10))
                                    .frame(width: MONDOSCREEN.WIDTH - 160, height: (MONDOSCREEN.WIDTH - 160) * 1.4)
                                if uploadMedia[0].type == 1 {
                                    Button(action: {}) {
                                        Image("btnPlay")
                                    }
                                    .buttonStyle(MondoReEffort())
                                }
                            }
                        }
                    }
                    Button(action: { // 发布
                        MondReleaseMyMedia()
                    }) {
                        Image("btnRelease").resizable()
                            .frame(width: MONDOSCREEN.WIDTH - 32, height: 50)
                    }
                    Button(action: {
                        isEULA = true
                    }) { Image("btnEULA") }
                        .offset(CGSize(width: 0, height: -5))
                        .fullScreenCover(isPresented: $isEULA) {
                            NavigationStack {
                                MondoWebItem(url: URL(string: MONDOPROTOC.EULA))
                                    .frame(width: MONDOSCREEN.WIDTH,
                                           height: MONDOSCREEN.HEIGHT)
                                    .toolbar {
                                        ToolbarItem(placement: .topBarLeading) {
                                            Button(action: { isEULA = false }) {
                                                Image("guide_back")
                                            }
                                        }
                                    }
                            }
                        }
                    Spacer()
                }.padding(.top, 15)
            }.padding(.horizontal, 16)
                .padding(.top, 80)
        }.ignoresSafeArea()
    }
    
    /// 发布用户自己视频
    func MondReleaseMyMedia() {
        if monLogin.loginIn {
            guard !inputTitle.isEmpty else { isTitle = true
                return }
            
            guard !inputContent.isEmpty else { isContent = true
                return }
            
            let group = DispatchGroup()
            group.enter()
            
            let count = MondoRelMesVM.MondoAVMedias(myMPath: "Mondo_\(monMe.uid)") + 1
            let mediaUrl = MondoRelMesVM.MondoSaveMyM(myM: uploadMedia[0].mData!,
                                                         myFPath: "\(count).\(uploadMedia[0].type == 0 ? "png" : "mp4")",
                                                         myMPath: "Mondo_\(monMe.uid)")
            var titleModel = MondoTitleMeM()
            titleModel.mId = monMe.uid + count
            titleModel.media = mediaUrl!.path
            titleModel.isVideo = uploadMedia[0].type == 0 ? false : true
            titleModel.topic = inputTitle
            titleModel.content = inputContent
            MondoCacheVM.MondoFixDetails { mon in
                if uploadMedia[0].type == 0 {
                    mon.publishImage.append(titleModel)
                } else {
                    mon.publishVideo.append(titleModel)
                }
                return mon
            }
            
            group.leave()
            
            group.notify(queue: DispatchQueue.main) {
                uploadMedia.removeAll()
                inputTitle.removeAll()
                inputContent.removeAll()
                completeUpload = false
            }
        } else {
            pageControl.route(to: .LOGIN)
        }
    }
}
