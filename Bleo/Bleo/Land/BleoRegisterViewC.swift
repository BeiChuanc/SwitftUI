import UIKit
import SnapKit

class BleoRegisterViewC: BleoLandBaseViewC {

    @IBOutlet weak var registerBack: UIButton!
    
    @IBOutlet weak var emailInput: UITextField!
    
    @IBOutlet weak var pwdInput: UITextField!
    
    @IBOutlet weak var confirmInput: UITextField!
    
    @IBOutlet weak var registerInBt: UIButton!
    
    let hiddenView: UIView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BleoSetRegisterView()
    }
    
    func BleoSetRegisterView() {
        
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
        
        confirmInput.layer.cornerRadius = 16
        confirmInput.layer.masksToBounds = true
        confirmInput.placeholder = "Password Again"
        confirmInput.backgroundColor = .white
        confirmInput.leftPadding(18)
        confirmInput.textColor = ComposeColor.logInput.color
        confirmInput.placeHolderColor(ComposeColor.logInput.color)
        confirmInput.layer.borderColor = UIColor.black.cgColor
        confirmInput.layer.borderWidth = 2
        
        registerInBt.layer.cornerRadius = 16
        registerInBt.layer.masksToBounds = true
        registerInBt.layer.borderWidth = 2
        registerInBt.layer.borderColor = UIColor.black.cgColor
        registerInBt.backgroundColor = ComposeColor.btOne.color
        registerInBt.setTitle("Register", for: .normal)
        registerInBt.setTitleColor(ComposeColor.textOne.color, for: .normal)
        registerInBt.addTarget(self, action: #selector(registerIn), for: .touchUpInside)
        
        registerBack.addTarget(self, action: #selector(registerback), for: .touchUpInside)
    }
    
    func BleoRegisterIn(_ log: BleoLogM, completion: @escaping () -> Void) {
        BleoPrefence.BleoSaveUser(log)
        BleoPrefence.BleoSaveCurrentUser(log.user)
        BleoTransData.shared.isLoginIn = true
        let logUser = BleoMyDetailM(uId: Int.random(in: 2000...3000), head: nil, cover: nil, name: "Bleoer", details: "", follow: [], likePost: [], mes: [:], post: [])
        let userData = BleoTransData.shared.encode(object: logUser)
        BleoPrefence.BleoSaveUserData(log.user, userData: userData!)
        completion()
    }
    
    @objc func registerback() {
        BleoPageRoute.backToLevel()
    }
    
    @objc func registerIn() {
        guard let email = emailInput.text, !email.isEmpty else {
            emailInput.becomeFirstResponder()
            return }
        
        guard let pwd = pwdInput.text, !pwd.isEmpty else {
            pwdInput.becomeFirstResponder()
            return }
        
        guard let confirm = confirmInput.text, confirm != pwd else {
            return
        }
        
        let regModel = BleoLogM(user: email, password: pwd)
        hiddenView.isHidden = false
        BleoToast.Bleoload()
        DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 0...3)) { [self] in
            BleoToast.Bleodismiss()
            hiddenView.isHidden = true
            BleoRegisterIn(regModel) {
                NotificationCenter.default.post(name: Notification.Name("updateUser"), object: nil)
                BleoPageRoute.BleoRootVC(In: self.view.window!)
            }
        }
    }
}
