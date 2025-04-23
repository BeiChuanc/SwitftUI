//
//  ErigoSet.swift
//  Erigo
//
//  Created by 北川 on 2025/4/18.
//

import SwiftUI
import YPImagePicker

struct ErigoSet: View {
    
    @State var loginUser = ErigoUserM()
    
    @State var editName: String = ""
    
    @FocusState var isName: Bool
    
    @State var isEditName: Bool = false
    
    @State var isEditHead: Bool = false
    
    @State var showP: Bool = false
    
    @State var showT: Bool = false
    
    @State var headWUrl: URL? = nil
    
    @State var userLogOut: Bool = false
    
    @State var userDelete: Bool = false
    
    @ObservedObject var loginM = ErigoLoginVM.shared
    
    @EnvironmentObject var router: ErigoRoute
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                Image("set_bg").resizable()
                    .frame(height: ERIGOSCREEN.HEIGHT * 0.18)
                VStack {
                    HStack {
                        Button(action: { router.previous() }) { // 返回上一级
                            Image("global_back")
                        }
                        Image("setUp")
                        Spacer()
                    }
                    ZStack(alignment: .bottom) { // 修改头像
                        if loginM.landComplete {
                            if let head = loginUser.head {
                                if head == "head_de" {
                                    Image("head_de")
                                        .resizable()
                                        .scaledToFill()
                                        .accessibilityIdentifier("heartImage")
                                        .frame(width: 64, height: 64)
                                        .clipShape(RoundedRectangle(cornerRadius: 32))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 32)
                                                .stroke(.white, lineWidth: 1)
                                        )
                                } else {
                                    
                                }
                            }
                        } else {
                            Image("head_de")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 64, height: 64)
                                .clipShape(RoundedRectangle(cornerRadius: 32))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 32)
                                        .stroke(.white, lineWidth: 1)
                                )
                        }
                        Button(action: {
                            if loginM.landComplete {
                                isEditHead = true
                            } else {
                                router.naviTo(to: .LAND)
                            }
                            
                        }) { // 修改头像
                            Image("btnEditHead")
                                .frame(width: 64, height: 64)
                                .offset(CGSize(width: 20, height: 20))
                        }
                        .foregroundStyle(.primary)
                        .sheet(isPresented: $isEditHead) {
                            YPImagePickerVC(selectedMedia: { cover in
                                let doc = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                                let headName = "ErigoHead"
                                let headURL = doc.appendingPathComponent(headName)
                                if let headData = cover.mData {
                                    do {
                                        try headData.write(to: headURL)
                                        ErigoUserDefaults.updateUserDetails { erigo in
                                            let newErigo = erigo
                                            newErigo.head = headURL.path
                                            return newErigo
                                        }
                                    } catch {}
                                }
                                headWUrl = headURL
                            }, mediaOption: .PHOTO)
                        }
                    }
                    
                    VStack(spacing: 22) {
                        HStack { // 修改名字
                            Text("Eidt Data")
                                .font(.custom("PingFangSC-Semibold", size: 14))
                                .foregroundStyle(.white)
                            Spacer()
                            Image("back_row")
                        }
                        .onTapGesture {
                            if loginM.landComplete {
                                isEditName = true
                            } else {
                                router.naviTo(to: .LAND)
                            }
                        }
                        
                        if isEditName { // 修改名字
                            ZStack {
                                HStack {
                                    TextField("Please enter your nickname", text: $editName) {
                                        
                                    }
                                    .frame(height: 50)
                                    .font(.custom("Futura-CondensedExtraBold", size: 15))
                                    .foregroundStyle(.black)
                                    .focused($isName)
                                    .padding(.leading, 20)
                                    Spacer()
                                    Button(action: {
                                        if editName.isEmpty {
                                            isEditName = false
                                        } else {
                                            ErigoUserDefaults.updateUserDetails { erigo in
                                                let newErigo = erigo
                                                newErigo.name = editName
                                                return newErigo
                                            }
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                                editName = ""
                                                isEditName = false
                                            }
                                        }
                                    }) {
                                        Text(editName.isEmpty ? "Back" : "Eidt")
                                            .font(.custom("Futura-CondensedExtraBold", size: 18))
                                            .foregroundStyle(Color(hes: "#111111"))
                                    }
                                    .frame(width: 60, height: 40)
                                    .background(Color(hes: "#FCFB4E"))
                                    .clipShape(RoundedRectangle(cornerRadius: 5))
                                    .padding(.trailing, 20)
                                }
                                .frame(width: ERIGOSCREEN.WIDTH - 40, height: 60)
                                .background(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                            }
                        }
                        
                        ZStack {
                            HStack { // 隐私
                                Text("Privacy Policy")
                                    .font(.custom("PingFangSC-Semibold", size: 14))
                                    .foregroundStyle(.white)
                                Spacer()
                                Image("back_row")
                            }
                        }
                        .onTapGesture {
                            showP = true
                        }
                        .fullScreenCover(isPresented: $showP) {
                            NavigationStack {
                                WebViewContainer(url: URL(string: ERIGOLINK.POL))
                                    .frame(width: ERIGOSCREEN.WIDTH,
                                           height: ERIGOSCREEN.HEIGHT)
                                    .toolbar {
                                        ToolbarItem(placement: .topBarLeading) {
                                            Button(action: { showP = false }) {
                                                Image("web_back")
                                            }
                                        }
                                    }
                            }
                        }
                        
                        HStack { // 技术支持
                            Text("Term of service")
                                .font(.custom("PingFangSC-Semibold", size: 14))
                                .foregroundStyle(.white)
                            Spacer()
                            Image("back_row")
                        }
                        .onTapGesture {
                            showT = true
                        }
                        .fullScreenCover(isPresented: $showT) {
                            NavigationStack {
                                WebViewContainer(url: URL(string: ERIGOLINK.TER))
                                    .frame(width: ERIGOSCREEN.WIDTH,
                                           height: ERIGOSCREEN.HEIGHT)
                                    .toolbar {
                                        ToolbarItem(placement: .topBarLeading) {
                                            Button(action: { showT = false }) {
                                                Image("web_back")
                                            }
                                        }
                                    }
                            }
                        }
                        
                    }
                    .padding(.top, 20)
                    Rectangle()
                        .fill(Color(hes: "#FFFFFF", alpha: 0.2))
                        .frame(height: 1)
                        .padding(.top, 40)
                    
                    HStack {
                        Button(action: { // 删除
                            if loginM.landComplete {
                                
                            } else {
                                router.naviTo(to: .LAND)
                            }
                        }) {
                            Text("Delete Account")
                                .font(.custom("PingFangSC-Semibold", size: 14))
                                .foregroundStyle(.white)
                        }
                        Spacer()
                    }.padding(.top, 40)
                    
                    Spacer()
                    
                    Button(action: { // 登出
                        if loginM.landComplete {
                            loginM.landComplete = false
                            router.previousRoot()
                        } else {
                            router.naviTo(to: .LAND)
                        }
                    }) {
                        Image("btnLogOut")
                    }.padding(.bottom, 80)
                    
                }.frame(height: ERIGOSCREEN.HEIGHT * 0.82)
                    .padding(.horizontal, 20)
                    .offset(CGSize(width: 0, height: -ERIGOSCREEN.WIDTH * 0.2))
            }.ignoresSafeArea()
                .background(.black)
        }
        .onAppear {
            if loginM.landComplete {
                loginUser = ErigoUserDefaults.ErigoAvNowUser()
            }
        }
    }
    
    func ErigoAvHead() -> URL {
        let doc = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let headPath = doc.appendingPathComponent("ErigoHead").path
        return headPath
    }
}

// MARK: 相册拿取桥接
struct YPImagePickerVC: UIViewControllerRepresentable {
    
    let selectedMedia: (ErigoMediaM) -> Void
    
    let mediaOption: MEDIAOPTION
       
    enum MEDIAOPTION {
        
        case PHOTO
        
        case PHOTOANDVIDEO
    }

    func makeUIViewController(context: Context) -> YPImagePicker {
        var config = YPImagePickerConfiguration()
        if mediaOption == .PHOTO {
            config.screens = [.library, .photo]
            config.library.mediaType = .photo
        } else {
            config.screens = [.library, .photo, .video]
            config.library.mediaType = .photoAndVideo
        }

        let picker = YPImagePicker(configuration: config)

        picker.didFinishPicking { [unowned picker] items, cancelled in
            if cancelled {
                picker.dismiss(animated: true)
                return
            }
            
            for item in items {
                switch item {
                case .photo(let photo):
                    let imageData = photo.image.jpegData(compressionQuality: 1)
                    let media = ErigoMediaM(type: .IMAGE, img: photo.image, vUrl: nil, mData: imageData)
                    selectedMedia(media)
                case .video(let video):
                    do {
                        let videoData = try Data(contentsOf: video.url)
                        let media = ErigoMediaM(type: .VIDEO, img: video.thumbnail, vUrl: video.url, mData: videoData)
                        selectedMedia(media)
                    } catch {}
                }
            }
            picker.dismiss(animated: true)
        }

        return picker
    }

    func updateUIViewController(_ uiViewController: YPImagePicker, context: Context) {}
}

