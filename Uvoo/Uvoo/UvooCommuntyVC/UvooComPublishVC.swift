import UIKit
import YPImagePicker

struct UvooMediaM {
    
    let type: Bool?
    
    let cover: UIImage?
    
    let mediaData: Data?
    
    let mediaUrl: URL?
}


class UvooComPublishVC: UvooTopVC {

    @IBOutlet weak var publishBack: UIButton!

    @IBOutlet weak var release_media: UIButton!

    @IBOutlet weak var title_view: UIView!

    @IBOutlet weak var media_cover: UIImageView!

    @IBOutlet weak var upload_media: UIButton!

    @IBOutlet weak var input_title: UITextField!

    @IBOutlet weak var input_content: UITextView!

    @IBOutlet weak var isContent: UILabel!

    @IBOutlet weak var eula_show: UIButton!

    var publishMedia: [UvooMediaM] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        UvooSetPublishView()
    }

    func UvooSetPublishView() {
        publishBack.addTarget(
            self, action: #selector(previous), for: .touchUpInside)
        upload_media.addTarget(
            self, action: #selector(uploadOnTap), for: .touchUpInside)
        release_media.addTarget(
            self, action: #selector(releaseOnTap), for: .touchUpInside)
        eula_show.addTarget(
            self, action: #selector(showEula), for: .touchUpInside)

        media_cover.layer.cornerRadius = 15
        media_cover.layer.masksToBounds = true
        input_title.leftPadding(10)
        input_title.placeHolderColor(UIColor(hex: "#FFFFFF", alpha: 0.37))
        input_content.delegate = self
    }

    func UvooGetMediaCover() {

    }

    @objc func uploadOnTap() {
        var configuration = YPImagePickerConfiguration()
        configuration.screens = [.library]
        configuration.library.mediaType = .photoAndVideo
        let picker = YPImagePicker(configuration: configuration)
        
        picker.didFinishPicking { [self, unowned picker] item, cancelled in
            if cancelled {
                picker.dismiss(animated: true)
                return
            }
            
            if let photo = item.singlePhoto {
                let isVideo = false
                let coverImage = photo.image
                
                var imageData: Data?
                if let editedImage = photo.modifiedImage {
                    imageData = editedImage.jpegData(compressionQuality: 0.8)
                } else {
                    imageData = photo.originalImage.jpegData(compressionQuality: 0.8)
                }
                
                let mediaModel = UvooMediaM( type: isVideo, cover: coverImage, mediaData: imageData, mediaUrl: photo.url)
                media_cover.isHidden = false
                media_cover.image = coverImage
                upload_media.isHidden = true
                publishMedia.removeAll()
                publishMedia.append(mediaModel)
                
            } else if let video = item.singleVideo {
                let isVideo = true
                let coverImage = video.thumbnail
                
                let videoUrl = video.url
                let videoData = try? Data(contentsOf: video.url)
                let mediaModel = UvooMediaM( type: isVideo, cover: coverImage, mediaData: videoData, mediaUrl: videoUrl)
                media_cover.isHidden = false
                media_cover.image = coverImage
                upload_media.isHidden = true
                publishMedia.removeAll()
                publishMedia.append(mediaModel)
            }
            
            picker.dismiss(animated: true)
        }
        UvooPermissionUtils.UvooCheckLibPermisson(true) { [self] isOpen in
            present(picker, animated: true)
        }
    }

    @objc func releaseOnTap() {
        guard !publishMedia.isEmpty else {
            UIAlertController.show(message: "Please upload a media.") {}
            return
        }

        guard let title = input_title.text, !title.isEmpty else {
            input_title.becomeFirstResponder()
            return
        }

        guard let content = input_content.text, !content.isEmpty else {
            input_content.becomeFirstResponder()
            return
        }

        guard UvooLoginVM.shared.isLand else {
            UvooRouteUtils.UvooLogin()
            return }
        let meData = UvooUserDefaultsUtils.UvooGetUserInfo()
        
        defer {
            input_title.text = nil
            input_title.text = nil
            publishMedia.removeAll()
            media_cover.isHidden = true
            media_cover.image = nil
            upload_media.isHidden = false
        }
        
        do {
            
            let countM = meData!.title.count
            let isVip = UvooUserDefaultsUtils.UvooGetVIP()
            if !isVip, countM > 2 {
                UvooLoadVM.UvooShow(type: .failed, text: "Activate VIP to unlock posting.")
                return
            }
            
            let count = try PostManager.shared.UvooGetMeMedia(mediaFolder: "Uvoo\(meData!.uId)") + meData!.uId
            let isVideo = publishMedia[0].type!
            let url = try PostManager.shared.UvooSaveMedia(meidaData: publishMedia[0].mediaData!,
                                                           fileName: "\(isVideo ? "\(count).mp4" : "\(count).png")", mediaFolder: "Uvoo\(meData!.uId)")
            let publishModel = UvooPublishM(tId: count, bId: meData!.uId, head: "", name: meData!.name, title: title, content: content, cover: ["\(url)"], imags: [], isVideo: publishMedia[0].type!, likes: 0, comment: [])
            PostManager.shared.UvooSaveMePost(post: publishModel)
            UvooUserDefaultsUtils.UvooUpdateUserInfo { model in
                model.title.append(publishModel)
            }
            UvooLoadVM.UvooShow(type: .succeed)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
                previous()
            }
        } catch {}
    }

    @objc func showEula() {
        UvooRouteUtils.UvooWebView(url: UvooUrl.eula)
    }
}

extension UvooComPublishVC: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        if textView.text.isEmpty {
            isContent.isHidden = false
        } else {
            isContent.isHidden = true
        }
    }
}
