//
//  ErigoPurchaseM.swift
//  Erigo
//
//  Created by 北川 on 2025/4/25.
//

import Foundation

// MARK: 商品
struct ErigoStoreM: Identifiable, Codable {
    
    var id = UUID()
    
    var Id: Int?
    
    var gId: String?
    
    var gName: String?
    
    var gPrice: String?
    
    var isVIP: Bool?
    
    var isLimit: Bool?
    
    enum CodingKeys: String, CodingKey {
        
        case Id = "Id"
        
        case gId = "gId"
        
        case gName = "gName"
        
        case gPrice = "gPrice"
        
        case isVIP = "isVIP"
        
        case isLimit = "isLimit"
    }
}
