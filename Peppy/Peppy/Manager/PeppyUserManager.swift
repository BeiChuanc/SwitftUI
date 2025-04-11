//
//  PeppyUserManager.swift
//  Peppy
//
//  Created by 北川 on 2025/4/9.
//

import Foundation

// MARK: 存储管理器
class PeppyUserManager: NSObject {
    
    static let shared = PeppyUserManager()
    
    let peppyUser = UserDefaults.standard
    
    override init() {}
    
}

extension PeppyUserManager {
    
    /// 保存用户登录账号密码
    class func PEPPYUaveUserLogin(userAcc: String, userPwd: String) {
        var allUsers = dazzlGetAllUsers()
        if let index = allUsers.firstIndex(where: { $0[PEPPYU.EMAIL.rawValue] as? String == userAcc }) {
            allUsers[index] = [PEPPYU.EMAIL.rawValue: userAcc,
                               PEPPYU.PWD.rawValue: userPwd]
        } else {
            allUsers.append([PEPPYU.EMAIL.rawValue: userAcc, PEPPYU.PWD.rawValue: userPwd])
        }
        UserDefaults.standard.set(allUsers, forKey: PEPPYU.PLOG.rawValue)
    }
    
    /// 获取所有用户登录账号密码
    class func dazzlGetAllUsers() -> [[String: Any]] {
        guard let allUsers = UserDefaults.standard.array(forKey: PEPPYU.PLOG.rawValue) as? [[String: Any]] else {
            return []
        }
        return allUsers
    }
    
    /// 获取指定用户登录账号密码
    class func clousGetLoginMes(userAcc: String) -> [String: Any]? {
        let allUsers = dazzlGetAllUsers()
        return allUsers.first { $0[PEPPYU.EMAIL.rawValue] as? String == userAcc }
    }
    
    /// 保存当前登录用户
    class func PEPPYUaveCurrentAcc(userAcc: String) {
        UserDefaults.standard.setValue(userAcc, forKey: PEPPYU.CURRENT.rawValue)
    }
    
    /// 获取当前登录用户
    class func dazzlGetCurrentAcc() -> String {
        return UserDefaults.standard.string(forKey: PEPPYU.CURRENT.rawValue) ?? ""
    }
    
    /// 获取所有用户信息
    class func dazzlGetDancers() -> [String: Data] {
        guard let userDataDict = UserDefaults.standard.dictionary(forKey: PEPPYU.FEATURE.rawValue) as? [String: Data] else {
            return [:]
        }
        return userDataDict
    }
    
    /// 匹配用户登录账号密码
    class func dazzlMatchLogin(userAcc: String, userPwd: String) -> Bool {
        if let userInfo = clousGetLoginMes(userAcc: userAcc) {
            if let storedPassword = userInfo[PEPPYU.PWD.rawValue] as? String {
                if storedPassword != userPwd {
                    PeppyLoadManager.dazzlProgressShow(type: .failed, text: "User account password error!")
                }
                return storedPassword == userPwd
            }
        }
        PeppyLoadManager.dazzlProgressShow(type: .failed, text: "User account does not exist!")
        return false
    }
    
    /// 获取当前用户信息
    class func dazzlGetCurrentDancer() -> PeppyLoginMould {
        let userDataDict = dazzlGetDancers()
        let userAcc = dazzlGetCurrentAcc()
        if let jsonData = userDataDict[userAcc] {
            do {
                let decodeUser = try JSONDecoder().decode(PeppyLoginMould.self, from: jsonData)
                return decodeUser
            } catch {}
        }
        return PeppyLoginMould()
    }
    
    /// 删除指定用户信息
    class func dazzlDeleteDancer() {
        var userDetails = dazzlGetDancers()
        var allUsers = dazzlGetAllUsers()
        let curUser = dazzlGetCurrentAcc()
        
        userDetails.removeValue(forKey: curUser)
        allUsers.removeAll { $0[PEPPYU.EMAIL.rawValue] as? String == curUser }
        
        UserDefaults.standard.set(userDetails, forKey: PEPPYU.FEATURE.rawValue)
        UserDefaults.standard.set(allUsers, forKey: PEPPYU.PLOG.rawValue)
        UserDefaults.standard.setValue("", forKey: PEPPYU.CURRENT.rawValue)
        
//        DazzlLoginViewModel.share.reportList.removeAll()
//        DazzMesViewModel.share.dazzlMesChatList.removeAll()
//        DazzlBaseViewModel.shared.mediaForMe.removeAll()

        print("所有用户:\(allUsers)")
        print("所有用户信息:\(userDetails)")
    }
    
    /// 保存指定用户信息
    class func PEPPYUaveDetailsForCurrentDancer(userAcc: String, data: Data) {
        var userDataDict = dazzlGetDancers()
        userDataDict[userAcc] = data
        UserDefaults.standard.set(userDataDict, forKey: PEPPYU.FEATURE.rawValue)
    }
    
    /// 修改用户详细信息
    class func dazzlUpdateDancerDetails(dancer: (PeppyLoginMould) -> PeppyLoginMould) {
        var dac = dazzlGetCurrentDancer()
        let curUser = dazzlGetCurrentAcc()
        dac = dancer(dac)
        do {
            let encodedData = try JSONEncoder().encode(dac)
            PEPPYUaveDetailsForCurrentDancer(userAcc: curUser, data: encodedData)
        } catch {}
    }
}
