//
//  PeppySetPage.swift
//  Peppy
//
//  Created by 北川 on 2025/4/11.
//

import SwiftUI

// 个人中心
struct PeppySetPage: View {
    var body: some View {
        PeppySetContentView()
    }
}

struct PeppySetContentView: View {
    
    @State var showPrivacy: Bool = false
    
    @State var showTerms: Bool = false
    
    @State var showAlter: Bool = false
    
    @State var unlockedCount: Int = 0
    
    var userCurrent = PeppyUserManager.PEPPYGetCurrentDancer()
    
    @EnvironmentObject var loginM: PeppyLoginManager
    
    @EnvironmentObject var peppyRouter: PeppyRouteManager
    
    var body: some View {
        ZStack {
            Image("centerNg")
                .resizable()
                .ignoresSafeArea()
            VStack {
                PeppyUserHeadContentView(head: loginM.isLogin ? userCurrent.head ?? "" : "head_1",
                                         headBgColor: loginM.isLogin ? userCurrent.headColor ?? "" : "#FFFFFF",
                                         headFrame: 72.0)
                .padding(.trailing, 10)
                
                Text(loginM.isLogin ? userCurrent.kickName ?? "" : "Guest")
                    .font(.custom("Marker Felt", size: 20))
                    .foregroundStyle(.white)
                
                VStack {
                    Text("YOU HAVE UNLOCKED \(unlockedCount) ELECTRONIC PETS")
                        .frame(width: 200)
                        .font(.custom("Marker Felt", size: 20))
                        .foregroundStyle(.white)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                }.padding(.top, 30)
                
                if loginM.isLogin {
                    withAnimation(.easeInOut(duration: 10)) {
                        HStack { // 解锁聊天个数
                            
                        }.frame(height: 90)
                    }
                }
                
                VStack(spacing: 18) {
                    Button(action: { // 隐私政策
                        showPrivacy = true
                    }) {
                        Image("btnPrivacy")
                    }.sheet(isPresented: $showPrivacy) {
                        PeppyWebViewPage(url: URL(string: PEPPYPROTOCOL.PEPPYPRIVACY)!)
                            .navigationBarTitleDisplayMode(.automatic)
                    }
                    
                    Button(action: { // 技术支持
                        showTerms = true
                    }) {
                        Image("btnTerms")
                    }.sheet(isPresented: $showTerms) {
                        PeppyWebViewPage(url: URL(string: PEPPYPROTOCOL.PEPPYTERMS)!)
                            .navigationBarTitleDisplayMode(.automatic)
                    }
                    
                    Button(action: { // 登出
                        if loginM.isLogin {
                            showAlter = true
                            return
                        }
                        peppyRouter.navigate(to: .LOGIN)
                    }) {
                        Image("btnLogOut")
                    }.alert(isPresented: $showAlter) {
                        Alert(
                            title: Text("Promot"),
                            message: Text("Are you sure you want to log out?"),
                            primaryButton: .default(Text("Confirm")) {
                                loginM.isLogin = false
                                
                            },
                            secondaryButton: .cancel(Text("Cancel"))
                        )
                    }
                    
                    Button(action: { // 删除账号
                        if loginM.isLogin {
                            showAlter = true
                            return
                        }
                        peppyRouter.navigate(to: .LOGIN)
                    }) {
                        Image("btnDeleteAc")
                    }.alert(isPresented: $showAlter) {
                        Alert(
                            title: Text("Promot"),
                            message: Text("Are you sure you want to delete this account?"),
                            primaryButton: .default(Text("Confirm")) {
                                loginM.isLogin = false
                            },
                            secondaryButton: .cancel(Text("Cancel"))
                        )
                    }
                }.padding(.top, 10)
                
                Spacer()
            }.frame(width: peppyW)
                .padding(.top, 20)
        }
    }
}
