//
//  ErigoInvariants.swift
//  Erigo
//
//  Created by 北川 on 2025/4/16.
//

import Foundation
import UIKit

// MARK: 屏幕高宽
enum ERIGOSCREEN {
    
    static var WIDTH: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    static var HEIGHT: CGFloat {
        return UIScreen.main.bounds.height
    }
}

// MARK: 发布类型
enum ERIGOMEDIATYPE: Int, Codable {
    
    case VIDEO
    
    case IMAGE
}

// MARK: 举报类型
enum ERIGOREPORTTYPE: Int {
    
    case USER
    
    case TITLE
}

// MARK: 状态
enum ERIGOSTATUS {
    
    case LOAD
    
    case COMPLETE
    
    case FAIL
}

// MARK: 协议
enum ERIGOLINK {
    
    static var TER: String {
        return "https://www.freeprivacypolicy.com/live/a43b76cb-8424-446d-8a97-dafcc7c13f32"
    }
    
    static var POL: String {
        return "https://www.freeprivacypolicy.com/live/e4061f8f-a92d-4810-b178-c8370977eec0"
    }
    
    static var EUA: String {
        return "https://www.freeprivacypolicy.com/live/f5af0bfe-723d-480f-8e1d-42d812f36d34"
    }
}

