//
//  ErigoProgressVM.swift
//  Erigo
//
//  Created by 北川 on 2025/4/24.
//

import Foundation
import ProgressHUD

class ErigoProgressVM {
    
    /// 加载配置
    static func ErigoConfig() {
        ProgressHUD.colorHUD = .black
        ProgressHUD.colorAnimation = .white
    }
    
    /// 加载
    static func Erigoload() {
        ProgressHUD.animationType = .activityIndicator
        ProgressHUD.animate()
    }
    
    /// 加载并消除
    static func ErigoLoading(backToRoot: @escaping () -> Void) {
        ProgressHUD.animationType = .activityIndicator
        ProgressHUD.animate()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            ProgressHUD.dismiss()
        })
        backToRoot()
    }
    
    /// 消除
    static func ErigoDismiss() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            ProgressHUD.dismiss()
        }
    }
    
    /// 提示: 失败、成功
    static func ErigoShow(type : LiveIcon, text: String? = nil, delay: TimeInterval? = 1) {
        ProgressHUD.liveIcon(text, icon: type, interaction: true, delay: delay)
    }
    
    /// 提示
    static func ErigoSymbol(text : String? = nil, name: String? = "exclamationmark.circle" , delay: TimeInterval? = 1) {
        ProgressHUD.symbol( _: text, name: name ?? "", interaction: true, delay: delay)
    }
    
    /// 视频加载
    static func ErigoVideoLoad() {
        ProgressHUD.colorHUD = .clear
        ProgressHUD.colorAnimation = .white
        ProgressHUD.animationType = .activityIndicator
        ProgressHUD.animate()
    }
    /// 视频加载完毕
    static func ErigoVideoDismiss() {
        ProgressHUD.dismiss()
    }
}
