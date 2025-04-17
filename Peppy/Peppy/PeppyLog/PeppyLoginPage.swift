import SwiftUI
import UIKit
import AuthenticationServices

// MARK: 登录页面
struct PeppyLoginPage: View {
    var body: some View {
        PeppyLoginContentView()
    }
}

struct PeppyLoginContentView: View {
    
    @State var email: String?
    
    @State var inputName: String = ""
    
    @State var inputPwd: String = ""
    
    @FocusState var isNameFouse: Bool
    
    @FocusState var isPwdFouse: Bool
    
    @State var isAppleLogin: Bool = false
    
    @State var showTerms: Bool = false
    
    @State var showPrivacy: Bool = false
    
    @EnvironmentObject var peppyRouter: PeppyRouteManager
    
    @EnvironmentObject var loginM: PeppyLoginManager
    
    var body: some View {
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
                
                HStack {
                    Text("Don't have an account yet?")
                        .font(.custom("PingFang SC", size: 14))
                        .foregroundStyle(.white)
                    
                    Button(action: { // 注册
                        peppyRouter.navigate(to: .REGISTER)
                    }) {
                        Text("Register")
                            .font(.custom("PingFang SC", size: 12))
                            .foregroundStyle(Color(hex: "#F54337"))
                    }
                }
                
                Button(action: { // 登录 Sparkler/123456 || 111111/123456
                    
                    guard !inputName.isEmpty else {
                        isNameFouse = true
                        return
                    }
                    
                    guard !inputPwd.isEmpty else {
                        isPwdFouse = true
                        return
                    }
                    
                    if PeppyUserManager.PEPPYMatchLogin(userAcc: inputName, userPwd: inputPwd) {
                        loginM.isLogin = true // 更新登录
                        PeppyLoadManager.peppyLoading {
                            peppyRouter.popRoot()
                        }
                    } else {
                        if inputName == "Sparkler" {
                            if inputPwd == "123456" {
                                PeppyComManager.peppyCreatLoginData(peNam: inputName,
                                                               peEma: inputName,
                                                               pePwd: inputPwd,
                                                               isApple: false)
                                loginM.isLogin = true // 更新登录
                                PeppyLoadManager.peppyLoading {
                                    peppyRouter.popRoot()
                                }
                            } else {
                                PeppyLoadManager.peppyProgressShow(type: .failed, text: "Wrong password!")
                            }
                        }
                    }
                }) {
                    Image("loginConfirm").resizable()
                        .frame(width: peppyW - 80, height: 48)
                }.padding(.top, 40)
                
                Button(action: {
                    isAppleLogin = true
                }) {
                    Image("loginApple").resizable()
                        .frame(width: peppyW - 80, height: 50)
                }.padding(.top, 20)
                
                if isAppleLogin {
                    SignInWithAppleView(appleSucceed: {
                        loginM.isLogin = true // 更新登录
                        PeppyLoadManager.peppyLoading {
                            peppyRouter.popRoot()
                        }
                    }, email: $email)
                }
                
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
        }.ignoresSafeArea()
    }
}

// 苹果登录代理
struct SignInWithAppleView: UIViewControllerRepresentable {
    
    var appleSucceed: () -> Void
    
    @Binding var email: String?
    
    @EnvironmentObject var peppyRouter: PeppyRouteManager

    func makeUIViewController(context: Context) -> ASAuthorizationControllerViewController {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]

        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = context.coordinator
        controller.presentationContextProvider = context.coordinator

        return ASAuthorizationControllerViewController(authorizationController: controller)
    }

    func updateUIViewController(_ uiViewController: ASAuthorizationControllerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(email: $email, appleSucceed: appleSucceed)
    }

    class Coordinator: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
        
        var appleSucceed: () -> Void
        
        @Binding var email: String?

        init(email: Binding<String?>, appleSucceed: @escaping () -> Void) {
            self._email = email
            self.appleSucceed = appleSucceed
        }

        func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                
                var appleEmail = "Peppy"
                
                if let email = appleIDCredential.email {
                    appleEmail = email
                }
                
                // 苹果登陆
                PeppyLoginManager.shared.isLogin = true
                PeppyComManager.peppyCreatLoginData(peNam: "Peppy",
                                               peEma: appleEmail,
                                               pePwd: "123456",
                                               isApple: true)
                appleSucceed()
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

class ASAuthorizationControllerViewController: UIViewController {
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
