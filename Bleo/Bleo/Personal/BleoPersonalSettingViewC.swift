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
        
    }
    
    @objc func settingback() {
        
    }
    
    @objc func settingshowTerms() {
        BleoPageRoute.BleoWebLink()
    }
    
    @objc func settingshowPrivacy() {
        BleoPageRoute.BleoWebLink(link: ProtocolLink.PRIVACYLINK)
    }
    
    @objc func settingLog() {
        
    }
    
    @objc func settingDel() {
        
    }
}
