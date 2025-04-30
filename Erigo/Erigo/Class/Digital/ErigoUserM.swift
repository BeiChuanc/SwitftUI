//
//  ErigoUser.swift
//  Erigo
//
//  Created by 北川 on 2025/4/21.
//

import Foundation
import UIKit

// MARK: 用户
class ErigoUserM: Codable {
    
    var uerId: Int?
    
    var head: String?
    
    var name: String?
    
    var album: [ErigoEyeTitleM]?
    
    var likes: [ErigoEyeTitleM]?
    
    var isReportG: Bool?
    
    var isJoin: Bool?
}

// MARK: 发布
struct ErigoPublishM: Codable {
    
    var content: String?
    
    var colors: [String]?
    
    var url: URL?
    
    var views: Int?
    
    var like: Int?
}

// MARK: 媒体
struct ErigoMeidiaM: Identifiable, Codable {
    
    var id = UUID()
    
    var type: ERIGOMEDIATYPE?
    
    var url: String?
}

// MARK: 相册数据模型
struct ErigoMediaM {
    
    let type: ERIGOMEDIATYPE
    
    let img: UIImage?
    
    let vUrl: URL?
    
    var mData: Data?
}

// MARK: EyeUser
struct ErigoEyeUserM: Identifiable, Hashable, Codable {
   
    var id = UUID()
    
    var uid: Int?
    
    var name: String?
    
    var title: [Int]?
    
    var likes: [Int]?
    
    enum CodingKeys: String, CodingKey {
        
        case uid = "uid"
        
        case name = "name"
        
        case title = "title"
        
        case likes = "likes"
    }
}

// MARK: 帖子数据
struct ErigoEyeTitleM: Identifiable, Hashable, Codable {
    
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
    
    enum CodingKeys: String, CodingKey {
        
        case tid = "tid"
        
        case bid = "bid"
        
        case name = "name"
        
        case type = "type"
        
        case cover = "cover"
        
        case media = "media"
        
        case content = "cotent"
        
        case colors = "colors"
        
        case views = "views"
        
        case likes = "likes"
    }
}
