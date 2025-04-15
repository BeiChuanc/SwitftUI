//
//  PeppyRegisterPage.swift
//  Peppy
//
//  Created by 北川 on 2025/4/12.
//

import SwiftUI

struct PeppyRegisterPage: View {
    var body: some View {
        PeppyRegisterContentView()
    }
}

struct PeppyRegisterContentView: View {
    
    @State var inputName: String = ""
    
    @State var inputPwd: String = ""
    
    @State var inputPwdC: String = ""
    
    @FocusState var isNameFouse: Bool
    
    @FocusState var isPwdFouse: Bool
    
    @FocusState var isPwd1Fouse: Bool
    
    @State var showTerms: Bool = false
    
    @State var showPrivacy: Bool = false
    
    @EnvironmentObject var loginM: PeppyLoginManager
    
    @EnvironmentObject var peppyRouter: PeppyRouteManager
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                Color(hex: "#F7BD0F")
                    .ignoresSafeArea()
                VStack {
                    Spacer().frame(height: 50)
                    HStack {
                        Button(action: {
                            peppyRouter.pop()
                        }) {
                            Image("btnBac").frame(width: 24, height: 24)
                        }
                        Spacer()
                    }.frame(height: 25)
                    ZStack(alignment: .topLeading) {
                        Image("selectHead")
                            .resizable()
                    }.frame(width: 210, height: 210) // 选择头像
                        .gesture (
                            TapGesture()
                                .onEnded {
                                    peppyRouter.navigate(to: .UPLOADHEAD)
                                }
                        )
                    
                    Image("loginName").resizable()
                        .frame(width: peppyW - 80, height: 48)
                    TextField("Enter Your Name", text: $inputName) // 用户名
                        .font(.custom("PingFang SC", size: 12))
                        .foregroundStyle(
                            Color(hex: "#111111", alpha: 0.2))
                        .multilineTextAlignment(.center)
                        .padding(.top, 15)
                        .focused($isNameFouse)
                    Rectangle()
                               .fill(Color.black)
                               .frame(height: 2)
                               .padding(.horizontal, 40) // 下划线
                    
                    Image("loginPwd").resizable()
                        .frame(width: peppyW - 80, height: 48)
                        .padding(.top, 20)
                    TextField("Enter Your Password", text: $inputPwd) // 密码
                        .font(.custom("PingFang SC", size: 12))
                        .foregroundStyle(Color(hex: "#111111", alpha: 0.2))
                        .multilineTextAlignment(.center)
                        .padding(.top, 15)
                        .focused($isPwdFouse)
                    Rectangle()
                               .fill(Color.black)
                               .frame(height: 2)
                               .padding(.horizontal, 40) // 下划线
                    
                    Image("registerConfrm").resizable()
                        .frame(width: peppyW - 80, height: 48)
                        .padding(.top, 20)
                    TextField("Enter password again to confirm", text: $inputPwdC) // 确认密码
                        .font(.custom("PingFang SC", size: 12))
                        .foregroundStyle(Color(hex: "#111111", alpha: 0.2))
                        .multilineTextAlignment(.center)
                        .padding(.top, 15)
                        .focused($isPwd1Fouse)
                    Rectangle()
                               .fill(Color.black)
                               .frame(height: 2)
                               .padding(.horizontal, 40) // 下划线
                    
                    Button(action: { // 注册
                        guard !inputPwd.isEmpty else {
                            isPwdFouse = true
                            return
                        }
                        
                        guard !inputPwdC.isEmpty else {
                            isPwd1Fouse = true
                            return
                        }
        
                        guard inputPwd == inputPwdC else {
                            PeppyLoadManager.peppyProgressShow(type: .failed, text: "Passwords do not match!")
                            return
                        }
                        
                        PeppyComManager.peppyCreatUser(peNam: inputName,
                                                       peEma: inputName,
                                                       pePwd: inputPwd,
                                                       isApple: false)
                        loginM.isLogin = true // 更新登录
                        PeppyLoadManager.peppyLoading {
                            peppyRouter.popRoot()
                        }
                        
                    }) {
                        Image("loginregister").resizable()
                            .frame(width: peppyW - 80, height: 48)
                    }.padding(.top, 40)
                    
                    Spacer()
                }.padding(.horizontal, 20)
                Spacer()
                ZStack { // 底部
                    Image("row_bg").resizable()
                    HStack(alignment: .bottom, spacing: 5) {
                        Text("By continuing, you agree to our")
                            .font(.custom("PingFang SC", size: 12))
                            .foregroundStyle(Color(hex: "#FFFFFF", alpha: 0.4))
                        Text("Terms of Service")
                            .font(.custom("PingFang SC", size: 12))
                            .foregroundStyle(.white)
                            .underline()
                            .onTapGesture {
                                showPrivacy = true
                            }
                            .sheet(isPresented: $showTerms) {
                                PeppyWebViewPage(url: URL(string: PEPPYPROTOCOL.PEPPYTERMS)!)
                                    .navigationBarTitleDisplayMode(.automatic)
                            }
                        Text("and")
                            .font(.custom("PingFang SC", size: 12))
                            .foregroundStyle(Color(hex: "#FFFFFF", alpha: 0.4))
                        Text("Privacy Policy")
                            .font(.custom("PingFang SC", size: 12))
                            .foregroundStyle(.white)
                            .underline()
                            .onTapGesture {
                                showPrivacy = true
                            }
                            .sheet(isPresented: $showPrivacy) {
                                PeppyWebViewPage(url: URL(string: PEPPYPROTOCOL.PEPPYPRIVACY)!)
                                    .navigationBarTitleDisplayMode(.automatic)
                            }
                    }
                }.frame(height: 86)
            }
            .ignoresSafeArea()
        }
    }
}

