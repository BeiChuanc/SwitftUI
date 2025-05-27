import Foundation
import UIKit

protocol UvooStorageBehavior {
    
    static var key: String { get }
}

extension UvooStorageBehavior where Self: Codable {
    
    static func save(_ object: Self) {
        do {
            let data = try JSONEncoder().encode(object)
            UserDefaults.standard.set(data, forKey: key)
        } catch {}
    }
    
    static func save(_ objects: [Self]) {
        do {
            let data = try JSONEncoder().encode(objects)
            UserDefaults.standard.set(data, forKey: key)
        } catch {}
    }
    
    static func load() -> Self? {
        guard let data = UserDefaults.standard.data(forKey: key) else { return nil }
        do {
            return try JSONDecoder().decode(Self.self, from: data)
        } catch { return nil }
    }
    
    static func loadArray() -> [Self]? {
        guard let data = UserDefaults.standard.data(forKey: key) else { return nil }
        do {
            return try JSONDecoder().decode([Self].self, from: data)
        } catch { return nil }
    }
    
    static func update(_ transform: (inout Self) -> Void) {
        guard var object = load() else { return }
        transform(&object)
        save(object)
    }
    
    static func delete() {
        UserDefaults.standard.removeObject(forKey: key)
    }
}

@propertyWrapper
struct UserDefault<T> {
    
    let key: String
    
    let oldValue: T
    
    init(key: String, defaultValue: T) {
        self.key = key
        self.oldValue = defaultValue
    }
    
    var wrappedValue: T {
        get { UserDefaults.standard.object(forKey: key) as? T ?? oldValue }
        set { UserDefaults.standard.set(newValue, forKey: key) }
    }
    
}

enum UvooUserKey {
    
    static var login: String { return "login" }
    
    static var email: String { return "email" }
    
    static var pwd: String { return "pwd" }
    
    static var userInfo: String { return "userInfo" }
    
    static var current: String { return "current" }
    
    static var limit: String { return "limit" }
    
    static var isVIP: String { return "isVIP" }
}


class UvooUserDefaultsUtils {
    
    @UserDefault(key: UvooUserKey.current, defaultValue: "")
    static var currentUser: String
    
    static func UvooSaveUsers(email: String, pwd: String) {
        var users = UvooGetUsers()
        if let index = users.firstIndex(where: { $0.email == email }) {
            users[index].pwd = pwd
        } else {
            users.append(UvooLoginM(email: email, pwd: pwd))
        }
        users.save()
    }
    
    static func UvooGetUsers() -> [UvooLoginM] {
        return UvooLoginM.loadArray() ?? []
    }
    
    static func UvooVerifyUser(email: String, pwd: String) -> Bool {
        if UvooGetUsers().contains(where: { $0.email == email }) {
            guard UvooGetUsers().contains(where: { $0.pwd == pwd }) else {
                UvooLoadVM.UvooShow(type: .failed, text: "User password error.")
                return false
            }
            return true
        }
        UvooLoadVM.UvooShow(type: .failed, text: "User does not exist.")
        return false
    }
    
    static func UvooLoginIn(email: String) {
        currentUser = email
    }
    
    static func UvooLogout() {
        UvooLoginVM.shared.isLand = false
        currentUser = ""
    }
    
    static func UvooDelUser() {
        var users = UvooGetUsers()
        users.removeAll(where: { $0.email == currentUser })
        users.save()
        UvooUserM.delete()
        UvooLogout()
    }
    
    static func UvooSaveUserInfo(_ info: UvooUserM) {
        UvooUserM.save(info)
    }
    
    static func UvooGetUserInfo() -> UvooUserM? {
        return UvooUserM.load()
    }
    
    static func UvooUpdateUserInfo(_ transform: (inout UvooUserM) -> Void) {
        UvooUserM.update(transform)
    }
    
    static func UvooSaveLimit(_ islimit: Bool) {
        UserDefaults.standard.set(islimit, forKey: UvooUserKey.limit)
    }
    
    static func UvooGetLimit() -> Bool {
        return UserDefaults.standard.bool(forKey: UvooUserKey.limit)
    }
    
    static func UvooSaveVIP(_ isvip: Bool) {
        UserDefaults.standard.set(isvip, forKey: UvooUserKey.isVIP)
    }
    
    static func UvooGetVIP() -> Bool {
        return UserDefaults.standard.bool(forKey: UvooUserKey.isVIP)
    }
}
