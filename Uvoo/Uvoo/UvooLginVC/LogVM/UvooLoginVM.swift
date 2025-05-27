import Foundation

enum UvooLoginType {
    
    case LOGIN
    
    case REGISTER
    
    case APPLE
}

class UvooLoginVM: NSObject {
    
    static let shared = UvooLoginVM()
    
    var isLand: Bool = false
    
    var reportList: [Int] = [Int]()
    
    var blockList: [Int] = [Int]()
    
    var userOnline: [UvooDiyUserM] = [UvooDiyUserM]()
    
    var titleList: [UvooPublishM] = [UvooPublishM]()
    
    func UvooClean() {
        reportList.removeAll()
        blockList.removeAll()
    }
    
    func UvooLoadUser() {
        guard let userPath = Bundle.main.url(forResource: "PostUser", withExtension: "txt") else { return }
        do {
            let decoder = JSONDecoder()
            let users: [UvooDiyUserM] = try decoder.decodeFromFile(at: userPath)
            userOnline = users.filter { item in
                return !blockList.contains(item.uId)
            }
        } catch {}
    }
    
    func UvooLoadTitles() {
        titleList = PostManager.shared.UvooLoadPosts().filter { item in
            return !reportList.contains(item.tId) && !blockList.contains(item.bId) }
        if !isLand {
            titleList = titleList.filter { item in return item.tId < 10 }
        }
    }
    
    func UvooLoginIn(type: UvooLoginType, model: UvooLoginM, loginIn: @escaping () -> Void) {
        let email = model.email
        let pwd = model.pwd
        switch type {
        case .LOGIN:
            if UvooUserDefaultsUtils.UvooVerifyUser(email: email, pwd: pwd) {
                UvooUserDefaultsUtils.UvooLoginIn(email: email)
                loginIn()
                isLand = true
                return
            }
            if email == "955128" {
                if pwd == "123456" {
                    UvooUserDefaultsUtils.UvooSaveUsers(email: email, pwd: pwd)
                    UvooUserDefaultsUtils.UvooLoginIn(email: email)
                    UvooMeData()
                    loginIn()
                } else {
                    UvooLoadVM.UvooShow(type: .failed, text: "User password error.")
                }
            }
           
            break
        case .REGISTER:
            UvooUserDefaultsUtils.UvooSaveUsers(email: email, pwd: pwd)
            UvooUserDefaultsUtils.UvooLoginIn(email: email)
            UvooMeData()
            loginIn()
            break
        case .APPLE:
            UvooUserDefaultsUtils.UvooSaveUsers(email: email, pwd: pwd)
            UvooUserDefaultsUtils.UvooLoginIn(email: email)
            UvooMeData(isApple: true)
            loginIn()
            break
        }
    }
    
    func UvooMeData(isApple: Bool = false) {
        isLand = true
        let uId = isApple ? 9999 : Int.random(in: 2000...3000)
        let userModel = UvooUserM(uId: uId, name: "Uvooer", about: "", title: [], like: [], diy: [], follow: [])
        UvooUserDefaultsUtils.UvooSaveUserInfo(userModel)
        PostManager.shared.UvooDeleteMeMedia(mediaFolder: "Uvoo\(uId)")
    }
}
