import UIKit
import IQKeyboardManager

enum UvooScreen {
    
    static var width: CGFloat { return UIScreen.main.bounds.width }
    
    static var height: CGFloat { return UIScreen.main.bounds.height }
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().shouldResignOnTouchOutside = true
        
        PostManager.shared.UvooInitPostData()
        UvooLoginVM.shared.UvooLoadUser()
        UvooLoginVM.shared.UvooLoadTitles()
        UvooLoadVM.UvooConfig()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        UvooRouteUtils.UvooLearn(window: window!)
        
        return true
    }
}

