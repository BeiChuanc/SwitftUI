import Foundation
import ProgressHUD

class UvooLoadVM {
    
    class func UvooConfig() {
        ProgressHUD.colorHUD = .black
        ProgressHUD.colorAnimation = UIColor(hex: "#D1FF00")
    }
    
    class func Uvooload() {
        ProgressHUD.animationType = .activityIndicator
        ProgressHUD.animate()
    }
    
    class func Uvoodismiss() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            ProgressHUD.dismiss()
        }
    }
    
    class func UvooShow(type : LiveIcon, text: String? = nil, delay: TimeInterval? = 1) {
        ProgressHUD.liveIcon(text, icon: type, interaction: true, delay: delay)
    }
    
    class func UvooNotice(text : String? = nil, name: String? = "exclamationmark.circle" , delay: TimeInterval? = 1) {
        ProgressHUD.symbol( _: text, name: name ?? "", interaction: true, delay: delay)
    }
}
