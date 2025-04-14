//
//  String.swift
//  Peppy
//
//  Created by 北川 on 2025/4/10.
//

import SwiftUI
import UIKit

extension Color {
    
    init(hex: String, alpha: CGFloat = 1.0) {
        
        var hexSanitized = hex.trimmingCharacters(in:.whitespacesAndNewlines)
        
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = Double((rgb & 0xFF0000) >> 16) / 255.0
        let green = Double((rgb & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgb & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, opacity: alpha)
    }
}

extension UIColor {
    
    convenience init(hexstring: String, alpha: CGFloat = 1.0) {
        
        var cgString = hexstring.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
    
        if cgString.hasPrefix("#") {
            cgString = String(cgString.dropFirst())
        }
        
        
        guard cgString.count == 6 else {
            self.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
            return
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: cgString).scanHexInt64(&rgbValue)
        
        let r = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(rgbValue & 0x0000FF) / 255.0
        
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
}
