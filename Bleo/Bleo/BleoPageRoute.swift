import Foundation
import UIKit

protocol Routable {
    
    associatedtype Model
    
    func configure(with model: Model)
}

protocol RoutableParameter {
    
    func configure(with parameters: [String: Any])
}

final class BleoPageRoute {
    
    private init() {}
    
    static var currentVC: UIViewController? {
        guard let scene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
              let window = scene.windows.first(where: { $0.isKeyWindow }),
              let root = window.rootViewController else {
            return nil
        }
        return findVC(from: root)!
    }
    
}

extension BleoPageRoute {

    static func BleoRootVC(In window: UIWindow) {
        let vc = BleoTabarViewC()
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .overFullScreen
        window.rootViewController = Navigationcontroller(rootViewController: vc)
    }
    
    static func BleoLoginIn() {
        push(BleoLandViewC())
    }
    
    static func Bleoregister() {
        push(BleoRegisterViewC())
    }
    
    static func BleoWebLink(link: String = ProtocolLink.TERMLINK) {
        navigate(BleoWebLinkViewC.self, with: ["url": link])
    }
    
    static func BleoUploadCarCom() {
        push(BleoAddComponentViewC())
    }
    
    static func BleoAddMain() {
        push(BleoAddMaintenanceViewC())
    }
    
    static func BleoViewsMod() {
        push(BleoViewsModpomentViewC())
    }
    
    static func BleoSetttingView() {
        push(BleoPersonalSettingViewC())
    }
}

extension BleoPageRoute {
    
    static func navigate<T: UIViewController & RoutableParameter>(_ vcType: T.Type, with parm: [String: Any], animated: Bool = true) {
        let vc = vcType.init()
        vc.configure(with: parm)
        push(vc, animated: animated)
    }
    
    static func navigate<T: UIViewController & Routable>(_ vcType: T.Type, with model: T.Model, animated: Bool = true) {
        let vc = vcType.init()
        vc.configure(with: model)
        push(vc, animated: animated)
    }
    
    static func present<T: UIViewController & Routable>(_ vcType: T.Type, with model: T.Model, animated: Bool = true) {
        let vc = vcType.init()
        vc.configure(with: model)
        present(vc, animated: animated)
    }
    
    static func push(_ vc: UIViewController, animated: Bool = true) {
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .overFullScreen
        currentVC?.navigationController?.pushViewController(vc, animated: animated)
    }
    
    static func present(_ vc: UIViewController, animated: Bool = true) {
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .overFullScreen
        currentVC?.present(vc, animated: animated)
    }
    
    static func backToLevel() {
        currentVC?.navigationController?.popViewController(animated: true)
    }
    
    static func dismissToLevel() {
        currentVC?.dismiss(animated: true)
    }
    
    static func backToRoot() {
        currentVC?.navigationController?.popToRootViewController(animated: true)
    }
    
    static func findVC(from vc: UIViewController?) -> UIViewController? {
        if let nav = vc as? UINavigationController {
            return findVC(from: nav.visibleViewController)
        } else if let tab = vc as? UITabBarController {
            return findVC(from: tab.selectedViewController)
        } else if let presented = vc?.presentedViewController {
            return findVC(from: presented)
        }
        return vc
    }
}
