//
//  PeppyAnimalMould.swift
//  Peppy
//
//  Created by 北川 on 2025/4/10.
//

import Foundation

// MARK: 宠物模型
struct PeppyAnimalMould: Identifiable, Codable {
    
    // 唯一ID
    var id = UUID()
    
    // 宠物ID
    var animalId: Int
    
    // 宠物头像
    var animalHead: String
    
    // 宠物名称
    var animalName: String
    
    enum CodingKeys: String, CodingKey {
        
        case animalId = "aId"
        
        case animalHead = "aHead"
        
        case animalName = "aName"

    }
}
