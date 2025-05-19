import Foundation
import UIKit

class UvooRouteUtils {
    
    class func UvooLogin() {
        let vc = UvooComLoginVC()
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .fullScreen
        UIViewController.currentVC()?.navigationController?.pushViewController(vc, animated: true)
    }
    
    class func UvooRegister() {
        let vc = UvooComRegisterVC()
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .fullScreen
        UIViewController.currentVC()?.navigationController?.pushViewController(vc, animated: true)
    }
    
    class func UvooLearn(window: UIWindow) {
        let vc = UvooTabbBottomVC(nibName: nil, bundle: nil)
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .fullScreen
        window.rootViewController = UINavigationController(rootViewController: vc)
    }
    
    class func UvooShowPopular(select: Int) {
        let vc = UvoodiyShowScienceVC()
        vc.selectShow = select
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .fullScreen
        UIViewController.currentVC()?.navigationController?.pushViewController(vc, animated: true)
    }
    
    class func UvooShowDesign(select: Int) {
        let vc = UvooDiyDesignVC()
        vc.selectDeisgn = select
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .fullScreen
        UIViewController.currentVC()?.navigationController?.pushViewController(vc, animated: true)
    }
    
    class func UvooGenShow(genModel: UvooLibM) {
        let vc = UvooDiyGenDesignVC()
        vc.genModel = genModel
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .fullScreen
        UIViewController.currentVC()?.navigationController?.pushViewController(vc, animated: true)
    }
    
    class func UvooGenDisplay() {
        let vc = UvooDiyDisplayVC()
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .fullScreen
        UIViewController.currentVC()?.navigationController?.pushViewController(vc, animated: true)
    }
    
    class func UvooShowDetail(model: UvooPublishM) {
        let vc = UvooComTitleDetailVC()
        vc.titleModel = model
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .fullScreen
        UIViewController.currentVC()?.navigationController?.pushViewController(vc, animated: true)
    }
    
    class func UvooPublish() {
        let vc = UvooComPublishVC()
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .fullScreen
        UIViewController.currentVC()?.navigationController?.pushViewController(vc, animated: true)
    }
    
    class func UvooWebView(url: String) {
        let vc = UvooWebViewUtils()
        vc.webUrl = url
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .fullScreen
        UIViewController.currentVC()?.navigationController?.pushViewController(vc, animated: true)
    }
    
    class func UvooEditView() {
        let vc = UvooMeEditVC()
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .fullScreen
        UIViewController.currentVC()?.navigationController?.pushViewController(vc, animated: true)
    }
    
    class func UvooSetView() {
        let vc = UvooMeSetVC()
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .fullScreen
        UIViewController.currentVC()?.navigationController?.pushViewController(vc, animated: true)
    }
    
    class func UvooUserInfo(user: UvooDiyUserM) {
        let vc = UvooUserInfoViewVC()
        vc.userInfo = user
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .fullScreen
        UIViewController.currentVC()?.navigationController?.pushViewController(vc, animated: true)
    }
    
    class func UvooMe() {
        let vc = UvooMeViewVC()
        vc.meSet.isHidden = true
        vc.meBack.isHidden = false
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .fullScreen
        UIViewController.currentVC()?.navigationController?.pushViewController(vc, animated: true)
    }
    
    class func UvooPlayerShow(title: UvooPublishM, isMe: Bool = false) {
        let vc = UvooMePlayVideoVC()
        vc.titleModel = title
        vc.isMe = isMe
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .fullScreen
        UIViewController.currentVC()?.navigationController?.pushViewController(vc, animated: true)
    }
    
    class func UvooShowComment(title: UvooPublishM) {
        let vc = UvooShowComVC()
        vc.comData = title
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .overFullScreen
        UIViewController.currentVC()?.present(vc, animated: true)
    }
}
