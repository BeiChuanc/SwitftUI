import UIKit
import AuthenticationServices
import SnapKit

class BleoLandViewC: BleoLandBaseViewC {

    @IBOutlet weak var backLog: UIButton!
    
    @IBOutlet weak var emailInput: UITextField!
    
    @IBOutlet weak var pwdInput: UITextField!
    
    @IBOutlet weak var loginInBt: UIButton!
    
    @IBOutlet weak var registerBt: UIButton!
    
    @IBOutlet weak var appleInBt: UIButton!
    
    let hiddenView: UIView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BleoSetLogInView()
    }
    
    func BleoSetLogInView() {
        
        view.addSubview(hiddenView)
        hiddenView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        hiddenView.isHidden = true
        
        emailInput.layer.cornerRadius = 16
        emailInput.layer.masksToBounds = true
        emailInput.placeholder = "Account name"
        emailInput.backgroundColor = .white
        emailInput.leftPadding(18)
        emailInput.textColor = ComposeColor.logInput.color
        emailInput.placeHolderColor(ComposeColor.logInput.color)
        emailInput.layer.borderColor = UIColor.black.cgColor
        emailInput.layer.borderWidth = 2
        
        pwdInput.layer.cornerRadius = 16
        pwdInput.layer.masksToBounds = true
        pwdInput.placeholder = "Password"
        pwdInput.backgroundColor = .white
        pwdInput.leftPadding(18)
        pwdInput.textColor = ComposeColor.logInput.color
        pwdInput.placeHolderColor(ComposeColor.logInput.color)
        pwdInput.layer.borderColor = UIColor.black.cgColor
        pwdInput.layer.borderWidth = 2
        
        loginInBt.layer.cornerRadius = 16
        loginInBt.layer.masksToBounds = true
        loginInBt.layer.borderWidth = 2
        loginInBt.backgroundColor = .white
        loginInBt.layer.borderColor = UIColor.black.cgColor
        loginInBt.backgroundColor = ComposeColor.btOne.color
        loginInBt.setTitle("Login", for: .normal)
        loginInBt.setTitleColor(ComposeColor.textOne.color, for: .normal)
        loginInBt.addTarget(self, action: #selector(loginInCheck), for: .touchUpInside)
        
        registerBt.layer.cornerRadius = 16
        registerBt.layer.masksToBounds = true
        registerBt.layer.borderWidth = 2
        registerBt.layer.borderColor = UIColor.black.cgColor
        registerBt.backgroundColor = ComposeColor.btOne.color
        registerBt.setTitle("Register", for: .normal)
        registerBt.setTitleColor(ComposeColor.textThree.color, for: .normal)
        registerBt.addTarget(self, action: #selector(registerView), for: .touchUpInside)
        backLog.addTarget(self, action: #selector(backlog), for: .touchUpInside)
    }
    
    func BleoLogIn(_ log: BleoLogM, completion: @escaping () -> Void) {
        if BleoPrefence.BleoMatchUser(log) {
            BleoPrefence.BleoSaveCurrentUser(log.user)
            BleoTransData.shared.isLoginIn = true
            completion()
            return
        }
        if log.user == "1" { // 8154773 / 123456
            if log.password == "1" {
                BleoPrefence.BleoSaveUser(log)
                BleoPrefence.BleoSaveCurrentUser(log.user)
                BleoTransData.shared.isLoginIn = true
                let logUser = BleoMyDetailM(uId: Int.random(in: 2000...3000), name: "Bleoer")
                let userData = BleoTransData.shared.encode(object: logUser)
                BleoPrefence.BleoSaveUserData(log, userData: userData!)
                completion()
            } else {
                BleoToast.BleoShow(type: .failed, text: "User password error.")
            }
        }
    }
    
    @objc func backlog() {
        BleoPageRoute.backToLevel()
    }
    
    @objc func loginInCheck() {
        guard let email = emailInput.text, !email.isEmpty else {
            emailInput.becomeFirstResponder()
            return }
        
        guard let pwd = pwdInput.text, !pwd.isEmpty else {
            pwdInput.becomeFirstResponder()
            return }
        
        let logModel = BleoLogM(user: email, password: pwd)
        hiddenView.isHidden = false
        BleoToast.Bleoload()
        DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 0...3)) { [self] in
            BleoToast.Bleodismiss()
            hiddenView.isHidden = true
            BleoLogIn(logModel) {
                NotificationCenter.default.post(name: Notification.Name("updateUser"), object: nil)
                BleoPageRoute.BleoRootVC(In: self.view.window!)
            }
        }
    }
    
    @objc func registerView() {
        BleoPageRoute.Bleoregister()
    }
    
    @objc func appleInCheck() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationCotroller = ASAuthorizationController(authorizationRequests: [request])
        authorizationCotroller.delegate = self
        authorizationCotroller.presentationContextProvider = self
        authorizationCotroller.performRequests()
    }
}

extension BleoLandViewC: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
            
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            var acc = ""
            if let email = appleIDCredential.email {
                acc = email
            } else {
                acc = "appleId"
            }
            
            let appleUser = BleoMyDetailM(uId: 999, name: "Bleoer")
            
            break
            
        case _ as ASPasswordCredential: break
        
        default: break
            
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: any Error) {
        if let e = error as? ASAuthorizationError {
            switch e.code {
            case .unknown:
                print("Authorization unknown error")
            case .canceled:
                print("Authorization canceled")
            case .invalidResponse:
                print("Authorization invalid response")
            case .notHandled:
                print("Authorization not handled")
            case .failed:
                print("Authorization failed")
            case .notInteractive:
                print("Authorization non-interactive")
            case .matchedExcludedCredential:
                print("The credential matches an excluded credential")
            case .credentialImport:
                print("An error occurred during credential import")
            case .credentialExport:
                print("An error occurred during credential export")
            @unknown default:
                print("Authorization error for other reasons")
            }
        }
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
