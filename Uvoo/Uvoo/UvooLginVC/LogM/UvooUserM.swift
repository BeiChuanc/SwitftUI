import Foundation

struct UvooLoginM: Codable {
    
    var email: String
    
    var pwd: String
}

class UvooUserM: Codable {
    
    var uId: Int
    
    var head: Data?
    
    var name: String
    
    var about: String
    
    var follow: [UvooDiyUserM]
    
    var title: [UvooPublishM]
    
    var like: [UvooPublishM]
    
    var diy: [UvooLibM]
    
    init(uId: Int, head: Data? = nil, name: String, about: String, title: [UvooPublishM], like: [UvooPublishM], diy: [UvooLibM], follow: [UvooDiyUserM]) {
        self.uId = uId
        self.head = head
        self.name = name
        self.about = about
        self.title = title
        self.like = like
        self.diy = diy
        self.follow = follow
    }
}

extension UvooUserM: UvooStorageBehavior {
    
    static var key: String {
        let currentUser = UvooUserDefaultsUtils.currentUser
        return "\(UvooUserKey.userInfo)_\(currentUser)"
    }
}

extension UvooLoginM: UvooStorageBehavior {
    
    static var key: String = UvooUserKey.login
}

struct UvooDiyUserM: Codable {
    
    var uId: Int
    
    var head: String
    
    var name: String
    
    var about: String
    
    var follow: Int
    
    var followers: Int
    
    var like: [Int]
}
