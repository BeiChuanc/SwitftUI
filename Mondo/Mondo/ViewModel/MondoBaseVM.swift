//
//  MondoBaseVM.swift
//  Mondo
//
//  Created by 北川 on 2025/4/29.
//

import Foundation
import ProgressHUD

class MondoBaseVM {
    
    /// 加载配置
    static func MondoConfig() {
        ProgressHUD.colorHUD = .black
        ProgressHUD.colorAnimation = .white
    }
    
    /// 加载
    static func Mondoload() {
        ProgressHUD.animationType = .activityIndicator
        ProgressHUD.animate()
    }
    
    /// 加载并消除
    static func MondoLoading(backToRoot: @escaping () -> Void) {
        ProgressHUD.animationType = .activityIndicator
        ProgressHUD.animate()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            ProgressHUD.dismiss()
        })
        backToRoot()
    }
    
    /// 消除
    static func MondoDismiss() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            ProgressHUD.dismiss()
        }
    }
    
    /// 提示: 失败、成功
    static func MondoShow(type : LiveIcon, text: String? = nil, delay: TimeInterval? = 1) {
        ProgressHUD.liveIcon(text, icon: type, interaction: true, delay: delay)
    }
    
    /// 提示
    static func MondoSymbol(text : String? = nil, name: String? = "exclamationmark.circle" , delay: TimeInterval? = 1) {
        ProgressHUD.symbol( _: text, name: name ?? "", interaction: true, delay: delay)
    }
}
