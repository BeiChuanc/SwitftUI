//
//  ErigoMesVM.swift
//  Erigo
//
//  Created by 北川 on 2025/4/22.
//

import Foundation

class ErigoMesVM: ObservableObject {
    
    static let shared = ErigoMesVM()
    
    @Published var mesListUser: [ErigoEyeUserM] = []
    
}
