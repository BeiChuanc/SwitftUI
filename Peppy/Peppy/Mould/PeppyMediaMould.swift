import Foundation
import UIKit

// MARK: 用户发布的媒体模型
struct PeppyMyMedia: Identifiable, Hashable, Codable {
    
    // 协议唯一标识
    var id = UUID()
    
    // 媒体Id
    var mediaId: Int?
    
    // 媒体地址
    var mediaUrl: URL?
    
    // 媒体类型
    var mediaType: PEPPYMEDIATYPE?
    
    // 内容
    var mediaContent: String?
    
    // 媒体发布时间
    var mediaTime: String?
}

// MARK: 相册数据模型
struct PeppyMediaLibrary {
    
    let type: PEPPYMEDIATYPE
    
    let image: UIImage?
    
    let videoURL: URL?
    
    var meidaData: Data?
}
