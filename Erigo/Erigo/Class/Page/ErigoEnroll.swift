//
//  ErigoRegister.swift
//  Erigo
//
//  Created by 北川 on 2025/4/18.
//

import SwiftUI

// MARK: 注册
struct ErigoEnroll: View {
    
    @State var loginName: String = ""
    
    @State var loginPwd: String = ""
    
    @FocusState var isName: Bool
    
    @FocusState var isPwd: Bool
    
    @FocusState var isConfirm: Bool
    
    @State var loginPwdConfirm: String = ""
    
    @State var isCorrect: Bool = false
    
    @EnvironmentObject var router: ErigoRoute
    
    var body: some View {
        VStack {
            Image("login_bg") // 背景
                .resizable()
                .frame(height: ERIGOSCREEN.HEIGHT * 0.35)
            
            VStack { // 登陆表单
                VStack {
                    HStack {
                        Text("User Name")
                        Spacer()
                    }
                    TextField("Input user name", text: $loginName) // 用户名
                        .font(.custom("PingFang SC", size: 12))
                        .foregroundStyle(Color(hes: "#111111", alpha: 0.2))
                        .focused($isName)
                    Rectangle()
                        .fill(Color(hes: "#111111", alpha: 0.2))
                        .frame(height: 1)
                }.padding(.top, 20)
                    .padding(.horizontal, 40)
                
                VStack {
                    HStack {
                        Text("Passowrd")
                        Spacer()
                    }
                    TextField("Input password", text: $loginPwd) // 密码
                        .font(.custom("PingFang SC", size: 12))
                        .foregroundStyle(Color(hes: "#111111", alpha: 0.2))
                        .focused($isPwd)
                    Rectangle()
                        .fill(Color(hes: "#111111", alpha: 0.2))
                        .frame(height: 1)
                }.padding(.top, 20)
                    .padding(.horizontal, 40)
                
                VStack {
                    HStack {
                        Text("Confirm password")
                        Spacer()
                    }
                    TextField("Enter your password again", text: $loginPwdConfirm) // 确认密码
                        .font(.custom("PingFang SC", size: 12))
                        .foregroundStyle(Color(hes: "#111111", alpha: 0.2))
                        .focused($isConfirm)
                    Rectangle()
                        .fill(Color(hes: "#111111", alpha: 0.2))
                        .frame(height: 1)
                }.padding(.top, 20)
                    .padding(.horizontal, 40)
                
                HStack {
                    Text("Don't have an account yet? Go")
                        .font(.custom("PingFang SC", size: 12))
                        .foregroundStyle(Color(hes: "#111111"))
                    Button(action: { router.previous() }) { // 注册
                        Text("log in")
                            .font(.custom("PingFang SC", size: 14))
                            .foregroundStyle(Color(hes: "#FC6765"))
                    }
                    Spacer()
                }
                .padding(.horizontal, 40)
                .padding(.top, 15)
                
                Button(action: {
                    
                    
                    
                }) { // 账号验证登陆
                    Image("btnLand")
                }.padding(.top, 60)
                
                Spacer()
                
                LinkTextView(firstText: "Terms of Service",
                             secondTxt: "Pracy Policy",
                             tarText: "By continuing, you agree to our Terms of Service and Pracy Policy",
                             customFont: .custom("", size: 12),
                             tartColor: Color(hes: "#111111", alpha: 0.2),
                             higlitColor: Color(hes: "#111111", alpha: 0.6),
                             firstLink: URL(string: ERIGOLINK.TER)!,
                             secondLink: URL(string: ERIGOLINK.POL)!) // 链接Text
                .padding(.bottom, 40)
            }
            .frame(width: ERIGOSCREEN.WIDTH,
                height: ERIGOSCREEN.HEIGHT * 0.65)
            .background(Color(hes: "#FDF1E5"))
            .offset(CGSize(width: 0, height: -10))
            Spacer()
        }.ignoresSafeArea()
    }
}

#Preview {
    ErigoEnroll()
}
