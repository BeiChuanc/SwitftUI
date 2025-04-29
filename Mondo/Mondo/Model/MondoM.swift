//
//  MondoM.swift
//  Mondo
//
//  Created by 北川 on 2025/4/28.
//

import Foundation
import UIKit

// MARK: 指南
struct MondoGuideM: Identifiable, Hashable {
    
    var id = UUID()
    
    var topTitle: String
    
    var showBg: String
    
    var showContent: String
}

// MARK: 许愿池
struct MondoWishM {
    
    var head: String
    
    var content: String
}

// MARK: 登山帖子 - 用户
struct MondoTitleM: Identifiable, Hashable, Codable {
    
    var id = UUID()
    
    var mId: Int
    
    var uId: Int
    
    var uHead: String
    
    var uName: String
    
    var cover: String
    
    var media: String
    
    var isVideo: Bool
    
    var topic: String
    
    var content: String
    
    var time: String
    
    var likes: Int
    
    var fires: Int
    
    var isRake: Bool
    
    enum CodingKeys: String, CodingKey {
        
        case mId = "mId"
        
        case uId = "uId"
        
        case uHead = "uHead"
        
        case uName = "uName"
        
        case cover = "cover"
        
        case media = "media"
        
        case isVideo = "isVideo"
        
        case topic = "topic"
        
        case content = "content"
        
        case time = "time"
        
        case likes = "likes"
        
        case fires = "fires"
        
        case isRake = "isRake"
    }
}

// MARK: 自己帖子
struct MondoTitleMeM: Identifiable, Hashable, Codable {
    
    var id = UUID()
    
    var mId: Int?
    
    var media: String?
    
    var isVideo: Bool?
    
    var topic: String?
    
    var content: String?
    
    enum CodingKeys: String, CodingKey {
        
        case mId = "mId"
        
        case media = "media"
        
        case isVideo = "isVideo"
        
        case topic = "topic"
        
        case content = "content"
    }
}

// MARK: 用户 - 自己
class MondoMeM: Codable {
    
    var uid: Int
    
    var head: String
    
    var name: String
    
    var likes: [MondoTitleM]
    
    var follower: [Int]
    
    var fans: [Int]
    
    var join: [Int]
    
    var publishImage: [MondoTitleMeM]
    
    var publishVideo: [MondoTitleMeM]
    
    init(uid: Int = 0,
         head: String = "",
         name: String = "",
         likes: [MondoTitleM] = [],
         follower: [Int] = [],
         fans: [Int] = [],
         join: [Int] = [],
         publishImage: [MondoTitleMeM] = [],
         publishVideo: [MondoTitleMeM] = []) {
        self.uid = uid
        self.head = head
        self.name = name
        self.likes = likes
        self.follower = follower
        self.fans = fans
        self.join = join
        self.publishImage = publishImage
        self.publishVideo = publishVideo
    }
}

// MARK: 相册数据模型
struct MondoLibM {
    
    let type: Int
    
    let img: UIImage
    
    let vUrl: URL?
    
    var mData: Data?
}

// MARK: 发布
struct MondoReleaseM: Codable {
    
    var topic: String
    
    var content: String
    
    var url: URL
}

// MARK: 用户
struct MondoerM: Identifiable, Hashable, Codable {
   
    var id = UUID()
    
    var uid: Int?
    
    var name: String?
    
    var head: String?
    
    var title: [Int]?
    
    enum CodingKeys: String, CodingKey {
        
        case uid = "uid"
        
        case name = "name"
        
        case head = "head"
        
        case title = "title"
    }
}

// MARK: 消息
struct MondoChatM: Identifiable, Codable {
    
    var id = UUID()
    
    var isForMe: Bool?
    
    var mesTime: String?
    
    var mesContent: String?
}
