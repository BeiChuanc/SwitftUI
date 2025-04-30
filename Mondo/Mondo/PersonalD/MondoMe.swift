//
//  MondoMe.swift
//  Mondo
//
//  Created by 北川 on 2025/4/28.
//

import SwiftUI
import YPImagePicker
import Kingfisher

// MARK: 个人中心
struct MondoMe: View {
    
    @State var monMe = MondoMeM()
    
    @State var followers: Int = 0
    
    @State var fans: Int = 0
    
    @State var groups: Int = 0
    
    @State var publishedPicture: Bool = true
    
    @State var isEmpty: Bool = true
    
    @State var isUpload: Bool = false
    
    @State var uploadImage: UIImage?
    
    @ObservedObject var monLogin = MondoUserVM.shared
    
    @EnvironmentObject var pageControl: MondoPageControl
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Image("personal_bg").resizable()
            ZStack {
                VStack {}.frame(width: MONDOSCREEN.WIDTH, height: MONDOSCREEN.HEIGHT * 0.72)
                    .background(.white)
                    .clipShape(MondoRoundItem(radius: 10, corners: [.topLeft, .topRight]))
                VStack {
                    HStack {
                        if monLogin.loginIn {
                            if let image = uploadImage {
                                Image(uiImage: image).resizable().scaledToFill() // 个人头像
                                    .frame(width: 62, height: 62)
                                    .clipShape(RoundedRectangle(cornerRadius: 31))
                            } else {
                                Image("monder").resizable().scaledToFill() // 个人头像
                                    .frame(width: 62, height: 62)
                                    .clipShape(RoundedRectangle(cornerRadius: 31))
                            }
                        } else {
                            Image("monder").resizable().scaledToFill() // 个人头像
                                .frame(width: 62, height: 62)
                                .clipShape(RoundedRectangle(cornerRadius: 31))
                        }
                        Spacer()
                    }
                    
                    HStack(spacing: 30) {
                        Text(monMe.name.isEmpty ? "Guest" : monMe.name) // 用户昵称
                            .font(.custom("PingFangSC-Semibold", size: 20))
                            .foregroundStyle(Color(hex: "#111111"))
                        Button(action: { // 上传头像
                            if monLogin.loginIn {
                                isUpload = true
                            } else {
                                pageControl.route(to: .LOGIN)
                            }
                        }) { Image("uploadHead") }
                            .sheet(isPresented: $isUpload) {
                                YPImagePickerVC(selectedMedia: { cover in
                                    let doc = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                                    let headName = "Mondo\(monMe.uid).jpg"
                                    let headURL = doc.appendingPathComponent(headName)
                                    if let headData = cover.img.jpegData(compressionQuality: 0.8) {
                                        do {
                                            try headData.write(to: headURL)
                                            MondoCacheVM.MondoFixDetails { erigo in
                                                erigo.head = headURL.path
                                                return erigo
                                            }
                                            DispatchQueue.main.async {
                                                MondoAvHead()
                                            }
                                        } catch {}
                                    }
                                }, mediaOption: .PHOTO)
                            }
                        
                        Spacer()
                        Button(action: {
                            pageControl.route(to: .SET)
                        }) { Image("btnSet") }
                    }
                    
                    HStack(spacing: 25) { // 关注 & 粉丝 & 群聊
                        Text("\(monMe.follower.count) Followers")
                            .font(.custom("PingFangSC-Regular", size: 12))
                            .foregroundStyle(Color(hex: "#111111"))
                        
                        Text("\(monMe.fans.count) Fans")
                            .font(.custom("PingFangSC-Regular", size: 12))
                            .foregroundStyle(Color(hex: "#111111"))
                        
                        Text("\(monMe.join.count) Group Chats")
                            .font(.custom("PingFangSC-Regular", size: 12))
                            .foregroundStyle(Color(hex: "#111111"))
                        Spacer()
                    }
                    
                    HStack(spacing: 25) {
                        Button(action: { withAnimation { publishedPicture = true } }) { Image("publishImage") } // 图片
                            .opacity(publishedPicture ? 1 : 0.6)
                            .buttonStyle(MondoReEffort())
                            .background(content: { Image("wel_print")
                                    .opacity(publishedPicture ? 1 : 0)
                                    .animation(.easeIn(duration: 0.3), value: publishedPicture)
                            })
                        Button(action: { withAnimation { publishedPicture = false } }) { Image("publishVideo") } // 视频
                            .opacity(publishedPicture ? 0.6 : 1)
                            .buttonStyle(MondoReEffort())
                            .background(content: { Image("wel_print")
                                    .opacity(publishedPicture ? 0 : 1)
                                    .animation(.easeIn(duration: 0.3), value: publishedPicture)
                            })
                        Spacer()
                    }.padding(.top, 25)
                    
                    // 相册
                    VStack {
                        if publishedPicture {
                            ZStack {
                                ScrollView(showsIndicators: false) {
                                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) { // 数据
                                        ForEach(monMe.publishImage) { item in
                                            let mediaUrl = URL(fileURLWithPath: item.media!)
                                            KFImage(mediaUrl)
                                                .scaledToFill()
                                                .frame(width: (MONDOSCREEN.WIDTH - 44) / 2, height: (MONDOSCREEN.WIDTH - 44) / 2 * 1.3)
                                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                                .onTapGesture {
                                                    pageControl.route(to: .SHOWDETAILME(item))
                                                }
                                        }
                                    }
                                }
                                if monMe.publishImage.count == 0 {
                                    VStack(spacing: 20) {
                                        Image("noData")
                                        Text("No data yet")
                                            .font(.custom("PingFangSC-Regular", size: 14))
                                            .foregroundStyle(Color(hex: "#111111"))
                                    }
                                }
                            }
                        } else {
                            ZStack {
                                ScrollView(showsIndicators: false) {
                                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) { // 数据
                                        ForEach(monMe.publishVideo) { item in
                                            if let image = MondoUserVM.shared.MondoAvVideoThumb(myTitle: item) {
                                                ZStack {
                                                    Image(uiImage: image)
                                                        .resizable()
                                                        .scaledToFill()
                                                        .frame(width: (MONDOSCREEN.WIDTH - 44) / 2, height: (MONDOSCREEN.WIDTH - 44) / 2 * 1.3)
                                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                                    Image("btnPlay")
                                                        .buttonStyle(MondoReEffort())
                                                }
                                                .onTapGesture {
                                                    pageControl.route(to: .SHOWDETAILME(item))
                                                }
                                            }
                                        }
                                    }
                                }
                                if monMe.publishVideo.count == 0 {
                                    VStack(spacing: 20) {
                                        Image("noData")
                                        Text("No data yet")
                                            .font(.custom("PingFangSC-Regular", size: 14))
                                            .foregroundStyle(Color(hex: "#111111"))
                                    }
                                }
                            }
                        }
                    }
                    
                    Spacer()
                }.frame(width: MONDOSCREEN.WIDTH - 32, height: MONDOSCREEN.HEIGHT * 0.78)
            }
        }.ignoresSafeArea()
            .onAppear {
                if monLogin.loginIn {
                    monMe = MondoCacheVM.MondoAvCurUser()
                    MondoAvHead()
                }
            }
    }
    
    /// 获取头像
    func MondoAvHead() {
        uploadImage = MondoUserVM.shared.MondoAvHead(uid: monMe.uid)
    }
}

// MARK: 相册拿取桥接
struct YPImagePickerVC: UIViewControllerRepresentable {
    
    let selectedMedia: (MondoLibM) -> Void
    
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
                    let media = MondoLibM(type: 0, img: photo.image, vUrl: nil, mData: imageData)
                    selectedMedia(media)
                case .video(let video):
                    do {
                        let videoData = try Data(contentsOf: video.url)
                        let media = MondoLibM(type: 1, img: video.thumbnail, vUrl: video.url, mData: videoData)
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
