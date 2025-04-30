//
//  MondoCache.swift
//  Mondo
//
//  Created by 北川 on 2025/4/29.
//

import Foundation

// MARK: 存储枚举
enum MONDOSTRING: String {
    case LAND
    case ACC
    case PWD
    case PER
    case CUR
}

// MARK: 存储用户
class MondoCacheVM {
    
    static let defaults = UserDefaults.standard
    
    init() {}
    
    /// 获取指定键
    static func MondoAvValue<T>(forKey key: MONDOSTRING) -> T? {
        return defaults.value(forKey: key.rawValue) as? T
    }
    
    /// 保存指定键
    static func MondoSvValue(_ value: Any?, forKey key: MONDOSTRING) {
        defaults.set(value, forKey: key.rawValue)
    }
    
    /// 保存用户登录账号密码
    class func MondoSvLogin(email: String, pwd: String) {
        let allAccAsArray: [[String: Any]]? = MondoAvValue(forKey: .LAND)
        var allAcc = allAccAsArray ?? []
        if let index = allAcc.firstIndex(where: { $0[MONDOSTRING.ACC.rawValue] as? String == email }) {
            allAcc[index] = [MONDOSTRING.ACC.rawValue: email, MONDOSTRING.PWD.rawValue: pwd]
        } else {
            allAcc.append([MONDOSTRING.ACC.rawValue: email, MONDOSTRING.PWD.rawValue: pwd])
        }
        MondoSvValue(allAcc, forKey: .LAND)
    }
    
    /// 获取所有用户登录账号密码
    class func MondoAvUsers() -> [[String: Any]] {
        return MondoAvValue(forKey: .LAND) ?? []
    }
    
    /// 获取指定用户登录账号密码
    class func MondoAvUserAcc(email: String) -> [String: Any]? {
        return MondoAvUsers().first { $0[MONDOSTRING.ACC.rawValue] as? String == email }
    }
    
    /// 保存当前登录用户
    class func MondoSvCur(email: String) {
        MondoSvValue(email, forKey: .CUR)
    }
    
    /// 获取当前登录用户
    class func MondoAvCur() -> String {
        return MondoAvValue(forKey: .CUR) ?? ""
    }
    
    /// 获取所有用户信息
    class func MondoAvAllPers() -> [String: Data] {
        return MondoAvValue(forKey: .PER) ?? [:]
    }
    
    /// 匹配用户登录账号密码
    class func MondoMatchLogin(email: String, userPwd: String) -> Bool {
        if let userInfo = MondoAvUserAcc(email: email),
           let storedPassword = userInfo[MONDOSTRING.PWD.rawValue] as? String {
            if storedPassword != userPwd {
                MondoBaseVM.MondoShow(type: .failed, text: "User account password error!")
            }
            return storedPassword == userPwd
        }
        MondoBaseVM.MondoShow(type: .failed, text: "User account does not exist!")
        return false
    }
    
    /// 获取当前用户信息
    class func MondoAvCurUser() -> MondoMeM {
        let userDetailsDict = MondoAvAllPers()
        let userNow = MondoAvCur()
        if let jsonData = userDetailsDict[userNow]{
            do {
                let decodeUser = try JSONDecoder().decode(MondoMeM.self, from: jsonData)
                return decodeUser
            } catch {}
        }
        return MondoMeM()
    }
    
    /// 删除指定用户信息
    class func MondoDelCur() {
        var userNow = MondoAvAllPers()
        var users = MondoAvUsers()
        let nowAcc = MondoAvCur()
        
        userNow.removeValue(forKey: nowAcc)
        users.removeAll { $0[MONDOSTRING.ACC.rawValue] as? String == nowAcc }
        
        MondoSvValue(userNow, forKey: .PER)
        MondoSvValue(users, forKey: .LAND)
        MondoSvValue("", forKey: .CUR)
        
        print("所有用户: \(users)")
        print("所有用户信息: \(userNow)")
    }
    
    /// 保存指定用户信息
    class func MondoSvPers(email: String, details: Data) {
        var userDetailsDict = MondoAvAllPers()
        userDetailsDict[email] = details
        MondoSvValue(userDetailsDict, forKey: .PER)
    }
    
    /// 修改用户详细信息
    class func MondoFixDetails(mon: (MondoMeM) -> MondoMeM) {
        var userNow = MondoAvCurUser()
        let noewAcc = MondoAvCur()
        userNow = mon(userNow)
        do {
            let encodedData = try JSONEncoder().encode(userNow)
            MondoSvPers(email: noewAcc, details: encodedData)
        } catch {}
    }
}
