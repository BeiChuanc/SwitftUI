import Foundation

class BleoMyDetailM: NSObject, Codable {
    
    var uId: Int?
    
    var head: Data?
    
    var cover: Data?
    
    var name: String?
    
    var details: String?
    
    var follow: [BleoUserM]
    
    var likePost: [Int]
    
    var mes: [Int: [BleoMessageM]]
    
    var post: [BleoTitleM]
    
    init(uId: Int? = nil, head: Data? = nil, cover: Data? = nil, name: String? = nil, details: String? = nil, follow: [BleoUserM] = [], likePost: [Int] = [], mes: [Int : [BleoMessageM]] = [:], post: [BleoTitleM] = []) {
        self.uId = uId
        self.head = head
        self.cover = cover
        self.name = name
        self.details = details
        self.follow = follow
        self.likePost = likePost
        self.mes = mes
        self.post = post
    }
}

struct BleoMessageM: Codable {
    
    var mes: String
    
    var time: String
    
    var formMe: Bool
}

struct BleoShowViewsCellM {
    
    var showViewsImage: String?
    
    var showViewsText: String?
    
}

struct BleoUserM: Codable {
    
    var uId: Int
    
    var uHead: String
    
    var intro: String
    
    var uName: String
    
    var post: [Int]
}

struct BleoCommentM: Codable {
    
    var cuId: Int
    
    var chead: String
    
    var comment: String
    
    var time: String
}

struct BleoTitleM: Codable {
    
    var tId: Int
    
    var uId: Int
    
    var head: String
    
    var name: String
    
    var tCover: String
    
    var tUrl: String
    
    var content: String
    
    var meType: Bool
    
    var tCom: [BleoCommentM]
}

struct BleoLogM: Codable {
    
    var user: String
    
    var password: String
}
