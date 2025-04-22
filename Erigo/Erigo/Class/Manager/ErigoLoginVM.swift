//
//  ErigoLogin.swift
//  Erigo
//
//  Created by 北川 on 2025/4/16.
//

import Foundation
import HandyJSON
import Combine

/**
 帖子用户一视频2图片: 创建用户时对数据进行绑定： 1帖子id 2浏览数
 
 1.https://d3197c2qdpub41.cloudfront.net/com.eyeShadow.erigo/0a7acbc193219fae33362c4e372cb5f9.mp4
 2.https://d3197c2qdpub41.cloudfront.net/com.eyeShadow.erigo/490205a1243434d112b02e009e534675.mp4
 10.https://d3197c2qdpub41.cloudfront.net/com.eyeShadow.erigo/d9448ade09b3b09200d2f663f6257d4e.mp4
 
 3.https://d3197c2qdpub41.cloudfront.net/com.eyeShadow.erigo/0ce7833fd632b81c7381eb76f0e7bb78.mp4
 4.https://d3197c2qdpub41.cloudfront.net/com.eyeShadow.erigo/92c78acc68766f4e4b79eb1101482b4d.mp4
 5.https://d3197c2qdpub41.cloudfront.net/com.eyeShadow.erigo/989dcf93e52b3239358228226a2783d9.mp4
 7.https://d3197c2qdpub41.cloudfront.net/com.eyeShadow.erigo/29cf480f243aeed4f0476f85d6644a2c.mp4
 8.https://d3197c2qdpub41.cloudfront.net/com.eyeShadow.erigo/8451c322f2490655d308ae7093780a4a.mp4
 
 */


// MARK: 登陆
class ErigoLoginVM: ObservableObject {
    
    static let shared = ErigoLoginVM()
    
    var cancellables = Set<AnyCancellable>()
    
    @Published var eyeReportList: [Int] = []
    
    @Published var eyeBlockList: [Int] = []
    
    @Published var landComplete: Bool = false
    
    @Published var eyeUsers: [ErigoEyeUserM] = []
    
    @Published var eyeTitles: [ErigoEyeTitleM] = []
    
    @Published var eyeMyTitles: [ErigoMeidiaM] = []
    
    init() {
        ErigoGetTileList()
        ErigoSubscription()
    }
}

// MARK: 用户数据
extension ErigoLoginVM {
    
    /// 获取帖子列表
    func ErigoGetTileList() {
        guard let titlesUrl = Bundle.main.url(forResource: "ErigoEyeTitle", withExtension: "json") else { return }
        let titlesData = try? Data(contentsOf: titlesUrl)
        
        guard let titles = try? JSONSerialization.jsonObject(with: titlesData!, options: []) as? [[String: Any]] else { return }
        
        for t in titles {
            if let title = ErigoEyeTitleM.deserialize(from: t) {
                eyeTitles.append(title)
            }
        }
    }
    
    /// 获取用户帖子数据 - id
    func ErigoGetTitle(uid: Int) -> [ErigoEyeTitleM] {
        
        return []
    }
    
    /// 获取帖子详情 - id
    func ErigoGetTitleDetail(tid: Int) -> ErigoEyeTitleM {
        
        return ErigoEyeTitleM()
    }
    
    /// 获取用户信息 - id
    func ErigoGetUserInfo(uid: Int) {

    }
    
    /// 获取用户列表
    func ErigoGetUserList() {
        guard let usersUrl = Bundle.main.url(forResource: "ErigoEyeUser", withExtension: "json") else { return }
        let usersData = try? Data(contentsOf: usersUrl)

        guard let users = try? JSONSerialization.jsonObject(with: usersData!, options: []) as? [[String: Any]] else { return }
        
        for u in users {
            if let user = ErigoEyeUserM.deserialize(from: u) {
                eyeUsers.append(user)
            }
        }
        ErigoUpdateEyeUser(eyeUsers)
    }
    
    /// 过滤帖子数据
    func ErigoUpdateEyeTitles(_ titles: [ErigoEyeTitleM]) {
        eyeTitles = titles.filter { item in
            return !eyeReportList.contains(item.tid!)
        }
    }
    
    /// 过滤用户
    func ErigoUpdateEyeUser(_ users: [ErigoEyeUserM]) {
        eyeUsers = users.filter { item in
            return !eyeBlockList.contains(item.uid!)
        }
    }
    
    /// 订阅举报 & 拉黑
    func ErigoSubscription() {
        $eyeReportList
            .dropFirst()
            .sink { [weak self] newList in
                DispatchQueue.main.async { // 异步执行
                    guard let self = self else { return }
                    self.ErigoUpdateEyeTitles(self.eyeTitles)
                }
            }
           .store(in: &cancellables)
        
        $eyeBlockList
            .dropFirst()
            .sink { [weak self] newList in
                DispatchQueue.main.async { // 异步执行
                    guard let self = self else { return }
                    self.ErigoUpdateEyeUser(self.eyeUsers)
                }
            }
           .store(in: &cancellables)
    }
}
