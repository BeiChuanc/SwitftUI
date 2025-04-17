import Foundation

// MARK: 宠物模型
struct PeppyAnimalMould: Identifiable, Hashable, Codable {
    
    // 唯一ID
    var id = UUID()
    
    // 宠物ID
    var animalId: Int
    
    // 宠物头像
    var animalHead: String
    
    // 宠物名称
    var animalName: String
    
    // 宠物解锁人数
    var animalStar: Int
    
    enum CodingKeys: String, CodingKey {
        
        case animalId = "aId"
        
        case animalHead = "aHead"
        
        case animalName = "aName"
        
        case animalStar = "star"
    }
}
