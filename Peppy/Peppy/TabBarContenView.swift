import SwiftUI
import IQKeyboardManager

// MARK: 自定义TabBar
struct TabBarContenView: View {
    
    @State var path = NavigationPath()
    
    @ObservedObject var loginMould = PeppyLoginManager()
    
    @ObservedObject var peppyRouter = PeppyRouteManager()
    
    let navItems = [
        (normal: "home_normal", select: "home_select"),
        (normal: "tree_normal", select: "tree_select"),
        (normal: "feed_normal", select: "feed_select"),
        (normal: "center_normal", select: "center_select")
    ]
    
    var body: some View {
        NavigationStack(path: $peppyRouter.path) {
            ZStack(alignment: .bottom) {
                switch peppyRouter.tabBarSelectIndex {
                case 0:
                    PeppyHomePage()
                        .environmentObject(peppyRouter)
                        .environmentObject(loginMould)
                case 1:
                    PeppyTreePage()
                        .environmentObject(peppyRouter)
                        .environmentObject(loginMould)
                case 2:
                    PeppyAnimalFeedPage()
                        .environmentObject(peppyRouter)
                        .environmentObject(loginMould)
                case 3:
                    PeppySetPage()
                        .environmentObject(peppyRouter)
                        .environmentObject(loginMould)
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
                            isSelected: peppyRouter.tabBarSelectIndex == index,
                            action: {
                                peppyRouter.tabBarSelectIndex = index
                            }
                        )
                    }
                }.frame(height: 80)
            }
            .onAppear {
                // 加载配置
                PeppyLoadManager.globalProgressConfig()
                // 加载动物
                PeppyUserDataManager.shared.peppyGetAnimals()
                
                let userDetails = PeppyUserManager.PEPPYGetUsers()
                let allUsers = PeppyUserManager.PEPPYGetAllUsers()
                
                IQKeyboardManager.shared().isEnabled = true
                IQKeyboardManager.shared().shouldResignOnTouchOutside = true
                
                print("所有用户:\(allUsers)")
                print("所有用户信息:\(userDetails)")
            }
            .navigationDestination(for: PeppyRoute.self) { route in
                switch route {
                case .CHAT(let animalModel):
                    PeppyChatDetailsPage(animal: animalModel)
                        .environmentObject(peppyRouter)
                        .hideBackButton()
                case .LOGIN:
                    PeppyLoginPage()
                        .environmentObject(loginMould)
                        .environmentObject(peppyRouter)
                        .hideBackButton()
                case .REGISTER:
                    PeppyRegisterPage()
                        .environmentObject(loginMould)
                        .environmentObject(peppyRouter)
                        .hideBackButton()
                case .UPLOADHEAD:
                    PeppySelectPage()
                        .environmentObject(peppyRouter)
                        .hideBackButton()
                case .PLAYMEDIA(let mediaMould):
                    PeppyTreeMediaPage(media: mediaMould)
                        .environmentObject(peppyRouter)
                        .hideBackButton()
                case .RANKING:
                    PeppyRankingPage()
                        .environmentObject(loginMould)
                        .environmentObject(peppyRouter)
                        .hideBackButton()
                }
            }
        }
    }
}

