//
//  ErigoUser.swift
//  Erigo
//
//  Created by 北川 on 2025/4/21.
//

import Foundation
import HandyJSON

// MARK: 用户
class ErigoUserM: HandyJSON {
    
    var uerId: Int?
    
    var head: String?
    
    var name: String?
    
    var album: [ErigoEyeTitleM]?
    
    var likes: [ErigoEyeTitleM]?
    
    var report: [Int]?
    
    var views: [[Int: Int]]?
    
    var isJoin: Bool?
    
    required init() {}
    
    init(uerId: Int? = nil,
         head: String? = nil,
         name: String? = nil,
         album: [ErigoEyeTitleM]? = nil,
         likes: [ErigoEyeTitleM]? = nil,
         report: [Int]? = nil,
         views: [[Int : Int]]? = nil,
         isJoin: Bool? = nil) {
        self.uerId = uerId
        self.head = head
        self.name = name
        self.album = album
        self.likes = likes
        self.report = report
        self.views = views
        self.isJoin = isJoin
    }
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

// MARK: 相册数据模型
struct ErigoMediaM {
    
    let type: ERIGOMEDIATYPE
    
    let img: UIImage?
    
    let vUrl: URL?
    
    var mData: Data?
}

// MARK: EyeUser
struct ErigoEyeUserM: Identifiable, Hashable, HandyJSON {
   
    var id = UUID()
    
    var uid: Int?
    
    var name: String?
    
    var title: [Int]?
    
    var likes: [Int]?
    
    init() {}
}

// MARK: 帖子数据
struct ErigoEyeTitleM: Identifiable, Hashable, HandyJSON {
    
    var id = UUID()
    
    var tid: Int?
    
    var bid: Int?
    
    var name: String?
    
    var type: Int?
    
    var cover: String?
    
    var media: String?
    
    var content: String?
    
    var colors: [String]?
    
    var views: Int?
    
    var likes: Int?
    
    init() {}
}
