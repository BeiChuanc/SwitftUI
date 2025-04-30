//
//  ErigoUserDefaults.swift
//  Erigo
//
//  Created by 北川 on 2025/4/22.
//

import Foundation

// MARK: 存储枚举
enum ERIGODEFAULT: String {
    
    case COMPLETE
    
    case ACCOUNT
    
    case PASSWORD
    
    case MYDETILS
    
    case NOWACC
    
    case LIMIT
    
    case VIP
}

// MARK: 存储用户
class ErigoUserDefaults {
    
    static let defaults = UserDefaults.standard
    
    init() {}
    
    /// 获取指定键
    static func ErigoAssignValue<T>(forKey key: ERIGODEFAULT) -> T? {
        return defaults.value(forKey: key.rawValue) as? T
    }
    
    /// 保存指定键
    static func ErigoSaveValue(_ value: Any?, forKey key: ERIGODEFAULT) {
        defaults.set(value, forKey: key.rawValue)
    }
    
    /// 保存用户登录账号密码
    class func ErigoSaveLogin(email: String, pwd: String) {
        let allAccAsArray: [[String: Any]]? = ErigoAssignValue(forKey: .COMPLETE)
        var allAcc = allAccAsArray ?? []
        if let index = allAcc.firstIndex(where: { $0[ERIGODEFAULT.ACCOUNT.rawValue] as? String == email }) {
            allAcc[index] = [ERIGODEFAULT.ACCOUNT.rawValue: email, ERIGODEFAULT.PASSWORD.rawValue: pwd]
        } else {
            allAcc.append([ERIGODEFAULT.ACCOUNT.rawValue: email, ERIGODEFAULT.PASSWORD.rawValue: pwd])
        }
        ErigoSaveValue(allAcc, forKey: .COMPLETE)
    }
    
    /// 获取所有用户登录账号密码
    class func ErigoAvUsers() -> [[String: Any]] {
        return ErigoAssignValue(forKey: .COMPLETE) ?? []
    }
    
    /// 获取指定用户登录账号密码
    class func ErigoAvUserAssign(email: String) -> [String: Any]? {
        return ErigoAvUsers().first { $0[ERIGODEFAULT.ACCOUNT.rawValue] as? String == email }
    }
    
    /// 保存当前登录用户
    class func ErigoSaveNowAcc(email: String) {
        ErigoSaveValue(email, forKey: .NOWACC)
    }
    
    /// 获取当前登录用户
    class func ErigoAvNowAcc() -> String {
        return ErigoAssignValue(forKey: .NOWACC) ?? ""
    }
    
    /// 获取所有用户信息
    class func ErigoAvUsersDetails() -> [String: Data] {
        return ErigoAssignValue(forKey: .MYDETILS) ?? [:]
    }
    
    /// 匹配用户登录账号密码
    class func ErigoMatchACP(email: String, userPwd: String) -> Bool {
        if let userInfo = ErigoAvUserAssign(email: email),
           let storedPassword = userInfo[ERIGODEFAULT.PASSWORD.rawValue] as? String {
            if storedPassword != userPwd {
                ErigoProgressVM.ErigoShow(type: .failed, text: "User account password error!")
            }
            return storedPassword == userPwd
        }
        ErigoProgressVM.ErigoShow(type: .failed, text: "User account does not exist!")
        return false
    }
    
    /// 获取当前用户信息
    class func ErigoAvNowUser() -> ErigoUserM {
        let userDetailsDict = ErigoAvUsersDetails()
        let userNow = ErigoAvNowAcc()
        if let jsonData = userDetailsDict[userNow]{
            do {
                let decodeUser = try JSONDecoder().decode(ErigoUserM.self, from: jsonData)
                return decodeUser
            } catch {}
        }
        return ErigoUserM()
    }
    
    /// 删除指定用户信息
    class func ErigoDelUser() {
        var userNow = ErigoAvUsersDetails()
        var users = ErigoAvUsers()
        let nowAcc = ErigoAvNowAcc()
        
        userNow.removeValue(forKey: nowAcc)
        users.removeAll { $0[ERIGODEFAULT.ACCOUNT.rawValue] as? String == nowAcc }
        
        ErigoSaveValue(userNow, forKey: .MYDETILS)
        ErigoSaveValue(users, forKey: .COMPLETE)
        ErigoSaveValue("", forKey: .NOWACC)
        
        print("所有用户: \(users)")
        print("所有用户信息: \(userNow)")
    }
    
    /// 保存指定用户信息
    class func ErigoSaveDetails(email: String, details: Data) {
        var userDetailsDict = ErigoAvUsersDetails()
        userDetailsDict[email] = details
        ErigoSaveValue(userDetailsDict, forKey: .MYDETILS)
    }
    
    /// 修改用户详细信息
    class func updateUserDetails(erigo: (ErigoUserM) -> ErigoUserM) {
        var userNow = ErigoAvNowUser()
        let noewAcc = ErigoAvNowAcc()
        userNow = erigo(userNow)
        do {
            let encodedData = try JSONEncoder().encode(userNow)
            ErigoSaveDetails(email: noewAcc, details: encodedData)
        } catch {}
    }
    
    /// 记录限制礼物
    class func ErigoRecordGift(isLimited: Bool) {
        ErigoSaveValue(isLimited, forKey: .LIMIT)
    }
    
    /// 读取限制礼物
    class func ErigoGiftLimit() -> Bool? {
        return ErigoAssignValue(forKey: .LIMIT) ?? false
    }
    
    /// 记录VIP状态
    class func ErigoRecordVIP(isVIP: Bool) {
        ErigoSaveValue(isVIP, forKey: .VIP)
    }
    
    /// 读取VIP状态
    class func ErigoReadVIP() -> Bool? {
        return ErigoAssignValue(forKey: .VIP) ?? false
    }
}
