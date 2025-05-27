import UIKit
import IQKeyboardManager


@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().shouldResignOnTouchOutside = true
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        BleoPageRoute.BleoRootVC(In: window!)
        
        Bleo_LoginInit()
        return true
    }

    func Bleo_LoginInit() {
        BleoToast.BleoConfig()
        BleoTransData.shared.BleoInitTitleData()
        BleoTransData.shared.BleoGetUsers()
        BleoTransData.shared.BleoGetTitles()
        
    }
}

