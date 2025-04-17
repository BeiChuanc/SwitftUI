import SwiftUI
import PhotosUI
import YPImagePicker

// MARK: 发布页面
struct PeppyTreePublishContentView: View {
    
    let goBack: () -> Void
    
    var userCurrent = PeppyUserManager.PEPPYCurrentUser()
    
    @State var fileCount: Int = 0
    
    @State var inputContent: String = ""
    
    @FocusState var isContent: Bool
    
    @State var showEula: Bool = false
    
    @State var isPuload: Bool = false
    
    @State var isVideo: Bool = false
    
    @State var showYMPicker: Bool = false
    
    @State var selectMedia: [PeppyMediaLibrary] = []
    
    @EnvironmentObject var loginM: PeppyLoginManager
    
    @EnvironmentObject var peppyRouter: PeppyRouteManager
    
    var body: some View {
        ZStack(alignment: .top) {
            Image("tree_publish").resizable()
                .ignoresSafeArea()
            VStack {
                VStack {
                    HStack {
                        Spacer()
                        Button(action: { // 本页回调
                            withAnimation(.bouncy) {
                                initData()
                                goBack()
                            }
                        }) {
                            Image("publish_back").frame(width: 25, height: 25)
                        }
                    }
                    .frame(width: peppyW - 80, height: 30)
                    .padding(.top, 20)
                    
                    HStack {
                        Image("publish_say").resizable()
                            .frame(width: 182, height: 15)
                            .padding(.leading, 20)
                            .padding(.top, 20)
                        Spacer()
                    }
                    
                    ZStack(alignment: .leading) { // 内容
                        if inputContent.isEmpty {
                            Text("SAY SOMETHING")
                                .foregroundColor(.white)
                               .font(.custom("Marker Felt", size: 20))
                               .padding(.horizontal, 20)
                               .offset(CGSize(width: 0, height: -20))
                        }
                        TextEditor(text: $inputContent)
                            .frame(height: 80)
                            .font(.custom("Marker Felt", size: 20))
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.leading)
                            .padding(.horizontal, 15)
                            .focused($isContent)
                            .scrollContentBackground(.hidden)
                            .textFieldStyle(PlainTextFieldStyle())
                    }
                    
                    HStack { // 媒体列表
                        if isPuload {
                            ZStack (alignment: .center) {
                                Image(uiImage: selectMedia[0].image!).resizable()
                                    .frame(width: 100, height: 100)
                                if isVideo {
                                    Button(action: {}) {
                                        Image("btnPlay")
                                    }
                                    .buttonStyle(InvalidButton())
                                }
                            }
                        }
                        
                        Button(action: {
                            showYMPicker = true
                        }) {
                            Image("publishUpload")
                        }.frame(width: 100, height: 100)
                            .sheet(isPresented: $showYMPicker) {
                                YPImagePickerView { media in
                                    selectMedia.removeAll()
                                    selectMedia.append(media)
                                    isVideo = selectMedia[0].type == .VIDEO
                                    showYMPicker = false
                                    isPuload = true
                                }
                            }
                        
                        Spacer()
                    }.padding(.horizontal, 20)
                    
                    Spacer()
                    
                    Button(action: { // 发布
                        print("上传")
                        
                        guard loginM.isLogin else {
                            peppyRouter.navigate(to: .LOGIN)
                            return
                        }
                        
                        guard !inputContent.isEmpty else {
                            isContent = true
                            return }
                        
                        guard !selectMedia.isEmpty else {
                            PeppyLoadManager.peppyProgressShow(type: .failed, text: "Please upload a media!")
                            return
                        }
                        
                        do {
                            let media = selectMedia[0]
                            let mediaUrl = try PeppyUserDataManager.peppySaveMedia(meida: media.meidaData!,
                                                                                   filePath: "\(fileCount + 1).\(media.type == .PITURE ? "png" : "mp4")",
                                                                                   mediaPath: "\(userCurrent.peppyId!)_publish")
                            let sendMedia = PeppyMyMedia(mediaId: fileCount + 1,
                                                         mediaUrl: mediaUrl,
                                                         mediaType: media.type,
                                                         mediaContent: inputContent,
                                                         mediaTime: PeppyComManager.peppyCurTimePublish())
                            PeppyUserManager.PEPPYUpdateUserDetails { pey in
                                pey.mediaList?.append(sendMedia)
                                return pey
                            }
                            PeppyUserDataManager.shared.myMediaList.append(sendMedia)
                            initData()
                            
                            PeppyLoadManager.peppyProgressShow(type: .succeed)
                            
                        } catch {}
                        
                    }) {
                        Image("btnRelease").resizable()
                            .frame(width: 147, height: 45)
                    }.frame(width: peppyW - 80, height: 50)
                        .padding(.top, 50)
                        .buttonStyle(InvalidButton())
                        .background(.clear)
                    
                    Spacer()
                }
                .frame(width: peppyW - 40, height: peppyH * 0.6)
                .background(Color(hex: "#F7BD0F"))
                .modifier(RoundedBorderStyle(cornerRadius: 20, borderColor: .black, borderWidth: 1))
                .padding(.top, 44)
                
                Button(action: { // EULA
                    showEula = true
                }) {
                    Image("btnEULA").resizable()
                        .frame(width: 40, height: 16)
                }
                .padding(.top, 10)
                .sheet(isPresented: $showEula) {
                    PeppyWebViewPage(url: URL(string: PEPPYPROTOCOL.PEPPYEULA)!)
                        .navigationBarTitleDisplayMode(.automatic)
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.001, execute: {
                print("发布也出现")
                if loginM.isLogin {
                    fileCount = getFileCount()
                    print("当前用户下文件个数为；\(fileCount)")
                }
            })
        }
    }
    
    func initData() {
        inputContent = ""
        showEula = false
        showYMPicker = false
        isPuload = false
        isVideo = false
        selectMedia.removeAll()
    }
    
    func getFileCount() -> Int {
        var fileCount: Int = 0
        do {
            fileCount = try PeppyUserDataManager.peppyGetMedias(mediaPath: "\(userCurrent.peppyId!)_publish")
        } catch {}
        return fileCount
    }
}


struct YPImagePickerView: UIViewControllerRepresentable {
    
    let didSelectMedia: (PeppyMediaLibrary) -> Void

    func makeUIViewController(context: Context) -> YPImagePicker {
        var config = YPImagePickerConfiguration()
        config.screens = [.library, .photo, .video]
        config.library.mediaType = .photoAndVideo

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
                    let media = PeppyMediaLibrary(type: .PITURE, image: photo.image, videoURL: nil, meidaData: imageData)
                    didSelectMedia(media)
                case .video(let video):
                    do {
                        let videoData = try Data(contentsOf: video.url)
                        let media = PeppyMediaLibrary(type: .VIDEO, image: video.thumbnail, videoURL: video.url, meidaData: videoData)
                        didSelectMedia(media)
                    } catch {
                        print("加载视频数据时出错: \(error)")
                    }
                }
            }
            picker.dismiss(animated: true)
        }

        return picker
    }

    func updateUIViewController(_ uiViewController: YPImagePicker, context: Context) {}
}
