import Foundation
import YPImagePicker
import Photos
import UIKit

class BleoCommonViewC: UIViewController {
    
    var isLogin: Bool {
        get {
            return BleoTransData.shared.isLoginIn
        }
    }
    
    var userMy: BleoMyDetailM {
        get {
            return BleoTransData.shared.userMy
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        NotificationCenter.default.addObserver(self, selector: #selector(BleoLoadMyInfo), name: Notification.Name("updateUser"), object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func BleoLoadMyInfo() {
        BleoTransData.shared.userMy = BleoPrefence.BleoGetCurUserData()
    }
    
    func BleoSetViewBorder(In view: UIView, width: CGFloat, colors: [UIColor], cornerRadius: CGFloat = 0) {
        view.layer.sublayers?.forEach { if $0.name == "gradientBorder" { $0.removeFromSuperlayer() } }

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        
        let path = UIBezierPath(roundedRect: view.bounds.insetBy(dx: width/2, dy: width/2), cornerRadius: cornerRadius)
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        mask.fillColor = UIColor.clear.cgColor
        mask.strokeColor = UIColor.black.cgColor
        mask.lineWidth = width
        mask.frame = view.bounds
        
        gradientLayer.mask = mask
        gradientLayer.name = "gradientBorder"
        
        view.layer.cornerRadius = cornerRadius
        view.layer.masksToBounds = true
        
        view.layer.addSublayer(gradientLayer)
    }
    
    func BleoSetBtGradient(In bt: UIButton, colors: [UIColor]) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: ScreenSize.W, height: bt.frame.height)
        bt.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func BleoGetTimeNow() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd"
        let currentDate = Date()
        return dateFormatter.string(from: currentDate)
    }
    
    func BleoUploadImage(completion: ((_ image: UIImage) -> Void)? = nil) {
        var configuration = YPImagePickerConfiguration()
        configuration.screens = [.library]
        configuration.library.mediaType = .photo
        let picker = YPImagePicker(configuration: configuration)
        
        picker.didFinishPicking { [unowned picker] item, cancelled in
            if cancelled {
                picker.dismiss(animated: true)
                return
            }
            
            if let photo = item.singlePhoto {
                let coverImage = photo.image
                completion!(coverImage)
                picker.dismiss(animated: true)
            }
        }
        present(picker, animated: true)
    }
    
    func BleoUploadMedia(completion: @escaping () -> Void) {
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
                let coverImage = photo.image
                picker.dismiss(animated: true)
            } else if let video = item.singleVideo {
                
            }
        }
        present(picker, animated: true)
    }
}

