import Foundation
import ProgressHUD

// MARK: 登陆管理器
class PeppyLoginManager: ObservableObject {
    
    static let shared = PeppyLoginManager()
    
    var loginUser: PeppyLoginMould = PeppyLoginMould()
    
    @Published var isLogin: Bool = false
    
    // 动物饱食度
    @Published var animalFullness: [[Int: Double]] = []
}

// MARK: 加载器
class PeppyLoadManager {
    
    /// 加载配置
    static func globalProgressConfig() {
        ProgressHUD.colorHUD = UIColor(hexstring: "#F7BD0F")
        ProgressHUD.colorAnimation = .black
    }
    
    /// 加载
    static func peppyProgressload() {
        ProgressHUD.animationType = .activityIndicator
        ProgressHUD.animate()
    }
    
    /// 加载并消除
    static func peppyLoading(backToRoot: @escaping () -> Void) {
        ProgressHUD.animationType = .activityIndicator
        ProgressHUD.animate()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            ProgressHUD.dismiss()
        })
        backToRoot()
    }
    
    /// 消除
    static func peppyProgressDismiss() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            ProgressHUD.dismiss()
        }
    }
    
    /// 提示: 失败、成功
    static func peppyProgressShow(type : LiveIcon, text: String? = nil, delay: TimeInterval? = 1) {
        ProgressHUD.liveIcon(text, icon: type, interaction: true, delay: delay)
    }
    
    /// 提示
    static func peppyProgressSymbol(text : String? = nil, name: String? = "exclamationmark.circle" , delay: TimeInterval? = 1) {
        ProgressHUD.symbol( _: text, name: name ?? "", interaction: true, delay: delay)
    }
    
}
