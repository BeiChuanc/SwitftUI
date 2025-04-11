//
//  PeppyChatDataManager.swift
//  Peppy
//
//  Created by 北川 on 2025/4/10.
//

import Foundation
import SwiftUI

// MARK: 聊天管理器
class PeppyChatDataManager: ObservableObject {
    
    @Published var petsChatDataList: [String: [String: [[String: String]]]] = [:]
    
}
