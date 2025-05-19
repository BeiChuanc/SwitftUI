import UIKit

class UvooComRegisterVC: UvooTextVC {

    @IBOutlet weak var register_back: UIButton!
    
    @IBOutlet weak var view_email: UIView!
    
    @IBOutlet weak var input_email: UITextField!
    
    @IBOutlet weak var view_password: UIView!
    
    @IBOutlet weak var input_password: UITextField!
    
    @IBOutlet weak var view_confirm: UIView!
    
    @IBOutlet weak var input_confirm: UITextField!
    
    @IBOutlet weak var register_login: UIButton!
    
    let coverView: UIView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UvooSetRegisterView()
    }
    
    func UvooSetRegisterView() {
        register_back.addTarget(self, action: #selector(previous), for: .touchUpInside)
        register_login.addTarget(self, action: #selector(UvooRegisterIn), for: .touchUpInside)
        
        view_email.layer.cornerRadius = 10
        view_email.layer.masksToBounds = true
        view_password.layer.cornerRadius = 10
        view_password.layer.masksToBounds = true
        view_confirm.layer.cornerRadius = 10
        view_confirm.layer.masksToBounds = true
        
        input_email.placeholder = "Input username"
        input_email.leftPadding(10)
        input_email.placeHolderColor(UIColor(hex: "#FFFFFF", alpha: 0.5))
        
        input_password.placeholder = "Input password"
        input_password.leftPadding(10)
        input_password.placeHolderColor(UIColor(hex: "#FFFFFF", alpha: 0.5))
        
        input_confirm.placeholder = "Confirm Password"
        input_confirm.leftPadding(10)
        input_confirm.placeHolderColor(UIColor(hex: "#FFFFFF", alpha: 0.5))
        register_login.layer.cornerRadius = 10
        register_login.layer.masksToBounds = true
        
        view.addSubview(coverView)
        coverView.isHidden = true
        coverView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    @objc func UvooRegisterIn() {
        guard let email = input_email.text, !email.isEmpty else {
            input_email.becomeFirstResponder()
            return }
        
        guard let password = input_password.text, !password.isEmpty else {
            input_password.becomeFirstResponder()
            return }
        
        guard input_password.text == input_confirm.text else {
            UvooLoadVM.UvooNotice(text: "Passwords do not match.")
            return }
        
        coverView.isHidden = false
        let registerModel = UvooLoginM(email: email, pwd: password)
        UvooLoadVM.Uvooload()
        DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 0...3)) { [self] in
            UvooLoadVM.Uvoodismiss()
            coverView.isHidden = true
            UvooLoginVM.shared.UvooLoginIn(type: .REGISTER, model: registerModel) {
                UvooRouteUtils.UvooLearn(window: self.view.window!)
            }
        }
    }
}
