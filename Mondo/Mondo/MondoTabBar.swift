//
//  MondoTabBar.swift
//  Mondo
//
//  Created by 北川 on 2025/4/27.
//

import SwiftUI
import IQKeyboardManager

// MARK: 底部导航
struct MondoTabBar: View {
    
    let tabBarItem = [(normal: "welcome_normal",  select: "welcome_select"),
                      (normal: "discover_normal", select: "discover_select"),
                      (normal: "mes_normal",      select: "mes_select"),
                      (normal: "personal_normal", select: "personal_select")]
    
    @State var path = NavigationPath()
    
    @ObservedObject var pageControl = MondoPageControl()
    
    var body: some View {
        NavigationStack(path: $pageControl.path) {
            ZStack(alignment: .bottom) {
                switch pageControl.bottomIndex {
                case 0:
                    MondoWelcome().environmentObject(pageControl)
                case 1:
                    MondoDiscover().environmentObject(pageControl)
                case 2:
                    MondoMessage().environmentObject(pageControl)
                case 3:
                    MondoMe().environmentObject(pageControl)
                default:
                    EmptyView()
                }
                Spacer()
                HStack (spacing: 50) {
                    ForEach(0..<tabBarItem.count, id: \.self) { index in
                        MondoTabBarItem(normalImage: tabBarItem[index].normal,
                                        selectImage: tabBarItem[index].select,
                                        isSelected: pageControl.bottomIndex == index) {
                            pageControl.bottomIndex = index
                        }
                                        .background(content: {
                            Image("tabBarItem_bg").offset(CGSize(width: 0, height: -5))
                                .opacity(pageControl.bottomIndex == index ? 1 : 0)
                        })
                    }
                }
                .frame(width: MONDOSCREEN.WIDTH - 32, height: 60)
                .background(Color(hex: "#111111"))
                .clipShape(RoundedRectangle(cornerRadius: 30))
                .padding(.bottom, 40)
            }
            .ignoresSafeArea()
            .background(.clear)
            .onAppear {
                IQKeyboardManager.shared().isEnabled = true
                IQKeyboardManager.shared().shouldResignOnTouchOutside = true
                MondoUserVM.shared.MondoGetUserList()
                MondoUserVM.shared.MondoGetTileList()
                MondoUserVM.shared.MondoGetHotList()
            }
            .navigationDestination(for: MONDOPAGE.self) { page in
                switch page {
                case .LOGIN: MondoLogin().environmentObject(pageControl).mondoHidBack()
                case .REGISTER: MondoRegister().environmentObject(pageControl).mondoHidBack()
                case .SET: MondoSet().environmentObject(pageControl).mondoHidBack()
                case .RELEASE:  MondoRelease().environmentObject(pageControl).mondoHidBack()
                case .SAFEGUIDE: MondoOfficeGuide().environmentObject(pageControl).mondoHidBack()
                case .SIDEBYSID(let chatModel): MondoSignle(chatUser: chatModel).environmentObject(pageControl).mondoHidBack()
                case .SIDEGROUP(let gId): MondoGroup(groupId: gId).environmentObject(pageControl).mondoHidBack()
                case .SAFEVIDEO: Text("")
                case .OTHERONE: MondoUser().environmentObject(pageControl).mondoHidBack()
                case .HOTNOTES: MondoHotNote().environmentObject(pageControl).mondoHidBack()
                case .GUIDE(let GuideM): MondoGuide(guideModel: GuideM).environmentObject(pageControl).mondoHidBack()
                case .SHOWDETAIL(let titleModel): MondoDetials(titleModel: titleModel).environmentObject(pageControl).mondoHidBack()
                case .SHOWDETAILME(let titleMeModel): MondoDetilsMe(monMeTitle: titleMeModel).environmentObject(pageControl).mondoHidBack()
                }
            }
        }
    }
}
