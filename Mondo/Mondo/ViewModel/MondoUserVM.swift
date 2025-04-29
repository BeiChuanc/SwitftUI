//
//  MondoUserVM.swift
//  Mondo
//
//  Created by 北川 on 2025/4/28.
//

import Foundation
import UIKit
import Combine
import AVFoundation

// MARK: 用户VM
class MondoUserVM: ObservableObject {
    
    static let shared = MondoUserVM()
    
    var cancellables = Set<AnyCancellable>()
    
    @Published var monReportList: [Int] = []
    
    @Published var monBlockList: [Int] = []
    
    @Published var loginIn: Bool = false

    @Published var monUsers: [MondoerM] = []
    
    @Published var monTitles: [MondoTitleM] = []
    
    @Published var monMyTitles: [MondoTitleMeM] = []
    
    @Published var monHot: [MondoTitleM] = []
    
    init() {
        MondoGetTileList()
        MondoGetUserList()
        MondoSubscription()
    }
}

// MARK: 自己数据
extension MondoUserVM {
    
    /// 获取用户本地头像
    func MondoAvHead(uid: Int) -> UIImage? {
        guard let doc = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let headURL = doc.appendingPathComponent("Mondo\(uid).jpg")
        do {
            let data = try Data(contentsOf: headURL)
            return UIImage(data: data)
        } catch { return nil }
    }
    
    /// 获取封面
    func MondoAvVideoThumb(myTitle: MondoTitleMeM) -> UIImage? {
        guard myTitle.isVideo ?? false else { return UIImage() }
        
        let userId = MondoCacheVM.MondoAvCurUser().uid
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let mediaURL = documentsURL.appendingPathComponent("Mondo_\(userId)/\(myTitle.mId! - userId).mp4")
        
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
    
}

// MARK: 用户数据
extension MondoUserVM {
    
    /// 获取帖子列表
    func MondoGetTileList() {
        guard let titlesUrl = Bundle.main.path(forResource: "MondoTitle", ofType: "json") else {
            return }
        let titlesData = try? Data(contentsOf: URL(filePath: titlesUrl))
        
        if let titles = MondoUserVM.decode(data: titlesData!, to: [MondoTitleM].self) {
            for title in titles {
                if !monTitles.contains(where: { $0.mId == title.mId}), !title.isRake {
                    monTitles.append(title)
                }
            }
        }
    }
    
    /// 获取排行榜
    func MondoGetHotList() {
        guard let titlesUrl = Bundle.main.path(forResource: "MondoTitle", ofType: "json") else {
            return }
        let titlesData = try? Data(contentsOf: URL(filePath: titlesUrl))
        
        if let titles = MondoUserVM.decode(data: titlesData!, to: [MondoTitleM].self) {
            for title in titles {
                if !monHot.contains(where: { $0.mId == title.mId}), title.isRake {
                    monHot.append(title)
                }
            }
        }
    }
    
    /// 是否喜欢
    func MondoIsLike(mId: Int) -> Bool {
        let nowUser = MondoCacheVM.MondoAvCurUser()
        for lid in nowUser.likes {
            if lid.mId == mId {
                return true
            }
        }
        return false
    }
    
    /// 移除喜欢
    func MondoRemoveLike() {
        let nowUser = MondoCacheVM.MondoAvCurUser()
        var itemsToRemove: [MondoTitleM] = []
        for title in nowUser.likes {
            let mid = title.mId
            let uid = title.uId
            if monBlockList.contains(uid) || monReportList.contains(mid) {
                itemsToRemove.append(title)
            }
        }
        
        for item in itemsToRemove {
            if let index = nowUser.likes.firstIndex(where: { $0.mId == item.mId }) {
                nowUser.likes.remove(at: index)
            }
        }
        
        MondoCacheVM.MondoFixDetails { erigo in
            erigo.likes = nowUser.likes
            return erigo
        }
    }
    
    /// 是否关注
    func MondoIsFollow(uId: Int) -> Bool {
        let nowUser = MondoCacheVM.MondoAvCurUser()
        for fol in nowUser.follower {
            if fol == uId {
                return true
            }
        }
        return false
    }
    
    /// 移除关注
    func MondoRemoveFollow() {
        let nowUser = MondoCacheVM.MondoAvCurUser()
        var itemsToRemove: [Int] = []
        for fol in nowUser.follower {
            if monBlockList.contains(fol) {
                itemsToRemove.append(fol)
            }
        }
        
        for item in itemsToRemove {
            if let index = nowUser.follower.firstIndex(where: { $0 == item }) {
                nowUser.follower.remove(at: index)
            }
        }
        
        MondoCacheVM.MondoFixDetails { erigo in
            erigo.follower = nowUser.follower
            return erigo
        }
    }
    
    /// 获取用户帖子数据 - id
    func MondoGetTitle(uid: Int) -> [MondoTitleM] {
        var userTitle: [MondoTitleM] = [] // 用户帖子列表
        if let titleId = monUsers.first(where: { $0.uid == uid })?.title {
            for item in monTitles {
                if titleId.contains(item.uId) {
                    if !userTitle.contains(item) {
                        userTitle.append(item)
                    }
                }
            }
        } // 帖子Id列表

        return userTitle
    }
    
    /// 获取指定用户
    func MondoGetAssignUser(uid: Int) -> MondoerM {
        for user in monUsers {
            if user.uid == uid {
                return user
            }
        }
        return MondoerM()
    }
    
    /// 获取用户列表
    func MondoGetUserList() {
        
        guard let usersUrl = Bundle.main.path(forResource: "Mondoer", ofType: "json") else {
            return }
        let usersData = try? Data(contentsOf: URL(filePath: usersUrl))
        
        if let users = MondoUserVM.decode(data: usersData!, to: [MondoerM].self) {
            for user in users {
                if !monUsers.contains(where: { $0.uid == user.uid}) {
                    monUsers.append(user)
                }
            }
        }
        MondoUpdateEyeUser(monUsers)
    }
    
    /// 过滤帖子数据
    func MondoUpdateEyeTitles(_ titles: [MondoTitleM]) {
        monTitles = titles.filter { item in
            return !monReportList.contains(item.mId)
        }
    }
    
    /// 过滤用户
    func MondoUpdateEyeUser(_ users: [MondoerM]) {
        monUsers = users.filter { item in
            return !monBlockList.contains(item.uid!)
        }
        monTitles = monTitles.filter { item in
            return !monBlockList.contains(item.uId)
        }
    }
    
    /// 订阅举报 & 拉黑
    func MondoSubscription() {
        $monReportList
            .dropFirst()
            .sink { [weak self] newList in
                DispatchQueue.main.async { // 异步执行
                    guard let self = self else { return }
                    self.MondoUpdateEyeTitles(self.monTitles)
                }
            }
           .store(in: &cancellables)
        
        $monBlockList
            .dropFirst()
            .sink { [weak self] newList in
                DispatchQueue.main.async { // 异步执行
                    guard let self = self else { return }
                    self.MondoUpdateEyeUser(self.monUsers)
                }
            }
           .store(in: &cancellables)
    }
    
    /// 转Data
    func encode<T: Codable>(modelJson: T) -> Data? {
        do {
            let jsonData = try JSONEncoder().encode(modelJson)
            return jsonData
        } catch { return nil }
    }
    
    /// 转模型
    static func decode<T: Codable>(data: Data, to type: T.Type) -> T? {
        do {
            let decodedObject = try JSONDecoder().decode(T.self, from: data)
            return decodedObject
        } catch { return nil }
    }
}

// MARK: 登陆
extension MondoUserVM {
    
    /// 登陆
    func MondoLoginAcc(email: String, pwd: String, complete: @escaping (_ statu: MONDOSTATUS) -> Void) {
        if MondoCacheVM.MondoMatchLogin(email: email, userPwd: pwd) {
            MondoUserVM.shared.loginIn = true
            complete(.LOAD)
        } else {
            if email == "1111" { // tlm982@outlook.com/123456
                if pwd == "123456" {
                    MondoCrer(email: email, pwd: pwd, appleLogin: false)
                    MondoUserVM.shared.loginIn = true
                    complete(.LOAD)
                } else { // 失败
                    complete(.FAIL)
                }
            }
        }
    }
    
    /// 注册
    func MondoRegisterAcc(email: String, pwd: String, complete: @escaping () -> Void) {
        MondoCrer(email: email, pwd: pwd, appleLogin: false)
        complete()
    }
    
    /// 苹果登陆
    func MondoAppleLogin(email: String, complete: @escaping () -> Void) {
        MondoCrer(email: email, pwd: "123456", appleLogin: true)
        complete()
    }
    
    /// 生成用户数据
    func MondoCrer(email: String, pwd: String, appleLogin: Bool) {
        MondoCacheVM.MondoSvLogin(email: email, pwd: pwd)
        MondoCacheVM.MondoSvCur(email: email)
        let userId = Array(2000..<3000).randomElement()
        let monder = MondoMeM()
        monder.uid = appleLogin ? 1000 : userId!
        monder.head = "monder"
        monder.name = "Mondo"
        monder.likes = []
        monder.follower = []
        monder.fans = []
        monder.join = []
        monder.publishImage = []
        monder.publishVideo = []
        
        MondoCacheVM.MondoSvPers(email: email, details: encode(modelJson: monder)!)
        MondoRelMesVM.MondoDeleteMyM(myMPath: "Mondo_\(appleLogin ? 1000 : userId!)")
        MondoRelMesVM.shared.MondoDelMesFile()
    }
}
