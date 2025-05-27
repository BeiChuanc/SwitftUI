import Foundation
import ProgressHUD

class BleoToast {
    
    class func BleoConfig() {
        ProgressHUD.colorHUD = .black
        ProgressHUD.colorAnimation = UIColor(hex: "#D1FF00")
    }
    
    class func Bleoload() {
        ProgressHUD.animationType = .activityIndicator
        ProgressHUD.animate()
    }
    
    class func Bleodismiss() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            ProgressHUD.dismiss()
        }
    }
    
    class func BleoShow(type : LiveIcon, text: String? = nil, delay: TimeInterval? = 1) {
        ProgressHUD.liveIcon(text, icon: type, interaction: true, delay: delay)
    }
    
    class func BleoNotice(text : String? = nil, name: String? = "exclamationmark.circle" , delay: TimeInterval? = 1) {
        ProgressHUD.symbol( _: text, name: name ?? "", interaction: true, delay: delay)
    }
}
