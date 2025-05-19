import Foundation
import UIKit

class UvooUserInfoViewVC: UvooTopVC {
    
    @IBOutlet weak var userHead: UIImageView!
    
    @IBOutlet weak var about_user: UILabel!
    
    @IBOutlet weak var name_user: UILabel!
    
    @IBOutlet weak var follow_text: UILabel!
    
    @IBOutlet weak var follower_text: UILabel!
    
    @IBOutlet weak var liked_text: UILabel!
    
    @IBOutlet weak var userPost: UIButton!
    
    @IBOutlet weak var userLike: UIButton!
    
    @IBOutlet weak var collectionMedia: UICollectionView!
    
    @IBOutlet weak var userNoData: UIImageView!
    
    @IBOutlet weak var follow_user: UIButton!
    
    let userCell = "UvooShowTitleCell"
    
    var selectButton: UIButton?
    
    var selectList: [UIButton] = []
    
    var userInfo: UvooDiyUserM?
    
    var titleModel: [UvooPublishM] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UvooSetColView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UvooLoadUserData()
        userNoData.isHidden = titleModel.count > 0 ? true : false
    }
    
    func UvooSetColView() {
        
        userHead.layer.borderWidth = 5
        userHead.layer.borderColor = UIColor.black.cgColor
        userHead.layer.cornerRadius = userHead.frame.height / 2
        userHead.layer.masksToBounds = true
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let width = (UvooScreen.width - 62) / 4
        let height = width / 0.7
        layout.itemSize = CGSize(width: width, height: height)
        let coll = UICollectionView(frame: .zero, collectionViewLayout: layout)
        coll.clipsToBounds = true
        coll.backgroundColor = .clear
        coll.showsVerticalScrollIndicator = false
        coll.register(UvooShowTitleCell.self, forCellWithReuseIdentifier: userCell)
        coll.dataSource = self
        coll.delegate = self
        
        userPost.addTarget(self, action: #selector(selectOnTap), for: .touchUpInside)
        userLike.addTarget(self, action: #selector(selectOnTap), for: .touchUpInside)
        selectList.append(userPost)
        selectList.append(userLike)
        selectList.first?.isSelected = true
        selectButton = userPost
    }
    
    func UvooLoadUserData() {
        guard let userInfo = userInfo else { return }
        name_user.text = userInfo.name
        userHead.image = UIImage(named: userInfo.head)
        follow_text.text = "\(userInfo.follow)"
        follower_text.text = "\(userInfo.followers)"
        liked_text.text = "\(userInfo.like.count)"
        about_user.text = userInfo.about
        
        let land = UvooLoginVM.shared.isLand
        if land {
            let meData = UvooUserDefaultsUtils.UvooGetUserInfo()
            follow_user.isSelected = meData!.follow.contains(where: { $0.uId == userInfo.uId })
        } else {
            follow_user.isSelected = false
        }
    }
    
    @objc func selectOnTap(_ sender: UIButton) {
        for bt in selectList {
            bt.isSelected = (bt == sender)
        }
        selectButton = sender
        collectionMedia.reloadData()
    }
    
    @objc func followOnTap() {
        guard let userInfo = userInfo else { return }
        let land = UvooLoginVM.shared.isLand
        if land {
            follow_user.isSelected = !follow_user.isSelected
            UvooUserDefaultsUtils.UvooUpdateUserInfo { model in
                if model.follow.contains(where: { $0.uId == userInfo.uId }) {
                    model.follow.removeAll(where: { $0.uId == userInfo.uId })
                } else {
                    model.follow.append(userInfo)
                }
            }
        } else {
            UvooRouteUtils.UvooLogin()
        }
    }
    
    @IBAction func userOnTap(_ sender: UIButton) {
        guard let userInfo = userInfo else { return }
        switch sender.tag {
        case 0:
            previous()
            break
        case 1:
            UIAlertController.report(Id: userInfo.uId) { [self] in
                previous()
            }
            break
        default:
            break
        }
    }
    
}

extension UvooUserInfoViewVC: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titleModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let index = indexPath.row
        let cell : UvooShowTitleCell = collectionView.dequeueReusableCell(withReuseIdentifier: userCell, for: indexPath) as! UvooShowTitleCell
        if titleModel.count > index {
            cell.titleModel = titleModel[index]
            if index % 2 == 0 {
                cell.containerView.backgroundColor = UIColor(hex: "#3A00FF")
                cell.usereName.textColor = .white
                cell.titleLabel.textColor = .white
            } else {
                cell.containerView.backgroundColor = UIColor(hex: "#FED114")
                cell.usereName.textColor = UIColor(hex: "#4D4D4D")
                cell.titleLabel.textColor = UIColor(hex: "#4D4D4D")
            }
        }
        return cell
    }
}
