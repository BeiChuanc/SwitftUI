import Foundation
import UIKit
import Photos

class UvooPermissionUtils {
    
    class func UvooCheckLibPermisson(_ isSet: Bool? = nil,_ call: @escaping ((Bool)->())) {
        PHPhotoLibrary.requestAuthorization { status in
            DispatchQueue.main.async {
                var isOpen = true
                if status == .restricted || status == .denied {
                    isOpen = false
                    if isSet == true {
                        let url = URL(string: UIApplication.openSettingsURLString)
                        let photoAlter = UIAlertController(title: "Limited access to photos",
                                                                message: "Click \"Settings\", allowing access to your photos",
                                                                preferredStyle: .alert)
                        let cancel = UIAlertAction(title:NSLocalizedString("Cancel", comment: ""), style: .cancel, handler:nil)
                        let set = UIAlertAction(title:NSLocalizedString("Setting", comment: ""), style: .default, handler: {
                            (action) -> Void in
                            if  UIApplication.shared.canOpenURL(url!) {
                                UIApplication.shared.open(url!, options: [:],completionHandler: {(success) in})
                            }
                        })
                        
                        photoAlter.addAction(cancel)
                        photoAlter.addAction(set)
                        UIViewController.currentVC()?.present(photoAlter, animated: true, completion: nil)
                    }
                } else if status == .limited {
                    isOpen = true
                }
                call(isOpen)
            }
        }
    }
}
