//
//  PeppyChatMould.swift
//  Peppy
//
//  Created by 北川 on 2025/4/10.
//

import Foundation

// MARK: 宠物聊天模型
struct PeppyChatMould: Identifiable, Hashable, Codable {
    
    // 协议唯一Id
    var id = UUID()
    
    // 内容
    var c: String
    
    // 发送方
    var isMy: Bool
    
    // 动画
    var isAnimated: Bool = false
}
