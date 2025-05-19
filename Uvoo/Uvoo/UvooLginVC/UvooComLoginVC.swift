import UIKit
import SnapKit
import AuthenticationServices

class UvooComLoginVC: UvooTextVC {
    
    @IBOutlet weak var login_back: UIButton!
    
    @IBOutlet weak var view_email: UIView!
    
    @IBOutlet weak var input_email: UITextField!
    
    @IBOutlet weak var view_password: UIView!
    
    @IBOutlet weak var input_password: UITextField!
    
    @IBOutlet weak var signup: UIButton!
    
    @IBOutlet weak var login_app: UIButton!
    
    @IBOutlet weak var apple_app: UIButton!
    
    let coverView: UIView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UvooSetLoginView()
    }
    
    func UvooSetLoginView() {
        view_email.layer.cornerRadius = 10
        view_email.layer.masksToBounds = true
        input_email.leftPadding(10)
        input_email.placeholder = "Input username"
        input_email.placeHolderColor(UIColor(hex: "#FFFFFF", alpha: 0.5))
        
        view_password.layer.cornerRadius = 10
        view_password.layer.masksToBounds = true
        input_password.leftPadding(10)
        input_password.placeholder = "Input password"
        input_password.placeHolderColor(UIColor(hex: "#FFFFFF", alpha: 0.5))
        
        login_app.layer.cornerRadius = 10
        login_app.layer.masksToBounds = true
        apple_app.layer.cornerRadius = 10
        apple_app.layer.masksToBounds = true
        apple_app.layer.borderColor = UIColor(hex: "#FFFFFF", alpha: 0.5).cgColor
        apple_app.layer.borderWidth = 1
        
        login_app.addTarget(self, action: #selector(UvooLoginIn), for: .touchUpInside)
        apple_app.addTarget(self, action: #selector(UvooLoginWithApple), for: .touchUpInside)
        login_back.addTarget(self, action: #selector(previous), for: .touchUpInside)
        signup.addTarget(self, action: #selector(UvooRegisterView), for: .touchUpInside)
        
        view.addSubview(coverView)
        coverView.isHidden = true
        coverView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    @objc func UvooLoginWithApple() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationCotroller = ASAuthorizationController(authorizationRequests: [request])
        authorizationCotroller.delegate = self
        authorizationCotroller.presentationContextProvider = self
        authorizationCotroller.performRequests()
    }
    
    @objc func UvooLoginIn() {
        guard let email = input_email.text, !email.isEmpty else {
            input_email.becomeFirstResponder()
            return }
        
        guard let password = input_password.text, !password.isEmpty else {
            input_password.becomeFirstResponder()
            return }
        coverView.isHidden = false
        let logModel = UvooLoginM(email: email, pwd: password)
        UvooLoadVM.Uvooload()
        DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 0...3)) { [self] in
            UvooLoadVM.Uvoodismiss()
            coverView.isHidden = true
            UvooLoginVM.shared.UvooLoginIn(type: .LOGIN, model: logModel) {
                UvooRouteUtils.UvooLearn(window: self.view.window!)
            }
        }
    }
    
    @objc func UvooRegisterView() {
        UvooRouteUtils.UvooRegister()
    }
    
}

extension UvooComLoginVC: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
            
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            var userAcc = ""
            if let email = appleIDCredential.email {
                userAcc = email
            } else {
                userAcc = "appleId"
            }
            
            let appleModel = UvooLoginM(email: userAcc, pwd: "123456")
            UvooLoginVM.shared.UvooLoginIn(type: .APPLE, model: appleModel) {
                UvooRouteUtils.UvooLearn(window: self.view.window!)
            }
            break
            
        case _ as ASPasswordCredential: break
        
        default: break
            
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: any Error) {
        if let e = error as? ASAuthorizationError {
            switch e.code {
            case .unknown:
                print("授权未知错误")
            case .canceled:
                print("授权取消")
            case .invalidResponse:
                print("授权无效请求")
            case .notHandled:
                print("授权未能处理")
            case .failed:
                print("授权失败")
            case .notInteractive:
                print("授权非交互式")
            case .matchedExcludedCredential:
                print("该凭证属于被排除的范围")
            case .credentialImport:
                print("导入凭证的过程中出现了问题")
            case .credentialExport:
                print("凭证导出时发生错误")
            @unknown default:
                print("授权其他原因")
            }
        }
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
