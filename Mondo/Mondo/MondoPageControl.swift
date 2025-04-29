//
//  MondoPageControl.swift
//  Mondo
//
//  Created by 北川 on 2025/4/27.
//

import Foundation
import SwiftUI

// MARK: 页面enum
enum MONDOPAGE: Hashable {
    
    case LOGIN
    
    case REGISTER
    
    case SET
    
    case RELEASE
    
    case SAFEGUIDE
    
    case SIDEBYSID(MondoerM)
    
    case SIDEGROUP(Int)
    
    case SAFEVIDEO
    
    case OTHERONE(MondoerM)
    
    case HOTNOTES
    
    case GUIDE(MondoGuideM)
    
    case SHOWDETAIL(MondoTitleM)
    
    case SHOWDETAILME(MondoTitleMeM)
}

// MARK: 导航
class MondoPageControl: ObservableObject {
    
    static let shared = MondoPageControl()
    
    @Published var path = NavigationPath()
    
    @Published var bottomIndex: Int = 0
    
    @Published var isUpPre = false
    
    @Published var routeM: MONDOPAGE?
    
    init() {}
    
    func route(to route: MONDOPAGE) {
        path.append(route)
    }
    
    func backToLevel() {
        guard !path.isEmpty else { return
            print(path)
        }
        path.removeLast()
    }
    
    func backToOriginal() {
        path.removeLast(path.count)
        bottomIndex = 0
    }
    
    func upModel(route: MONDOPAGE) {
        routeM = route
        isUpPre = true
    }
    
    func disModel() {
        isUpPre = false
        routeM = nil
    }
}
