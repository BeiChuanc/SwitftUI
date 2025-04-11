//
//  PeppyCommon.swift
//  Peppy
//
//  Created by 北川 on 2025/4/9.
//

import Foundation
import UIKit

// MARK: 存储
enum PEPPYU: String {
    
    // 用户登陆
    case PLOG
    
    // 登陆账号
    case EMAIL
    
    // 登陆密码
    case PWD
    
    // 个人详情
    case FEATURE
    
    // 当前登陆账号
    case CURRENT
    
    // 当前用户限制礼物
    case ONEGIFT
    
    // 当前用户VIP权限
    case VIPPRIVILEGES
}

// MARK: 协议
enum PEPPYPROTOCOL {
    
    // 技术支持
    static let PEPPYTERMS = ""
    
    // 隐私政策
    static let PEPPYPRIVACY = ""
    
    // EULA
    static let PEPPYEULA = ""
}

// MARK: 媒体
enum PEPPYMEDIATYPE {
    
    // 图片
    case PITURE
    
    // 视频
    case VIDEO
}

// MARK: 展示协议
enum PEPPYPROWINDOW {
    
    // 技术支持
    case PEPPYTERMS
    
    // 隐私政策
    case PEPPYPRIVACY
    
    // EULA
    case PEPPYEULA
}

// MARK: 窗口
enum PEPPYSCREEN {
    
    // 宽
    static let WDITH = UIScreen.main.bounds.width
    
    // 高
    static let HEIGHT = UIScreen.main.bounds.height
}

// 宽
let peppyW = PEPPYSCREEN.WDITH

// 高
let peppyH = PEPPYSCREEN.HEIGHT
