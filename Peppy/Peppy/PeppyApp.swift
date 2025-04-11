//
//  PeppyApp.swift
//  Peppy
//
//  Created by 北川 on 2025/4/9.
//

import SwiftUI

@main
struct PeppyApp: App {
    var body: some Scene {
        WindowGroup {
            PeppyLaunch()
        }
    }
}

// MARK: 启动页
struct PeppyLaunch: View {
    
    @State private var showTabBar: Bool = false
    
    @StateObject var router = PeppyRouteManager()
    
    var body: some View {
        
        if showTabBar {
            NavigationStack(path: $router.path) {
                TabBarContenView() // 根
                    .environmentObject(router)
                    .navigationDestination(for: PeppyRoute.self) { route in
                        switch route {
                        case .CHAT(_):
                            Text("").hideBackButton()
                        case .SET:
                            PeppyddddContentView().hideBackButton()
                        case .LOGIN:
                            Text("").hideBackButton()
                        case .REGISTER:
                            Text("").hideBackButton()
                        case .UPLOADHEAD:
                            Text("").hideBackButton()
                        case .PLAYMEDIA:
                            PeppyTreeMediaPage()
                                .environmentObject(router)
                                .hideBackButton()
                        }
                    }
            }
        } else {
            ZStack {
                Image("launch")
                    .resizable()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                            showTabBar = true
                        })
                    }
            }.edgesIgnoringSafeArea(.all)
        }
    }
}

struct PeppyddddContentView: View {
    var body: some View {
        ZStack(alignment: .bottom) {
            Image("tree_empty").resizable()
                .ignoresSafeArea()
            
            Button(action: {
                withAnimation(.bouncy) {
                }
            }) {
                Image("btnPublish")
                    .resizable()
                    .frame(width: 160, height: 42)
            }.padding(.bottom, 200)
        }
    }
}
