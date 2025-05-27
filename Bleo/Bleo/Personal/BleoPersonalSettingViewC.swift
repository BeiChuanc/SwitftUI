import UIKit

class BleoPersonalSettingViewC: BleoCommonViewC {

    @IBOutlet weak var setBack: UIButton!
    
    @IBOutlet weak var setUserHead: UIImageView!
    
    @IBOutlet weak var setUserName: UILabel!
    
    @IBOutlet weak var setTerms: UIButton!
    
    @IBOutlet weak var setPrivacy: UIButton!
    
    @IBOutlet weak var setdelAcc: UIButton!
    
    @IBOutlet weak var setLogout: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BleoSetView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        BleoLoadUserData()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        BleoSetBtGradient(In: setLogout, colors: [ComposeColor.gradOne.color, ComposeColor.gradTwo.color])
    }
    
    func BleoSetView() {
        setUserHead.layer.cornerRadius = setUserHead.frame.height / 2
        setUserHead.layer.masksToBounds = true
        setLogout.layer.cornerRadius = setLogout.frame.height / 2
        setLogout.layer.masksToBounds = true
        
        setBack.addTarget(self, action: #selector(settingback), for: .touchUpInside)
        setTerms.addTarget(self, action: #selector(settingshowTerms), for: .touchUpInside)
        setPrivacy.addTarget(self, action: #selector(settingshowPrivacy), for: .touchUpInside)
        setdelAcc.addTarget(self, action: #selector(settingDel), for: .touchUpInside)
        setLogout.addTarget(self, action: #selector(settingLog), for: .touchUpInside)
    }
    
    func BleoLoadUserData() {
        if isLogin {
            guard let headData = userMy.head else {
                setUserHead.image = UIImage(named: "bleoUser")
                return }
            let head = UIImage(data: headData)
            setUserHead.image = head
        } else { setUserHead.image = UIImage(named: "bleoUser") }
    }
    
    @objc func settingback() {
        BleoPageRoute.backToLevel()
    }
    
    @objc func settingshowTerms() {
        BleoPageRoute.BleoWebLink()
    }
    
    @objc func settingshowPrivacy() {
        BleoPageRoute.BleoWebLink(link: ProtocolLink.PRIVACYLINK)
    }
    
    @objc func settingLog() {
        if isLogin {
            UIAlertController.logout {
                BleoTransData.shared.isLoginIn = false
                BleoPrefence.BleoSaveCurrentUser("")
                BleoTransData.shared.userMy = BleoMyDetailM()
                BleoPageRoute.backToLevel()
                NotificationCenter.default.post(name: Notification.Name("updateUser"), object: nil)
            }
        } else {
            BleoPageRoute.BleoLoginIn()
        }
    }
    
    @objc func settingDel() {
        if isLogin {
            UIAlertController.delete {
                BleoPrefence.BleoDelUser()
                BleoTransData.shared.BleoCleanData()
                BleoPageRoute.backToLevel()
                NotificationCenter.default.post(name: Notification.Name("updateUser"), object: nil)
            }
        } else {
            BleoPageRoute.BleoLoginIn()
        }
    }
}
