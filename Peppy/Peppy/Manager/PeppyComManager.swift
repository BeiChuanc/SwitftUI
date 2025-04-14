//
//  PeppyJsonManager.swift
//  Peppy
//
//  Created by 北川 on 2025/4/10.
//

import Foundation
import YPImagePicker

// MARK: 公共方法
class PeppyComManager {
    
    /// 获取当前时间: 时:分
    static func peppyGetCurrentTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let currentDate = Date()
        return dateFormatter.string(from: currentDate)
    }
    
    /// 获取当前时间: 年.月.日
    static func peppyGetCurrentTimeP() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        let currentDate = Date()
        return dateFormatter.string(from: currentDate)
    }
    
    /// 生成用户昵称
    static func peppyGrenName(nLen: Int) -> String {
        let peppyCharacter = "abcdefghijklmnopqrstuvwxyz"
        var name = ""
        for _ in 0..<nLen {
            name += String(peppyCharacter.randomElement()!)
        }
        let peppyName = name.prefix(1).uppercased() + name.dropFirst()
        return peppyName
    }
    
    /// 创造用户
    static func peppyCreatUser(peNam: String, peEma: String, pePwd: String, isApple: Bool = false) {
        PeppyUserManager.PEPPYUaveUserLogin(userAcc: peEma, userPwd: pePwd)
        PeppyUserManager.PEPPYUaveCurrentAcc(userAcc: peEma)
        
        var userId: Int
        if isApple {
            userId = 1000
        } else {
            userId = Array(100...200).randomElement()!
        }
        
        let ppeyHead = PeppyLoginManager.shared.loginUser.head ?? "head_1"
        let ppeyHeadColor = PeppyLoginManager.shared.loginUser.head ?? PeppyColorType.ONE.rawValue
        let peppyUser = PeppyLoginMould(peppyId: userId,
                                        email: peEma,
                                        pwd: pePwd,
                                        kickName: peNam,
                                        head: ppeyHead,
                                        headColor: ppeyHeadColor)
        PeppyUserManager.PEPPYUaveDetailsForCurrentDancer(userAcc: peEma, data: PeppyJsonManager.encode(object: peppyUser)!)
        PeppyUserDataManager.peppyDeleteMedia(mediaPath: "\(userId)_publish")
    }
}
