//
//  PeppyChatMould.swift
//  Peppy
//
//  Created by 北川 on 2025/4/10.
//

import Foundation

// MARK: 宠物聊天模型
struct PeppyChatMould: Hashable, Codable {
    
    // 内容
    var c: String
    
    // 时间
    var t: String
    
    // 发送方
    var isMy: Bool
}
