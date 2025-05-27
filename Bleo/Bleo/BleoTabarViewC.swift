import Foundation
import UIKit
import SnapKit

class BleoTabarViewC: UITabBarController {
    
    var tabBarBt: [UIButton] = []
    
    var tabFrontView: UIView = UIView()
    
    var modifyBt: UIButton = UIButton(type: .custom)
    
    var comBt: UIButton = UIButton(type: .custom)
    
    var uploadBt: UIButton = UIButton(type: .custom)
    
    var mesBt: UIButton = UIButton(type: .custom)
    
    var personalBt: UIButton = UIButton(type: .custom)
    
    var tabStack: UIStackView = UIStackView()
    
    var tabBarName: [String] = ["modify_tab", "com_tab", "upload_tab", "mes_tab", "personal_tab"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BleoSetTabBar()
        viewControllers = [BleoModifyViewC(), BleoCommunityViewC(), BleoPublishViewC(), BleoMessageListViewC(), BleoPersonalInfoViewC()]
        selectedIndex = 0
        tabBarBt[0].isSelected = true
        var usersData = BleoPrefence.BleoGetAllUser()
        var users = BleoPrefence.BleoGetUsers()
        print("用户数据:\(usersData)")
        print("用户数据:\(users)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = true
    }
    
    func BleoSetTabBar() {
        view.addSubview(tabFrontView)
        tabFrontView.addSubview(modifyBt)
        tabFrontView.addSubview(comBt)
        tabFrontView.addSubview(uploadBt)
        tabFrontView.addSubview(mesBt)
        tabFrontView.addSubview(personalBt)
        tabFrontView.addSubview(tabStack)
        
        tabFrontView.translatesAutoresizingMaskIntoConstraints = false
        modifyBt.translatesAutoresizingMaskIntoConstraints = false
        comBt.translatesAutoresizingMaskIntoConstraints = false
        uploadBt.translatesAutoresizingMaskIntoConstraints = false
        mesBt.translatesAutoresizingMaskIntoConstraints = false
        personalBt.translatesAutoresizingMaskIntoConstraints = false
        tabStack.translatesAutoresizingMaskIntoConstraints = false
        
        tabFrontView.backgroundColor = .white
        tabFrontView.layer.cornerRadius = 15
        tabFrontView.layer.masksToBounds = true
        tabStack.spacing = 24
        tabStack.axis = .horizontal
        tabBarBt = [modifyBt, comBt, uploadBt, mesBt, personalBt]
        for (index, item) in tabBarBt.enumerated() {
            item.tag = index
            item.setImage(UIImage(named: tabBarName[index]), for: .normal)
            item.setImage(UIImage(named: "\(tabBarName[index])_s"), for: .selected)
            item.addTarget(self, action: #selector(upadeTabBar), for: .touchUpInside)
            
            item.snp.makeConstraints { make in
                make.size.equalTo(48)
            }
            
            tabStack.addArrangedSubview(item)
        }
        
        tabFrontView.snp.makeConstraints { make in
            make.height.equalTo(65)
            make.leading.equalToSuperview().offset(31)
            make.trailing.equalToSuperview().offset(-31)
            make.bottom.equalToSuperview().offset(-24)
        }
        
        tabStack.snp.makeConstraints { make in
            make.center.equalTo(tabFrontView)
        }
    }
    
    @objc func upadeTabBar(_ sender: UIButton) {
        for tabBar in tabBarBt {
            tabBar.isSelected = (sender == tabBar)
        }
        selectedIndex = sender.tag
    }
}
