import UIKit

class BleoPuserInfoViewC: BleoCommonViewC {

    @IBOutlet weak var userCover: UIImageView!
    
    @IBOutlet weak var userBack: UIButton!
    
    @IBOutlet weak var userreport: UIButton!
    
    @IBOutlet weak var userInfoHead: UIImageView!
    
    @IBOutlet weak var userInfoName: UILabel!
    
    @IBOutlet weak var userInfoAbout: UILabel!
    
    @IBOutlet weak var userFollowBt: UIButton!
    
    @IBOutlet weak var userLineBt: UIButton!
    
    @IBOutlet weak var colloectionUserMedia: UICollectionView!
    
    @IBOutlet weak var userInfoNo: UIImageView!
    
    var userInfoMedArr: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BleoSetUseInfoView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadUserInfoMedia()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        BleoSetBtGradient(In: userFollowBt, colors: [ComposeColor.gradFour.color, ComposeColor.gradThree.color])
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadUserInfoMedia), name: Notification.Name(NotificationName.TITLE.rawValue), object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func BleoSetUseInfoView() {
        userBack.addTarget(self, action: #selector(userInfoBack), for: .touchUpInside)
        userreport.addTarget(self, action: #selector(userInfoReport), for: .touchUpInside)
        userFollowBt.addTarget(self, action: #selector(userInfoFollow), for: .touchUpInside)
        userLineBt.addTarget(self, action: #selector(userInfoMes), for: .touchUpInside)
        
        userInfoHead.layer.cornerRadius = userInfoHead.frame.height / 2
        userInfoHead.layer.masksToBounds = true
        userInfoHead.layer.borderWidth = 4
        userInfoHead.layer.borderColor = UIColor.white.cgColor
        userFollowBt.layer.cornerRadius = 5
        userFollowBt.layer.masksToBounds = true
    }
    
    @objc func reloadUserInfoMedia() {
        userInfoNo.isHidden = !userInfoMedArr.isEmpty
        colloectionUserMedia.reloadData()
    }
    
    @objc func userInfoBack() {
        BleoPageRoute.backToLevel()
    }
    
    @objc func userInfoReport() {
        
    }
    
    @objc func userInfoFollow(_ sender: UIButton) {
        
    }
    
    @objc func userInfoMes() {
        
    }
}
