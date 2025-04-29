//
//  ErigoRoute.swift
//  Erigo
//
//  Created by 北川 on 2025/4/16.
//

import Foundation

// MARK: 路由 - PUSH
enum ERIGOROUTE: Hashable {
    
    case LAND
    
    case ENROLL
    
    case SETTING
    
    case SINGLECHAT(ErigoEyeUserM)
    
    case DISGROUP
    
    case USERCENTER
    
    case VSHOWCASE
    
    case POSTDETAILS(ErigoEyeTitleM)
    
    case MESLIST
    
    case USERINFO(ErigoEyeUserM)
    
    case SHOW(ErigoEyeTitleM)
    
    case STORE
}
