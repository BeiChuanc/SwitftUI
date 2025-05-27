import Foundation

struct UvooPublishM: Codable {
    
    var tId: Int
    
    var bId: Int
    
    var head: String
    
    var name: String
    
    var title: String
    
    var content: String
    
    var cover: [String]
    
    var imags: [String]
    
    var isVideo: Bool
    
    var likes: Int
    
    var comment: [UvooCommentM]
}

struct UvooCommentM: Codable {
    
    var bId: Int
    
    var reply: String
}
