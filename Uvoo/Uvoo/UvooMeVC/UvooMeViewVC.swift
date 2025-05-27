import Foundation
import UIKit

class UvooMeViewVC: UvooHeadVC {
    
    @IBOutlet weak var meBack: UIButton!
    
    @IBOutlet weak var meSet: UIButton!
    
    @IBOutlet weak var about_me: UILabel!
    
    @IBOutlet weak var name_me: UILabel!
    
    @IBOutlet weak var follow_text: UILabel!
    
    @IBOutlet weak var liked_text: UILabel!
    
    @IBOutlet weak var myPost: UIButton!
    
    @IBOutlet weak var myLike: UIButton!
    
    @IBOutlet weak var collectionMedia: UICollectionView!
    
    @IBOutlet weak var meNoData: UIImageView!
    
    let meCell = "UvooShowTitleCell"
    
    var selectButton: UIButton?
    
    var selectList: [UIButton] = []
    
    var titleModel: [UvooPublishM] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UvooSetColView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UvooLoadMeData()
        UvooLoadCol()
    }
    
    override func UvooSetHead() {
        userHead.layer.borderWidth = 5
        userHead.layer.borderColor = UIColor.black.cgColor
        userHead.layer.cornerRadius = userHead.frame.height / 2
        userHead.layer.masksToBounds = true
    }
    
    func UvooSetColView() {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let width = UvooScreen.width - 32
        let height = width * 0.75
        layout.itemSize = CGSize(width: width, height: height)
        collectionMedia.collectionViewLayout = layout
        collectionMedia.clipsToBounds = true
        collectionMedia.backgroundColor = .clear
        collectionMedia.showsVerticalScrollIndicator = false
        collectionMedia.register(UvooShowTitleCell.self, forCellWithReuseIdentifier: meCell)
        collectionMedia.dataSource = self
        collectionMedia.delegate = self
        
        myPost.addTarget(self, action: #selector(selectOnTap), for: .touchUpInside)
        myLike.addTarget(self, action: #selector(selectOnTap), for: .touchUpInside)
        selectList.append(myPost)
        selectList.append(myLike)
    }
    
    func UvooLoadMeData() {
        selectButton = myPost
        myPost.isSelected = true
        myLike.isSelected = false
        
        let land = UvooLoginVM.shared.isLand
        if land {
            let meData = UvooUserDefaultsUtils.UvooGetUserInfo()
            name_me.text = meData!.name
            about_me.text = meData!.about
            follow_text.text = "\(meData!.follow.count)"
            liked_text.text = "\(meData!.like.count)"
        } else {
            name_me.text = "Guest"
            about_me.text = ""
            follow_text.text = "0"
            liked_text.text = "0"
        }
    }
    
    @objc func selectOnTap(_ sender: UIButton) {
        for bt in selectList {
            bt.isSelected = (bt == sender)
        }
        selectButton = sender
        UvooLoadCol()
    }
    
    func UvooLoadCol() {
        UvooLoginVM.shared.UvooLoadTitles()
        
        let land = UvooLoginVM.shared.isLand
        if !land {
            titleModel = []
            meNoData.isHidden = titleModel.count > 0 ? true : false
            collectionMedia.reloadData()
            return
        }
        
        guard let userInfo = UvooUserDefaultsUtils.UvooGetUserInfo() else { return }
        
        if selectButton == myLike {
            titleModel.removeAll()
            let like = userInfo.like
            for title in UvooLoginVM.shared.titleList {
                if like.contains(where: { $0.tId == title.tId }) {
                    if !titleModel.contains(where: { $0.tId == title.tId }) {
                        titleModel.append(title)
                    }
                }
            }
        } else if selectButton == myPost {
            titleModel.removeAll()
            for title in userInfo.title {
                if !titleModel.contains(where: { $0.tId == title.tId }) {
                    titleModel.append(title)
                }
            }
        } else {
            titleModel = []
        }
        meNoData.isHidden = titleModel.count > 0 ? true : false
        collectionMedia.reloadData()
    }
    
    @IBAction func meOnTap(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            UvooRouteUtils.UvooSetView()
            break
        case 1:
            UvooRouteUtils.UvooStoreVipSub()
            break
        case 2:
            previous()
            break
        default:
            break
        }
    }
    
}

extension UvooMeViewVC: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titleModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let index = indexPath.row
        let cell : UvooShowTitleCell = collectionView.dequeueReusableCell(withReuseIdentifier: meCell, for: indexPath) as! UvooShowTitleCell
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

extension UvooMeViewVC: titleAction {
    
    func reportTitle(title: UvooPublishM) {
        UIAlertController.report(Id: title.tId) { [self] in
            UvooLoadCol()
        }
    }
    
    func delTitle(title: UvooPublishM) {
        UIAlertController.deleteT { [self] in
            UvooUserDefaultsUtils.UvooUpdateUserInfo { model in
                model.title.removeAll(where: { $0.tId == title.tId })
            }
            UvooLoadCol()
        }
    }
}
