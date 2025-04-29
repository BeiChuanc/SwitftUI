//
//  ErigoChatVM.swift
//  Erigo
//
//  Created by 北川 on 2025/4/22.
//

import Foundation

// MARK: 消息
struct ErigoChatM: Identifiable, Codable {
    
    var id = UUID()
    
    var isForMe: Bool?
    
    var mesTime: String?
    
    var mesContent: String?
}
