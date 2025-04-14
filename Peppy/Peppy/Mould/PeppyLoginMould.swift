//
//  PeppyLoginModel.swift
//  Peppy
//
//  Created by 北川 on 2025/4/10.
//

import Foundation
import SwiftUI

// MARK: 用户登陆模型
class PeppyLoginMould: Codable {
    
    // 用户ID
    var peppyId: Int?
    
    // 用户帐号
    var email: String?
    
    // 用户密码
    var pwd: String?
    
    // 用户名称
    var kickName: String?
    
    // 用户头像
    var head: String?
    
    // 用户头像底色
    var headColor: String?
    
    // 媒体url列表
    var mediaList: [PeppyMyMedia]?
    
    init(peppyId: Int?              = nil,
         email: String?             = nil,
         pwd: String?               = nil,
         kickName: String?          = nil,
         head: String?              = nil,
         headColor: String?         = nil,
         mediaList: [PeppyMyMedia]? = []) {
        self.peppyId = peppyId
        self.email = email
        self.pwd = pwd
        self.kickName = kickName
        self.head = head
        self.headColor = headColor
        self.mediaList = mediaList
    }
}

