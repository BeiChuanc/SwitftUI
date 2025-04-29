//
//  ErigoRoutr.swift
//  Erigo
//
//  Created by 北川 on 2025/4/22.
//

import Foundation
import SwiftUI

// MARK: 路由
class ErigoRoute: ObservableObject {
    
    static let shared = ErigoRoute()
    
    @Published var path = NavigationPath()
    
    @Published var tabBarIndex: Int = 0
    
    @Published var isNavBarHidden = false
    
    @Published var isPreModal = false
    
    @Published var modalRoute: ERIGOROUTE?
    
    init() {}
    
    func naviTo(to route: ERIGOROUTE) {
        path.append(route)
    }
    
    func previous() {
        guard !path.isEmpty else { return
            print(path)
        }
        path.removeLast()
    }
    
    func previousFirst() {
        tabBarIndex = 0
    }
    
    func previousSecond() {
        tabBarIndex = 1
    }
    
    func previousRoot() {
        path.removeLast(path.count)
        tabBarIndex = 0
    }
    
    func preModal(route: ERIGOROUTE) {
        modalRoute = route
        isPreModal = true
    }
    
    func dismiss() {
        isPreModal = false
        modalRoute = nil
    }
}
