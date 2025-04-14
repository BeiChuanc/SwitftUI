//
//  PeppyRouteManager.swift
//  Peppy
//
//  Created by 北川 on 2025/4/11.
//

import Foundation
import SwiftUICore
import SwiftUI

// MARK: 全局路由管理器
class PeppyRouteManager: ObservableObject {
    
    // 主导航栈
    @Published var path = NavigationPath()
    
    // 当前模态路由（支持多个模态层叠）
    @Published var presentedModals: [PeppyRoute] = []
    
    // 导航栏显示状态
    @Published var isNavigationBarHidden = false
    
    // 根索引
    @Published var tabBarSelectIndex: Int = 0
        
    static let shared = PeppyRouteManager()
    
    init() {}
    
    // MARK: - 核心导航方法
    // 标准导航
    func navigate(to route: PeppyRoute) {
        path.append(route)
        updateNavigationBarState()
    }
    
    // 展示模态
    func presentModal(_ route: PeppyRoute) {
        presentedModals.append(route)
        updateNavigationBarState()
    }
    
    // 关闭当前模态
    func dismissModal() {
        guard !presentedModals.isEmpty else { return }
        presentedModals.removeLast()
        updateNavigationBarState()
    }
    
    // 返回上一级
    func pop() {
        guard !path.isEmpty else { return
            print(path)
        }
        path.removeLast()
        updateNavigationBarState()
    }
    
    // 返回根
    func popRoot() {
        path.removeLast(path.count)
        tabBarSelectIndex = 0
        updateNavigationBarState()
    }
    
    // MARK: - 导航栏控制
    private func updateNavigationBarState() {
        withAnimation(.easeInOut(duration: 0.25)) {
            // 根据当前路由类型决定导航栏显示状态
            isNavigationBarHidden = !presentedModals.isEmpty
        }
    }
}
