//
//  PeppyLoadManager.swift
//  Peppy
//
//  Created by 北川 on 2025/4/10.
//

import Foundation
import ProgressHUD

// MARK: 加载器
class PeppyLoadManager {
    
    static func globalProgressConfig() {
        ProgressHUD.colorHUD = UIColor(hexstring: "#FFE250")
        ProgressHUD.colorAnimation = UIColor(hexstring: "#FEB700")
    }
    
    /// 加载
    static func dazzlProgressload() {
        ProgressHUD.animationType = .activityIndicator
        ProgressHUD.animate()
    }
    
    /// 消除
    static func dazzlProgressDismiss() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            ProgressHUD.dismiss()
        }
    }
    
    /// 提示: 失败、成功
    static func dazzlProgressShow(type : LiveIcon, text: String? = nil, delay: TimeInterval? = 1) {
        ProgressHUD.liveIcon(text, icon: type, interaction: true, delay: delay)
    }
    
    /// 提示
    static func dazzlProgressSymbol(text : String? = nil, name: String? = "exclamationmark.circle" , delay: TimeInterval? = 1) {
        ProgressHUD.symbol( _: text, name: name ?? "", interaction: true, delay: delay)
    }
    
}
