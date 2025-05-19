import UIKit
import PhotosUI

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
    
    var publishMedia: [UIImage] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UvooSetPublishView()
    }
    
    func UvooSetPublishView() {
        publishBack.addTarget(self, action: #selector(previous), for: .touchUpInside)
        upload_media.addTarget(self, action: #selector(uploadOnTap), for: .touchUpInside)
        release_media.addTarget(self, action: #selector(releaseOnTap), for: .touchUpInside)
        eula_show.addTarget(self, action: #selector(showEula), for: .touchUpInside)
        
        media_cover.layer.cornerRadius = 15
        media_cover.layer.masksToBounds = true
        input_title.leftPadding(10)
        input_title.placeHolderColor(UIColor(hex: "#FFFFFF", alpha: 0.37))
        input_content.delegate = self
    }
    
    func UvooGetMediaCover() {
        
    }
    
    @objc func uploadOnTap() {
        
        var config = PHPickerConfiguration()
        config.filter = .any(of: [.videos, .images])
        config.selectionLimit = 0
        let picker = PHPickerViewController(configuration: config)
        UvooPermissionUtils.UvooCheckLibPermisson(true) { isOpen in
            picker.delegate = self
            self.present(picker, animated: true)
        }
    }
    
    @objc func releaseOnTap() {
        guard publishMedia.isEmpty else {
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


extension UvooComPublishVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) { [self] in
            let libImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            media_cover.isHidden = false
            media_cover.image = libImage
            upload_media.isHidden = true
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}


extension UvooComPublishVC: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        for result in results {
            let itemProvider = result.itemProvider
            itemProvider.canLoadObject(ofClass: UIImage.self)
            itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                if let image = image as? UIImage {
                    // 在这里处理选中的图片
                } else if let error = error {
                    print("Error loading image: \(error)")
                }
            }
        }
    }
}
