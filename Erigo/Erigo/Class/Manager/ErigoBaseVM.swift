//
//  ErigoBase.swift
//  Erigo
//
//  Created by 北川 on 2025/4/16.
//

import Foundation

// MARK: 基础
class ErigoBase: NSObject {
    
    static let shared = ErigoBase()
}

// MARK: 时间
extension ErigoBase {
    
    /// 聊天时间
    func ErigoCurChatTime() -> String {
        let chatDate = Date()
        let matter = DateFormatter()
        matter.dateFormat = "hh:mm"
        return matter.string(from: chatDate)
    }
}

// MARK: 全局加载
extension ErigoBase {
    
    
}
