//
//  PeppyJsonManager.swift
//  Peppy
//
//  Created by 北川 on 2025/4/10.
//

import Foundation

// MARK: 公共方法
class PeppyComManager {
    
    /// 获取当前时间: 时:分
    static func peppyGetCurrentTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let currentDate = Date()
        return dateFormatter.string(from: currentDate)
    }
}
