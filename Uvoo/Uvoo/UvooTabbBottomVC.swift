import Foundation
import UIKit
import SnapKit

struct UvooTabItem {
    
    var unselect: String
    
    var select: String
}

enum UvooNotiName {
    
    static var tab: String { return "tab" }
    
    static var com: String { return "com" }
    
    static var title: String { return "title" }
}

class UvooTabbBottomVC: UITabBarController {
    
    private let learnVc = UvooLearnViewVC()
    
    private let diyVC = UvooDiyViewVC()
    
    private let communtyVc = UvooCommuntyViewVC()
    
    private let meVc = UvooMeViewVC()
    
    
    var tabBottomView: UIView = UIView()
    
    var tabBottomBg: UIImageView = UIImageView()
    
    var tabStackItem:  UIStackView = UIStackView()
    
    var tabButtomList: [UIButton] = []
    
    let tabImage: [UvooTabItem] = [UvooTabItem(unselect: "tab_learn", select: "tab_learn_select"),
                                   UvooTabItem(unselect: "tab_diy",   select: "tab_diy_select"),
                                   UvooTabItem(unselect: "tab_com",   select: "tab_com_select"),
                                   UvooTabItem(unselect: "tab_me",    select: "tab_me_select"),]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UvooSetTabbar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        NotificationCenter.default.addObserver(self, selector: #selector(tabselect), name: Notification.Name(UvooNotiName.tab), object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func UvooSetTabbar() {
        viewControllers = [learnVc, diyVC, communtyVc, meVc]
        
        view.addSubview(tabBottomView)
        tabBottomView.addSubview(tabBottomBg)
        tabBottomView.addSubview(tabStackItem)
        
        tabBottomView.translatesAutoresizingMaskIntoConstraints = false
        tabStackItem.translatesAutoresizingMaskIntoConstraints  = false
        tabBottomBg.translatesAutoresizingMaskIntoConstraints   = false
        
        tabBottomBg.contentMode = .scaleToFill
        tabBottomBg.layer.masksToBounds = true
        tabBottomBg.image = UIImage(named: "tabbar_bg")
        
        tabStackItem.spacing = 35
        
        for item in Array(0..<4) {
            let tabButton = UIButton(type: .custom)
            tabButton.tag = item
            tabButton.setImage(UIImage(named: tabImage[item].unselect), for: .normal)
            tabButton.setImage(UIImage(named: tabImage[item].select), for: .selected)
            tabButton.translatesAutoresizingMaskIntoConstraints = false
            tabButton.contentVerticalAlignment = .bottom
            tabButton.addTarget(self, action: #selector(tabOnTap(_:)), for: .touchUpInside)
            
            tabButton.snp.makeConstraints { make in
                make.height.equalTo(74)
                make.width.equalTo(66)
            }
            
            
            tabButtomList.append(tabButton)
            tabStackItem.addArrangedSubview(tabButton)
        }
        
        selectedIndex = 0
        tabButtomList[0].isSelected = true
        
        tabBottomView.snp.makeConstraints { make in
            make.height.equalTo(80)
            make.width.equalTo(UvooScreen.width)
            make.bottom.equalToSuperview()
        }
        
        tabBottomBg.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        tabStackItem.snp.makeConstraints { make in
            make.height.equalTo(74)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-10)
        }
        
    }
    
    @objc func tabselect(notification: Notification) {
        guard let select = notification.object as? Int else { return }
        for bt in self.tabButtomList {
            bt.isSelected = (bt.tag == select)
        }
        selectedIndex = select
    }
    
    @objc func tabOnTap(_ sender: UIButton) {
        for bt in self.tabButtomList {
            bt.isSelected = (bt == sender)
        }
        selectedIndex = sender.tag
    }
}
