//
//  ErigoUser.swift
//  Erigo
//
//  Created by 北川 on 2025/4/21.
//

import Foundation
import HandyJSON

// MARK: 用户
struct ErigoUserM: Identifiable, HandyJSON {
    
    var id = UUID()
    
    var head: String?
    
    var name: String?
    
    var album: [ErigoMeidiaM]?
    
    var likes: [Int]?
    
    var report: [Int]?
    
    var isJoin: Bool?
    
    init() {}
}

// MARK: 发布
struct ErigoPublishM: HandyJSON {
    
    var content: String?
    
    var colors: [String]?
    
    var url: URL?
    
    var views: Int?
    
    var like: Int?
    
    init() {}
}

// MARK: 媒体
struct ErigoMeidiaM: Identifiable, HandyJSON {
    
    var id = UUID()
    
    var type: ERIGOMEDIATYPE?
    
    var url: String?
    
    init() {}
}

// MARK: EyeUser
struct ErigoEyeUserM: Identifiable, HandyJSON {
   
    var id = UUID()
    
    var uid: Int?
    
    var name: String?
    
    var title: [Int]?
    
    var likes: [Int]?
    
    init() {}
}

// MARK: 帖子数据
struct ErigoEyeTitleM: Identifiable, HandyJSON {
    
    var id = UUID()
    
    var tid: Int?
    
    var bid: Int?
    
    var type: Int?
    
    var cover: String?
    
    var media: String?
    
    var content: String?
    
    var colors: [String]?
    
    var views: Int?
    
    var likes: Int?
    
    init() {}
}
