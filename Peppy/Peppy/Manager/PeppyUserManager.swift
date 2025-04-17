import Foundation

// MARK: 存储管理器
class PeppyUserManager: NSObject {
    
    let peppyUser = UserDefaults.standard
    
    override init() {}
}

extension PeppyUserManager {
    
    /// 保存用户登录账号密码
    class func PEPPYUaveUserLogin(userAcc: String, userPwd: String) {
        var allUsers = PEPPYGetAllUsers()
        if let index = allUsers.firstIndex(where: { $0[PEPPYU.EMAIL.rawValue] as? String == userAcc }) {
            allUsers[index] = [PEPPYU.EMAIL.rawValue: userAcc,
                               PEPPYU.PWD.rawValue: userPwd]
        } else {
            allUsers.append([PEPPYU.EMAIL.rawValue: userAcc, PEPPYU.PWD.rawValue: userPwd])
        }
        UserDefaults.standard.set(allUsers, forKey: PEPPYU.PLOG.rawValue)
    }
    
    /// 获取所有用户登录账号密码
    class func PEPPYGetAllUsers() -> [[String: Any]] {
        guard let allUsers = UserDefaults.standard.array(forKey: PEPPYU.PLOG.rawValue) as? [[String: Any]] else {
            return []
        }
        return allUsers
    }
    
    /// 获取指定用户登录账号密码
    class func PEPPYGetLoginMes(userAcc: String) -> [String: Any]? {
        let allUsers = PEPPYGetAllUsers()
        return allUsers.first { $0[PEPPYU.EMAIL.rawValue] as? String == userAcc }
    }
    
    /// 保存当前登录用户
    class func PEPPYUaveCurrentAcc(userAcc: String) {
        UserDefaults.standard.setValue(userAcc, forKey: PEPPYU.CURRENT.rawValue)
    }
    
    /// 获取当前登录用户
    class func PEPPYGetCurrentAcc() -> String {
        return UserDefaults.standard.string(forKey: PEPPYU.CURRENT.rawValue) ?? ""
    }
    
    /// 获取所有用户信息
    class func PEPPYGetUsers() -> [String: Data] {
        guard let userDataDict = UserDefaults.standard.dictionary(forKey: PEPPYU.FEATURE.rawValue) as? [String: Data] else {
            return [:]
        }
        return userDataDict
    }
    
    /// 匹配用户登录账号密码
    class func PEPPYMatchLogin(userAcc: String, userPwd: String) -> Bool {
        if let userInfo = PEPPYGetLoginMes(userAcc: userAcc) {
            if let storedPassword = userInfo[PEPPYU.PWD.rawValue] as? String {
                if storedPassword != userPwd {
                    PeppyLoadManager.peppyProgressShow(type: .failed, text: "User account password error!")
                }
                return storedPassword == userPwd
            }
        }
        PeppyLoadManager.peppyProgressShow(type: .failed, text: "User account does not exist!")
        return false
    }
    
    /// 获取当前用户信息
    class func PEPPYCurrentUser() -> PeppyLoginMould {
        let userDataDict = PEPPYGetUsers()
        let userAcc = PEPPYGetCurrentAcc()
        if let jsonData = userDataDict[userAcc] {
            do {
                let decodeUser = try JSONDecoder().decode(PeppyLoginMould.self, from: jsonData)
                return decodeUser
            } catch {}
        }
        return PeppyLoginMould()
    }
    
    /// 删除指定用户信息
    class func PEPPYDeleteUer() {
        var userCurr = PEPPYGetUsers()
        var allUsers = PEPPYGetAllUsers()
        let curAcc = PEPPYGetCurrentAcc()
        
        userCurr.removeValue(forKey: curAcc)
        allUsers.removeAll { $0[PEPPYU.EMAIL.rawValue] as? String == curAcc }
        
        UserDefaults.standard.set(userCurr, forKey: PEPPYU.FEATURE.rawValue)
        UserDefaults.standard.set(allUsers, forKey: PEPPYU.PLOG.rawValue)
        UserDefaults.standard.setValue("", forKey: PEPPYU.CURRENT.rawValue)

        print("所有用户:\(allUsers)")
        print("所有用户信息:\(userCurr)")
    }
    
    /// 保存指定用户信息
    class func PEPPYUaveDetailsForCurrent(userAcc: String, data: Data) {
        var userDataDict = PEPPYGetUsers()
        userDataDict[userAcc] = data
        UserDefaults.standard.set(userDataDict, forKey: PEPPYU.FEATURE.rawValue)
    }
    
    /// 修改用户详细信息
    class func PEPPYUpdateUserDetails(pey: (PeppyLoginMould) -> PeppyLoginMould) {
        var dac = PEPPYCurrentUser()
        let curUser = PEPPYGetCurrentAcc()
        dac = pey(dac)
        do {
            let encodedData = try JSONEncoder().encode(dac)
            PEPPYUaveDetailsForCurrent(userAcc: curUser, data: encodedData)
        } catch {}
    }
}
