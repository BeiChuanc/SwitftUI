import Foundation

class BleoPrefence {
    
    static func BleoSaveUser(_ log: BleoLogM) {
        var users = UserDefaults.standard.array(forKey: BLEOPREFENCEKEY.LOG) as? [[String: Any]] ?? []
        if let index = users.firstIndex(where: { $0[BLEOPREFENCEKEY.EMAIL] as? String == log.user }) {
            users[index] = [BLEOPREFENCEKEY.EMAIL: log.user,
                            BLEOPREFENCEKEY.PWD: log.password]
        } else {
            users.append([BLEOPREFENCEKEY.EMAIL: log.user, BLEOPREFENCEKEY.PWD: log.password])
        }
        UserDefaults.standard.set(users, forKey: BLEOPREFENCEKEY.LOG)
    }
    
    static func BleoGetUsers() -> [[String: Any]] {
        return UserDefaults.standard.array(forKey: BLEOPREFENCEKEY.LOG) as? [[String: Any]] ?? []
    }
    
    static func BleoGetOne(_ name: String) -> [String: Any]? {
        let users = BleoGetUsers()
        return users.first(where: { $0[BLEOPREFENCEKEY.EMAIL] as? String == name })
    }
    
    static func BleoSaveCurrentUser(_ user: String) {
        UserDefaults.standard.set(user, forKey: BLEOPREFENCEKEY.CUERRENT)
    }
    
    static func BleoGetCurrentUser() -> String {
        return UserDefaults.standard.string(forKey: BLEOPREFENCEKEY.CUERRENT) ?? ""
    }
    
    static func BleoGetAllUser() -> [String: Data] {
        return UserDefaults.standard.dictionary(forKey: BLEOPREFENCEKEY.USER) as? [String: Data] ?? [:]
    }
    
    static func BleoSaveUserData(_ log: BleoLogM, userData: Data) {
        var data = BleoGetAllUser()
        data[log.user] = userData
        UserDefaults.standard.set(data, forKey: BLEOPREFENCEKEY.USER)
    }
    
    static func BleoGetCurUserData() -> BleoMyDetailM {
        let data = BleoGetAllUser()
        let cur = BleoGetCurrentUser()
        if let json = data[cur] {
            do {
                let deData = try JSONDecoder().decode(BleoMyDetailM.self, from: json)
                return deData
            } catch {}
        }
        return BleoMyDetailM()
    }
    
    static func BleoUpdateUser(user: (inout BleoMyDetailM) -> Void, _ log: BleoLogM) {
        var data = BleoGetCurUserData()
        let cur = BleoGetCurrentUser()
        user(&data)
        do {
            let enData = try JSONEncoder().encode(data)
            BleoSaveUserData(log, userData: enData)
        } catch {}
    }
    
    static func BleoDelUser() {
        var usersData = BleoGetAllUser()
        var users = BleoGetUsers()
        usersData.removeValue(forKey: BleoGetCurrentUser())
        users.removeAll(where: { $0[BLEOPREFENCEKEY.EMAIL] as? String == BleoGetCurrentUser() })
        UserDefaults.standard.set(users, forKey: BLEOPREFENCEKEY.LOG)
        UserDefaults.standard.set(usersData, forKey: BLEOPREFENCEKEY.USER)
        UserDefaults.standard.set("", forKey: BLEOPREFENCEKEY.CUERRENT)
    }
    
    static func BleoMatchUser(_ log: BleoLogM) -> Bool {
        if let user = BleoGetOne(log.user) {
            if let pwd = user[BLEOPREFENCEKEY.PWD] as? String {
                if pwd != log.password {
                    BleoToast.BleoShow(type: .failed, text: "Passwords do not match.")
                }
                return pwd == log.password
            }
        }
        BleoToast.BleoShow(type: .failed, text: "User does not exist.")
        return false
    }
}
