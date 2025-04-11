//
//  TabBarContenView.swift
//  Peppy
//
//  Created by 北川 on 2025/4/9.
//

import SwiftUI

// MARK: 自定义TabBar
struct TabBarContenView: View {
    
    @State var selectTabBarIndex = 0
    
    @StateObject var loginMould = PeppyLoginManager()
    
    @EnvironmentObject var peppyRouter: PeppyRouteManager
    
    let navItems = [
        (normal: "home_normal", select: "home_select"),
        (normal: "tree_normal", select: "tree_select"),
        (normal: "center_normal", select: "center_select")
    ]
    
    var body: some View {
        ZStack(alignment: .bottom) {
            switch selectTabBarIndex {
            case 0:
                PeppyHomePage()
                    .environmentObject(peppyRouter)
                    .environmentObject(loginMould)
            case 1:
                PeppyTreePage()
                    .environmentObject(peppyRouter)
                    .environmentObject(loginMould)
            case 2:
                Text("dkjashdad")
            default:
                EmptyView()
            }
            Spacer()
            HStack {
                ForEach(0..<navItems.count, id: \.self) { index in
                    let item = navItems[index]
                    tabBarItem(
                        normalImage: item.normal,
                        selectImage: item.select,
                        isSelected: selectTabBarIndex == index,
                        action: {
                            selectTabBarIndex = index
                        }
                    )
                }
            }.frame(height: 80)
        }
        .onAppear {
            // 加载配置
            PeppyLoadManager.globalProgressConfig()
            // 加载用户媒体
            PeppyUserDataManager.shared.peppyGetUserData()
            // 加载动物
            PeppyUserDataManager.shared.peppyGetAnimals()
        }
    }
}

#Preview {
    TabBarContenView()
}
