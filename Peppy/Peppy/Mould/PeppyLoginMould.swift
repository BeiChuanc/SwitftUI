//
//  PeppyLoginModel.swift
//  Peppy
//
//  Created by 北川 on 2025/4/10.
//

import Foundation
import SwiftUI

// MARK: 用户登陆模型
struct PeppyLoginMould: Codable {
    
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
}

// MARK: 用户发布的媒体模型
struct PeppyMyMedia: Identifiable, Hashable, Codable {
    
    // 唯一ID
    var id = UUID()
    
    // 用户ID
    var peppyIdL: Int?
    
    // 媒体地址
    var mediaUrl: URL?
    
    // 内容
    var mediaContent: String?
    
    // 媒体发布时间
    var mediaTime: String?
}
