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
    
    var titleModel: [UvooPublishM] {
        get {
            let land = UvooLoginVM.shared.isLand
            guard land, let meData = UvooUserDefaultsUtils.UvooGetUserInfo() else { return [] }
            if selectButton == myPost {
                return meData.title
            } else if selectButton == myLike {
                return meData.like
            } else {
                return []
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UvooSetColView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UvooLoadMeData()
        meNoData.isHidden = titleModel.count > 0 ? true : false
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
        let width = (UvooScreen.width - 62) / 4
        let height = width / 0.7
        layout.itemSize = CGSize(width: width, height: height)
        let coll = UICollectionView(frame: .zero, collectionViewLayout: layout)
        coll.clipsToBounds = true
        coll.backgroundColor = .clear
        coll.showsVerticalScrollIndicator = false
        coll.register(UvooShowTitleCell.self, forCellWithReuseIdentifier: meCell)
        coll.dataSource = self
        coll.delegate = self
        
        myPost.addTarget(self, action: #selector(selectOnTap), for: .touchUpInside)
        myLike.addTarget(self, action: #selector(selectOnTap), for: .touchUpInside)
        selectList.append(myPost)
        selectList.append(myLike)
        selectList.first?.isSelected = true
        selectButton = myPost
    }
    
    func UvooLoadMeData() {
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
        collectionMedia.reloadData()
    }
    
    @IBAction func meOnTap(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            UvooRouteUtils.UvooSetView()
            break
        case 1:
            if UvooLoginVM.shared.isLand {
                UvooRouteUtils.UvooEditView()
            } else {
                UvooRouteUtils.UvooLogin()
            }
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : UvooDiyDisplayCell = collectionView.dequeueReusableCell(withReuseIdentifier: meCell, for: indexPath) as! UvooDiyDisplayCell
        return cell
    }
}
