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
        UvooLoadCol()
    }
    
    func UvooSetColView() {
        
        userHead.layer.borderWidth = 5
        userHead.layer.borderColor = UIColor.black.cgColor
        userHead.layer.cornerRadius = userHead.frame.height / 2
        userHead.layer.masksToBounds = true
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let width = UvooScreen.width - 32
        let height = width * 0.75
        layout.itemSize = CGSize(width: width, height: height)
        collectionMedia.collectionViewLayout = layout
        collectionMedia.clipsToBounds = true
        collectionMedia.backgroundColor = .clear
        collectionMedia.showsVerticalScrollIndicator = false
        collectionMedia.register(UvooShowTitleCell.self, forCellWithReuseIdentifier: userCell)
        collectionMedia.dataSource = self
        collectionMedia.delegate = self
        
        userPost.addTarget(self, action: #selector(selectOnTap), for: .touchUpInside)
        userLike.addTarget(self, action: #selector(selectOnTap), for: .touchUpInside)
        follow_user.addTarget(self, action: #selector(followOnTap), for: .touchUpInside)
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
    
    func UvooLoadCol() {
        UvooLoginVM.shared.UvooLoadTitles()
        guard let userInfo = userInfo else { return }
        if selectButton == userLike {
            titleModel.removeAll()
            let like = userInfo.like
            for title in UvooLoginVM.shared.titleList {
                if like.contains(title.tId) {
                    if !titleModel.contains(where: { $0.tId == title.tId }) {
                        titleModel.append(title)
                    }
                }
            }
        } else if selectButton == userPost {
            titleModel.removeAll()
            for title in UvooLoginVM.shared.titleList {
                if title.bId == userInfo.uId {
                    if !titleModel.contains(where: { $0.tId == title.tId }) {
                        titleModel.append(title)
                    }
                }
            }
        } else {
            titleModel = []
        }
        userNoData.isHidden = titleModel.count > 0 ? true : false
        collectionMedia.reloadData()
    }
    
    @objc func selectOnTap(_ sender: UIButton) {
        for bt in selectList {
            bt.isSelected = (bt == sender)
        }
        selectButton = sender
        UvooLoadCol()
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
                let land = UvooLoginVM.shared.isLand
                if land {
                    UvooUserDefaultsUtils.UvooUpdateUserInfo { model in
                        if model.follow.contains(where: { $0.uId == userInfo.uId }) {
                            model.follow.removeAll(where: { $0.uId == userInfo.uId })
                        }
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
                    previous()
                }
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
            cell.delegate = self
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

extension UvooUserInfoViewVC: titleAction {
    
    func reportTitle(title: UvooPublishM) {
        UIAlertController.report(Id: title.tId) { [self] in
            UvooLoadCol()
        }
    }
    
    func delTitle(title: UvooPublishM) {}
}
