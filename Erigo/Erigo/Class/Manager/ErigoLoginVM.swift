//
//  ErigoLogin.swift
//  Erigo
//
//  Created by 北川 on 2025/4/16.
//

import Foundation
import Combine
import SwiftUICore
import AVFoundation
import UIKit

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
        ErigoGetUserList()
        ErigoSubscription()
    }
}

// MARK: 用户数据
extension ErigoLoginVM {
    
    /// 获取帖子列表
    func ErigoGetTileList() {
        guard let titlesUrl = Bundle.main.path(forResource: "ErigoEyeTitle", ofType: "json") else {
            return }
        let titlesData = try? Data(contentsOf: URL(filePath: titlesUrl))
        
        if let titles = ErigoLoginVM.decode(data: titlesData!, to: [ErigoEyeTitleM].self) {
            for title in titles {
                if !eyeTitles.contains(where: { $0.tid == title.tid}) {
                    eyeTitles.append(title)
                }
            }
        }
    }
    
    /// 获取用户帖子数据 - id
    func ErigoGetTitle(uid: Int) -> [ErigoEyeTitleM] {
        var userTitle: [ErigoEyeTitleM] = [] // 用户帖子列表
        if let titleId = eyeUsers.first(where: { $0.uid == uid })?.title {
            for item in eyeTitles {
                if titleId.contains(item.tid!) {
                    if !userTitle.contains(item) {
                        userTitle.append(item)
                    }
                }
            }
        } // 帖子Id列表

        return userTitle
    }
    
    /// 获取用户收藏帖子数据 - id
    func ErigoGetTitleLikes(uid: Int) -> [ErigoEyeTitleM] {
        var userLikes: [ErigoEyeTitleM] = []
        let likesId = eyeUsers.first(where: { $0.uid == uid })!.likes // 收藏Id列表
        for item in eyeTitles {
            if likesId!.contains(item.tid!) {
                if !userLikes.contains(item) {
                    userLikes.append(item)
                }
            }
        }
        return userLikes
    }
    
    /// 是否收藏
    func ErigoIsLike(tid: Int) -> Bool {
        let nowUser = ErigoUserDefaults.ErigoAvNowUser()
        if let likes = nowUser.likes {
            for title in likes {
                if title.tid == tid {
                    return true
                }
            }
        }
        return false
    }
    
    /// 移除收藏
    func ErigoRemoveLike() {
        let nowUser = ErigoUserDefaults.ErigoAvNowUser()
        if var nowLikes = nowUser.likes {
            var itemsToRemove: [ErigoEyeTitleM] = []
            for nowLike in nowLikes {
                if let bid = nowLike.bid, let tid = nowLike.tid, eyeBlockList.contains(bid) || eyeReportList.contains(tid) {
                    itemsToRemove.append(nowLike)
                }
            }
            
            for item in itemsToRemove {
                if let index = nowLikes.firstIndex(where: { $0.tid == item.tid }) {
                    nowLikes.remove(at: index)
                }
            }
            
            ErigoUserDefaults.updateUserDetails { erigo in
                erigo.likes = nowLikes
                return erigo
            }
        }
    }
    
    /// 获取头像
    func ErigoLoadIamge(uid: Int) -> UIImage? {
        guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        
        let fileURL = documentsURL.appendingPathComponent("ErigoHead\(uid).jpg")
        
        do {
            let data = try Data(contentsOf: fileURL)
            return UIImage(data: data)
        } catch { return nil }
    }
    
    /// 获取封面
    func ErigoLoadMyCover(item: ErigoEyeTitleM) -> UIImage? {
        guard item.type == 0 else { return UIImage() }
        
        let userId = ErigoUserDefaults.ErigoAvNowUser().uerId!
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let mediaURL = documentsURL.appendingPathComponent("Erigo_\(userId)/\(item.tid! - userId).mp4")
        
        let asset = AVAsset(url: mediaURL)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        
        do {
            let thumbnailTime = CMTimeMake(value: 1, timescale: 60)
            let cgImage = try imageGenerator.copyCGImage(at: thumbnailTime, actualTime: nil)
            return UIImage(cgImage: cgImage)
        } catch {
            print("获取视频封面时出错: \(error)")
            if let underlyingError = (error as NSError).userInfo[NSUnderlyingErrorKey] as? NSError {
                print("底层错误: \(underlyingError)")
            }
        }
        return UIImage()
    }
    
    /// 获取指定用户
    func ErigoGetAssignUser(uid: Int) -> ErigoEyeUserM {
        for user in eyeUsers {
            if user.uid == uid {
                return user
            }
        }
        return ErigoEyeUserM()
    }
    
    /// 获取用户列表
    func ErigoGetUserList() {
        
        guard let usersUrl = Bundle.main.path(forResource: "ErigoEyeUser", ofType: "json") else {
            return }
        let usersData = try? Data(contentsOf: URL(filePath: usersUrl))
        
        if let users = ErigoLoginVM.decode(data: usersData!, to: [ErigoEyeUserM].self) {
            for user in users {
                if !eyeUsers.contains(where: { $0.uid == user.uid}) {
                    eyeUsers.append(user)
                }
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
        eyeTitles = eyeTitles.filter { item in
            return !eyeBlockList.contains(item.bid!)
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
    
    /// 转Data
    func encode<T: Codable>(modelJson: T) -> Data? {
        do {
            let jsonData = try JSONEncoder().encode(modelJson)
            return jsonData
        } catch {
            return nil
        }
    }
    
    /// 转模型
    static func decode<T: Codable>(data: Data, to type: T.Type) -> T? {
        do {
            let decodedObject = try JSONDecoder().decode(T.self, from: data)
            return decodedObject
        } catch {
            return nil
        }
    }
    
    /// 登陆
    func ErigoLoginAcc(email: String, pwd: String, complete: @escaping (_ statu: ERIGOSTATUS) -> Void) {
        if ErigoUserDefaults.ErigoMatchACP(email: email, userPwd: pwd) {
            ErigoLoginVM.shared.landComplete = true
            complete(.LOAD)
        } else {
            if email == "eshadow@gmail.com" { // eshadow@gmail.com / 123456
                if pwd == "123456" {
                    ErigoGenUser(email: email, pwd: pwd, appleLogin: false)
                    ErigoLoginVM.shared.landComplete = true
                    complete(.LOAD)
                } else { // 失败
                    complete(.FAIL)
                }
            }
        }
    }
    
    /// 注册
    func ErigoRnrollAcc(email: String, pwd: String, complete: @escaping () -> Void) {
        ErigoGenUser(email: email, pwd: pwd, appleLogin: false)
        complete()
    }
    
    /// 苹果登陆
    func ErigoAppleLogin(email: String, complete: @escaping () -> Void) {
        ErigoGenUser(email: email, pwd: "123456", appleLogin: true)
        complete()
    }
    
    /// 生成用户数据
    func ErigoGenUser(email: String, pwd: String, appleLogin: Bool) {
        ErigoUserDefaults.ErigoSaveLogin(email: email, pwd: pwd)
        ErigoUserDefaults.ErigoSaveNowAcc(email: email)
        let userId = Array(2000..<3000).randomElement()
        let userModel = ErigoUserM()
        userModel.uerId = appleLogin ? 1000 : userId
        userModel.head = "head_de"
        userModel.name = "Erigo"
        userModel.album = []
        userModel.likes = []
        userModel.isReportG = false
        userModel.isJoin = false
        
        ErigoUserDefaults.ErigoSaveDetails(email: email, details: encode(modelJson: userModel)!)
        ErigoMesAndPubVM.ErigoDeleteMyM(myMPath: "Erigo_\(appleLogin ? 1000 : userId!)")
        ErigoMesAndPubVM.shared.ErigoDelMesFile()
    }
}
