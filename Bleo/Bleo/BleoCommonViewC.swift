import Foundation
import YPImagePicker
import Photos
import UIKit

class BleoCommonViewC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
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
        gradientLayer.frame = bt.bounds
        bt.layer.insertSublayer(gradientLayer, at: 0)
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
    
    func BleoUploadMedia() {
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
            present(picker, animated: true)
        }
    }
}

