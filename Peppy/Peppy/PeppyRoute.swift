//
//  PeppyRoute.swift
//  Peppy
//
//  Created by 北川 on 2025/4/11.
//

import SwiftUI

// MARK: - 路由类型
enum PeppyRoute: Hashable {
    
    // 聊天
    case CHAT(PeppyChatMould)
    
    // 设置
    case SET
    
    // 登陆
    case LOGIN
    
    // 注册
    case REGISTER
    
    // 选择头像
    case UPLOADHEAD
    
    // 播放
    case PLAYMEDIA
}
