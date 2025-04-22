//
//  ErigoChatVM.swift
//  Erigo
//
//  Created by 北川 on 2025/4/22.
//

import Foundation
import HandyJSON

// MARK: 消息
struct ErigoChatM: HandyJSON {
    
    var isGroup: Bool?
    
    var isForMe: Bool?
    
    var mesTime: String?
    
    var mesContent: String?
    
    init() {}
}
