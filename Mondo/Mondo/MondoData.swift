//
//  MondoData.swift
//  Mondo
//
//  Created by 北川 on 2025/4/27.
//

import Foundation
import UIKit
import SwiftUI

// MARK: 协议
enum MONDOPROTOC {
    
    static var TERMS:   String { return "https://www.freeprivacypolicy.com/live/a9f8a0ac-c6bd-4ce3-b64c-d8b49f269e78" }
    
    static var PRIVACY: String { return "https://www.freeprivacypolicy.com/live/c3a01fcb-c650-43be-96db-a031b2164f0d" }
    
    static var EULA:    String { return "https://www.freeprivacypolicy.com/live/6917f93b-e34d-420f-ba16-d767853b3fa3" }
}

// MARK: 屏幕
enum MONDOSCREEN {
    
    static var WIDTH: CGFloat { return UIScreen.main.bounds.width }
    
    static var HEIGHT: CGFloat { return UIScreen.main.bounds.height }
}

// MARK: 状态
enum MONDOSTATUS {
    
    case LOAD
    
    case COMPLETE
    
    case FAIL
}

// MARK: 十六进制颜色 - SwiftUI
extension Color {
    
    init(hex: String, alpha: CGFloat = 1.0) {
        let hex = hex.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "#", with: "")
        var rgb: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&rgb)
        self.init(
            red: Double((rgb & 0xFF0000) >> 16) / 255.0,
            green: Double((rgb & 0x00FF00) >> 8) / 255.0,
            blue: Double(rgb & 0x0000FF) / 255.0,
            opacity: alpha
        )
    }
}

// MARK: 十六进制颜色 - UIKit
extension UIColor {
    
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hex = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if hex.hasPrefix("#") {
            hex.removeFirst()
        }
        
        guard hex.count == 6, let rgbValue = UInt64(hex, radix: 16) else {
            self.init(white: 0, alpha: 1)
            return
        }
        
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}


// MARK: 输入框字内间距
extension UITextField {
    
    func leftPadding(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}

// MARK: 隐藏顶部导航
extension View {
    
    func mondoHidBack() -> some View {
        modifier(MondoHidBack())
    }
}
