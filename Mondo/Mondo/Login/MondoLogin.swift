//
//  MondoLogin.swift
//  Mondo
//
//  Created by 北川 on 2025/4/28.
//

import SwiftUI
import AuthenticationServices

// 登陆
struct MondoLogin: View {
    
    @State var mondoAppleEmail: String?
    
    @State var inputAcc: String = ""
    
    @FocusState var isAcc: Bool
    
    @State var inputPwd: String = ""
    
    @FocusState var isPwd: Bool
    
    @State var showApple: Bool = false
    
    @State var loginEnable: Bool = false
    
    @EnvironmentObject var pageControl: MondoPageControl
    
    var body: some View {
        ZStack {
            Image("login_bg").resizable()
            VStack {
                HStack {
                    Spacer()
                    Button(action: {  pageControl.backToLevel() }) { Image("btnClose") }
                }.padding(.top, 80)
                Spacer()
                VStack {
                    VStack(spacing: 10) { // 表单
                        MondoTextFielfItem(textInput: $inputAcc,
                                           placeholder: "Input username",
                                           interval: 15,
                                           backgroundColor: UIColor(hex: "#825EEE"),
                                           textColor: UIColor.white,
                                           placeholderColor: UIColor(hex: "#FFFFFF", alpha: 0.4),
                                           font: UIFont(name: "PingFangSC-Medium", size: 14)!,
                                           radius: 15)
                        .frame(width: MONDOSCREEN.WIDTH - 32, height: 50)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .focused($isAcc)
                        MondoTextFielfItem(textInput: $inputPwd,
                                           placeholder: "Input password",
                                           interval: 15,
                                           backgroundColor: UIColor(hex: "#825EEE"),
                                           textColor: UIColor.white,
                                           placeholderColor: UIColor(hex: "#FFFFFF", alpha: 0.4),
                                           font: UIFont(name: "PingFangSC-Medium", size: 14)!,
                                           radius: 15)
                        .frame(width: MONDOSCREEN.WIDTH - 32, height: 50)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .focused($isPwd)
                    }
                    HStack {
                        Text("Don't have an account yet? Go")
                            .font(.custom("PingFangSC-Regular", size: 12))
                            .foregroundStyle(Color(hex: "#111111"))
                        Button(action: { // 注册
                            pageControl.route(to: .REGISTER)
                        }) {
                            Text("Register")
                                .font(.custom("PingFangSC-Regular", size: 14))
                                .foregroundStyle(Color(hex: "#FC6765"))
                        }
                    }.padding(.top, 10)
                }
                
                VStack(spacing: 20) {
                    Button(action: { // 登陆
                        guard !inputAcc.isEmpty else { isAcc = true
                            return
                        }
                        
                        guard !inputPwd.isEmpty else { isPwd = true
                            return
                        }
                        
                        loginEnable = true
                        
                        MondoUserVM.shared.MondoLoginAcc(email: inputAcc, pwd: inputPwd) { statu in
                            switch statu {
                            case .LOAD: // 登入 >> 首页
                                MondoBaseVM.MondoLoading {
                                    pageControl.backToOriginal()
                                }
                            case .FAIL: // 失败 >> 提示
                                break
                            default:
                                break
                            }
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            loginEnable = false
                        }
                        
                    }) { Image("btnLogin").resizable()
                            .frame(width: MONDOSCREEN.WIDTH - 32, height: 50)}
                    
                    Button(action: { // 苹果登陆
                        showApple = true
                    }) { Image("btnApple").resizable()
                        .frame(width: MONDOSCREEN.WIDTH - 32, height: 50) }
                }.padding(.top, 10)
                
                CombinedLinkTextItem(placeholderOne: "Terms of Service",
                                     placeholderTwo: "Privacy Policy",
                                     tarText: "By Continuing you agree with Terms of Service & Privacy Policy",
                                     customFont: .custom("", size: 12),
                                     tartColor: Color(hex: "#999999"),
                                     higlitColor: Color(hex: "#666666"),
                                     firstLink: URL(string: MONDOPROTOC.TERMS)!,
                                     secondLink: URL(string: MONDOPROTOC.PRIVACY)!)
                .padding(.bottom, 60)
                .padding(.top, 36)
            }.padding(.horizontal, 16)
                .frame(width: MONDOSCREEN.WIDTH, height:  MONDOSCREEN.HEIGHT)
            if showApple { // 苹果登陆
                MondoAppleLoginItem { // 进入App
                    MondoUserVM.shared.loginIn = true
                    MondoBaseVM.MondoLoading {
                        pageControl.backToOriginal()
                    }
                }
            }
        }.ignoresSafeArea()
    }
}

// 苹果登录代理
struct MondoAppleLoginItem: UIViewControllerRepresentable {
    
    var appleSucceed: () -> Void

    func makeUIViewController(context: Context) -> MondoAppleLoginVC {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]

        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = context.coordinator
        controller.presentationContextProvider = context.coordinator

        return MondoAppleLoginVC(authorizationController: controller)
    }

    func updateUIViewController(_ uiViewController: MondoAppleLoginVC, context: Context) {}

    func makeCoordinator() -> AppleLogin {
        AppleLogin(appleSucceed: appleSucceed)
    }

    class AppleLogin: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
        
        var appleSucceed: () -> Void

        init(appleSucceed: @escaping () -> Void) {
            self.appleSucceed = appleSucceed
        }

        func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
            // 用户数据
            MondoUserVM.shared.MondoAppleLogin(email: "Mondo", complete: appleSucceed)
        }

        func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {}

        func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
            return UIWindow()
        }
    }
}

class MondoAppleLoginVC: UIViewController {
    
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
