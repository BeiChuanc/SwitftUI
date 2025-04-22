//
//  ErigoTabBar.swift
//  Erigo
//
//  Created by 北川 on 2025/4/16.
//

import SwiftUI
import IQKeyboardManager

// MARK: 底部导航
struct ErigoTabBar: View {
    
    @State var path = NavigationPath()
    
    @ObservedObject var router = ErigoRoute()
    
    var body: some View {
        NavigationStack(path: $router.path) {
            ZStack(alignment: .bottom) {
                switch router.tabBarIndex {
                case 0:
                    ErigoCreativity().environmentObject(router)
                case 1:
                    ErigoPublish().environmentObject(router)
                case 2:
                    ErigoPersonal().environmentObject(router)
                default:
                    EmptyView()
                }
                Spacer()
                HStack (spacing: 90) {
                    Button(action: {
                        router.tabBarIndex = 0
                    }) { Image("OnePage") }
                    
                    Button(action: {
                        router.tabBarIndex = 1
                    }) { Image("SecondPage") }
                    
                    Button(action: {
                        router.tabBarIndex = 2
                    }) { Image("ThirdPage") }
                }
                .frame(width: ERIGOSCREEN.WIDTH - 40, height: 58)
                .background(Color(hes: "#111111"))
                .clipShape(RoundedRectangle(cornerRadius: 25))
                .padding(.bottom, 40)
            }
            .ignoresSafeArea()
            .background(.clear)
            .onAppear {
                IQKeyboardManager.shared().isEnabled = true
                IQKeyboardManager.shared().shouldResignOnTouchOutside = true
            }
            
            .navigationDestination(for: ERIGOROUTE.self) { route in
                switch route {
                case .LAND: ErigoLand().environmentObject(router).hideNavBack()
                case .ENROLL: ErigoEnroll().environmentObject(router).hideNavBack()
                case .SETTING: ErigoSet().environmentObject(router).hideNavBack()
                case .SINGLECHAT: ErigoChatSingle().environmentObject(router).hideNavBack()
                case .DISGROUP: ErigoChatGroup().environmentObject(router).hideNavBack()
                case .USERCENTER: ErigoPersonal().environmentObject(router).hideNavBack()
                case .VSHOWCASE: ErigoPersonal().environmentObject(router).hideNavBack()
                case .POSTDETAILS(let titleModel): ErigoDetils(titleModel: titleModel).environmentObject(router).hideNavBack()
                case .MESLIST: ErigoChatInbox().environmentObject(router).hideNavBack()
                case .USERINFO(let userModel): ErigoUserInfo(userModel: userModel).environmentObject(router).hideNavBack()
                }
            }
        }
    }
}
