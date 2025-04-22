//
//  ErigoApp.swift
//  ErigoApp
//
//  Created by 北川 on 2025/4/16.
//

import SwiftUI

@main
struct ErigoApp: App {
    
    @State var isEnterTabBar: Bool = false
    
    var body: some Scene {
        WindowGroup {
            if isEnterTabBar {
                ErigoTabBar()
            } else {
                ZStack {
                    ErigoLaunch().onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            isEnterTabBar = true
                        }
                    }
                }.ignoresSafeArea()
            }
        }
    }
}
