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
    
    var body: some View {
        if showTabBar {
            TabBarContenView() // 根
        } else {
            ZStack {
                Image("launch")
                    .resizable()
                    .ignoresSafeArea()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                            showTabBar = true
                        })
                    }
            }.ignoresSafeArea()
        }
    }
}
