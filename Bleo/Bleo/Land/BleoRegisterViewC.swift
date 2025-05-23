import UIKit

class BleoRegisterViewC: BleoLandBaseViewC {

    @IBOutlet weak var registerBack: UIButton!
    
    @IBOutlet weak var emailInput: UITextField!
    
    @IBOutlet weak var pwdInput: UITextField!
    
    @IBOutlet weak var confirmInput: UITextField!
    
    @IBOutlet weak var registerInBt: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BleoSetRegisterView()
    }
    
    func BleoSetRegisterView() {
        
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
        
    }
}
