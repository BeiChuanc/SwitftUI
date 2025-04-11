//
//  PeppyUserDataManager.swift
//  Peppy
//
//  Created by 北川 on 2025/4/10.
//

import Foundation
import SwiftUI

// MARK: 用户数据管理器
class PeppyUserDataManager: ObservableObject {
    
    static let shared = PeppyUserDataManager()
    
    @Published var animailList: [PeppyAnimalMould] = []
    
    @Published var myMediaList: [PeppyMyMedia] = []
    
    /// 获取自己媒体
    func peppyGetUserData() {
        
    }
    
    /// 获取动物
    func peppyGetAnimals() {
        guard let jsonPath = Bundle.main.path(forResource: "AnimalData", ofType: "json") else {
            return }
        if #available(iOS 16.0, *) {
            let data = try? Data(contentsOf: URL(filePath: jsonPath))
            if let dancers = PeppyJsonManager.decode(data: data!, to: [PeppyAnimalMould].self) {
                for dac in dancers {
                    if !animailList.contains(where: { $0.animalId == dac.animalId}) {
                        animailList.append(dac)
                    }
                }
            }
        } else {}
    }
}
