//
//  ErigoLogin.swift
//  Erigo
//
//  Created by 北川 on 2025/4/18.
//

import SwiftUI
import AuthenticationServices

// MARK: 登陆
struct ErigoLand: View {
    
    @State var appleEmail: String?
    
    @State var loginName: String = ""
    
    @State var loginPwd: String = ""
    
    @FocusState var isName: Bool
    
    @FocusState var isPwd: Bool
    
    @State var isAppleLogin: Bool = false
    
    @State var loginIsEnable: Bool = false
    
    @EnvironmentObject var router: ErigoRoute
    
    var body: some View {
        VStack {
            ZStack(alignment: .topTrailing) {
                Image("login_bg") // 背景
                    .resizable()
                    .frame(height: ERIGOSCREEN.HEIGHT * 0.35)
                Button(action: { router.previous() }) {
                    Image("btnBack")
                        .resizable()
                        .frame(width: 30, height: 30)
                }.padding(EdgeInsets(top: 50, leading: 0, bottom: 0, trailing: 30))
            }
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
                
                HStack {
                    Text("Don't have an account yet? Go")
                        .font(.custom("PingFang SC", size: 12))
                        .foregroundStyle(Color(hes: "#111111"))
                    Button(action: { router.naviTo(to: .ENROLL)
                        print("当前的路径为:\(router.$path)")
                    }) { // 注册
                        Text("register")
                            .font(.custom("PingFang SC", size: 14))
                            .foregroundStyle(Color(hes: "#FC6765"))
                    }
                    Spacer()
                }
                .padding(.horizontal, 40)
                .padding(.top, 15)
                
                VStack(spacing: 20) {
                    Button(action: {  // 账号验证登陆
                        guard !loginName.isEmpty else { isName = true
                            return }
                        
                        guard !loginPwd.isEmpty else { isPwd = true
                            return }
                        
                        loginIsEnable = true
                        
                        ErigoLoginVM.shared.ErigoLoginAcc(email: loginName, pwd: loginPwd) { statu in
                            switch statu {
                            case .LOAD: // 登入 >> 首页
                                ErigoProgressVM.ErigoLoading {
                                    router.previousRoot()
                                }
                            case .FAIL: // 失败 >> 提示
                                break
                            default:
                                break
                            }
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            loginIsEnable = false
                        }
                    }) {
                        Image("btnLand")
                    }.disabled(loginIsEnable)
                    
                    Button(action: { isAppleLogin = true }) { // 苹果登陆
                        Image("btnApple")
                    }
                }.padding(.top, 60)
                
                LinkTextView(firstText: "Terms of Service",
                             secondTxt: "Pracy Policy",
                             tarText: "By continuing, you agree to our Terms of Service and Pracy Policy",
                             customFont: .custom("", size: 12),
                             tartColor: Color(hes: "#111111", alpha: 0.2),
                             higlitColor: Color(hes: "#111111", alpha: 0.6),
                             firstLink: URL(string: ERIGOLINK.TER)!,
                             secondLink: URL(string: ERIGOLINK.POL)!) // 链接Text
                .padding(.top, 80)
                
                if isAppleLogin { // 苹果登陆
                    SignInWithAppleView(appleSucceed: {
                        ErigoLoginVM.shared.landComplete = true
                        router.previousRoot()
                    }, email: $appleEmail)
                }
                
                Spacer()
            }
            .frame(width: ERIGOSCREEN.WIDTH,
                height: ERIGOSCREEN.HEIGHT * 0.65)
            .background(Color(hes: "#FDF1E5"))
            .offset(CGSize(width: 0, height: -10))
            Spacer()
        }.ignoresSafeArea()
    }
}


// 苹果登录代理
struct SignInWithAppleView: UIViewControllerRepresentable {
    
    var appleSucceed: () -> Void
    
    @Binding var email: String?

    func makeUIViewController(context: Context) -> ErigoAppleViewController {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]

        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = context.coordinator
        controller.presentationContextProvider = context.coordinator

        return ErigoAppleViewController(authorizationController: controller)
    }

    func updateUIViewController(_ uiViewController: ErigoAppleViewController, context: Context) {}

    func makeCoordinator() -> AppleLogin {
        AppleLogin(email: $email, appleSucceed: appleSucceed)
    }

    class AppleLogin: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
        
        var appleSucceed: () -> Void
        
        @Binding var email: String?

        init(email: Binding<String?>, appleSucceed: @escaping () -> Void) {
            self._email = email
            self.appleSucceed = appleSucceed
        }

        func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                
                var appleEmail = "Erigo"
                
                if let email = appleIDCredential.email {
                    appleEmail = email
                }
                
                ErigoLoginVM.shared.ErigoAppleLogin(email: appleEmail, complete: appleSucceed)
            }
        }

        func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
            print("苹果登录失败: \(error.localizedDescription)")
        }

        func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
            return UIWindow()
        }
    }
}

class ErigoAppleViewController: UIViewController {
    
    let authorizationController: ASAuthorizationController

    init(authorizationController: ASAuthorizationController) {
        self.authorizationController = authorizationController
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        authorizationController.performRequests()
    }
}
