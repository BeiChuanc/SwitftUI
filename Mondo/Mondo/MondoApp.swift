//
//  MondoApp.swift
//  Mondo
//
//  Created by 北川 on 2025/4/27.
//

import SwiftUI

@main
struct MondoApp: App {
    
    @State var enterTabBar: Bool = false
    
    var body: some Scene {
        WindowGroup {
            if enterTabBar {
                MondoTabBar()
            } else {
                ZStack {
                    Image("launch")
                        .resizable()
                        .ignoresSafeArea()
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // 导航
                        enterTabBar = true
                    }
                }
            }
        }
    }
}
