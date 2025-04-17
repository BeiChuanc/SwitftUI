import Foundation
import SwiftUI

extension UIViewController {
    static func currentViewController() -> UIViewController? {
        let windowScene = UIApplication.shared.connectedScenes
           .first { $0.activationState == .foregroundActive } as? UIWindowScene
        var viewController = windowScene?.windows.first?.rootViewController
        while let presentedViewController = viewController?.presentedViewController {
            viewController = presentedViewController
        }
        return viewController
    }
}
