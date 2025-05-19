import UIKit

class UvooMeSetVC: UvooHeadVC {

    @IBOutlet weak var setBack: UIButton!
    
    @IBOutlet weak var set_edit: UIButton!
    
    @IBOutlet weak var user_name: UILabel!
    
    @IBOutlet weak var set_privacy: UIButton!
    
    @IBOutlet weak var set_terms: UIButton!
    
    @IBOutlet weak var set_del: UIButton!
    
    @IBOutlet weak var set_logout: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UvooSetView()
    }
    
    override func UvooSetHead() {
        userHead.layer.borderWidth = 1
        userHead.layer.borderColor = UIColor(hex: "D1FF00").cgColor
        userHead.layer.cornerRadius = userHead.frame.height / 2
        userHead.layer.masksToBounds = true
    }
    
    func UvooSetView() {
        
        let land = UvooLoginVM.shared.isLand
        let meData = UvooUserDefaultsUtils.UvooGetUserInfo()
        user_name.text = land ? meData!.name : "Guest"
        
        setBack.addTarget(self, action: #selector(previous), for: .touchUpInside)
        set_edit.addTarget(self, action: #selector(UvooGoEidtView), for: .touchUpInside)
        set_privacy.addTarget(self, action: #selector(show(_:)), for: .touchUpInside)
        set_terms.addTarget(self, action: #selector(show(_:)), for: .touchUpInside)
        set_del.addTarget(self, action: #selector(UvooDelUser), for: .touchUpInside)
        set_logout.addTarget(self, action: #selector(UvooLogout), for: .touchUpInside)
    }
    
    func UvooCheckLand() -> Bool {
        return UvooLoginVM.shared.isLand
    }
    
    @objc func UvooGoEidtView() {
        if UvooCheckLand() {
            UvooRouteUtils.UvooEditView()
        } else {
            UvooRouteUtils.UvooLogin()
        }
    }
    
    @objc func UvooLogout() {
        if UvooCheckLand() {
            UIAlertController.logout { [self] in
                UvooUserDefaultsUtils.UvooLogout()
                previous()
            }
        } else {
            UvooRouteUtils.UvooLogin()
        }
    }
    
    @objc func UvooDelUser() {
        if UvooCheckLand() {
            UIAlertController.delete { [self] in
                UvooUserDefaultsUtils.UvooDelUser()
                UvooLoginVM.shared.UvooClean()
                PostManager.shared.UvooInitPostWithU()
                previous()
            }
        } else {
            UvooRouteUtils.UvooLogin()
        }
    }
    
    @objc func show(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            UvooRouteUtils.UvooWebView(url: UvooUrl.privacy)
            break
        case 1:
            UvooRouteUtils.UvooWebView(url: UvooUrl.term)
            break
        default:
            break
        }
    }
}


