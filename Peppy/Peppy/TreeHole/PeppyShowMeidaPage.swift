import SwiftUI
import Kingfisher
import AVFoundation

// MARK: 我的媒体子项
struct PeppyShowMeidaPage: View {
    
    var myMediaData: PeppyMyMedia
    
    var goShowDetils: () -> Void
    
    var goDelete: () -> Void
    
    var userCurrent = PeppyUserManager.PEPPYCurrentUser()
    
    @State var thumbnailImage: UIImage?
    
    var body: some View {
        VStack {
            Image("img_cell_media").padding(.bottom, -10)
            VStack() {
                HStack {
                    // 左
                    VStack {
                        PeppyUserHeadContentView(head: userCurrent.head ?? "",
                                                 headBgColor: userCurrent.headColor ?? "",
                                                 headFrame: 48.0)
                        Spacer()
                    }
                    Spacer()
                    VStack {
                        
                        if myMediaData.mediaType == .PITURE { // 图片
                            KFImage(myMediaData.mediaUrl)
                                .resizable()
                                .frame(height: 156)
                                .modifier(RoundedBorderStyle(cornerRadius: 20, borderColor: .black, borderWidth: 1))
                        } else {
                            ZStack (alignment: .center) { // 视频封面
                                
                                if let img = thumbnailImage {
                                    Image(uiImage: img)
                                        .scaledToFill()
                                        .frame(width: peppyW - 140, height: 156)
                                        .modifier(RoundedBorderStyle(cornerRadius: 20, borderColor: .black, borderWidth: 1))
                                }
                                
                                Button(action: {}) {
                                    Image("btnPlay").resizable()
                                        .frame(width: 25, height: 25)
                                }.buttonStyle(InvalidButton())
                            }
                        }
                        
                        Text(myMediaData.mediaContent!) //媒体内容
                            .font(.custom("PingFang SC", size: 12))
                            
                        HStack {
                            Spacer()
                            Button(action: {
                                goDelete()
                            }) {
                                Image("btndelete").frame(width: 30, height: 30)
                            }
                            Text(myMediaData.mediaTime!) // 时间
                                .font(.custom("PingFang SC", size: 12))
                        }
                    }
                }.padding(20)
            }
            .frame(width: peppyW - 40, height: 260)
            .background(.white)
            .modifier(RoundedBorderStyle(cornerRadius: 20, borderColor: .black, borderWidth: 2))
        }
        .onTapGesture {
            goShowDetils()
        }
        .onAppear {
            loadPeppyThumbnail()
        }
    }
    
    func loadPeppyThumbnail() {
        guard myMediaData.mediaType == .VIDEO else { return }
        let asset = AVAsset(url: myMediaData.mediaUrl!)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        
        do {
            let thumbnailTime = CMTimeMake(value: 1, timescale: 60)
            let cgImage = try imageGenerator.copyCGImage(at: thumbnailTime, actualTime: nil)
            thumbnailImage = UIImage(cgImage: cgImage)
        } catch {
            print("获取视频封面时出错: \(error)")
        }
    }
}
