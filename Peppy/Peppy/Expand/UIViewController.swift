//
//  UIViewController.swift
//  Peppy
//
//  Created by 北川 on 2025/4/15.
//

import Foundation
import SwiftUI

extension UIViewController {
    static func currentViewController() -> UIViewController? {
        var viewController = UIApplication.shared.windows.first?.rootViewController
        while let presentedViewController = viewController?.presentedViewController {
            viewController = presentedViewController
        }
        return viewController
    }
}
