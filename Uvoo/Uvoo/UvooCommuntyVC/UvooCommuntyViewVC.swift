import Foundation
import UIKit
import SnapKit

class UvooCommuntyViewVC: UvooHeadVC {
    
    @IBOutlet weak var comTopTitle: UIView!
    
    let titleCell = "UvooShowTitleCell"
    
    lazy var showTitleCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let width = UvooScreen.width - 32
        let height = width * 0.75
        layout.itemSize = CGSize(width: width, height: height)
        let coll = UICollectionView(frame: .zero, collectionViewLayout: layout)
        coll.clipsToBounds = true
        coll.backgroundColor = .clear
        coll.showsVerticalScrollIndicator = false
        coll.register(UvooShowTitleCell.self, forCellWithReuseIdentifier: titleCell)
        coll.dataSource = self
        coll.delegate = self
        return coll
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UvooSetComView()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTitle), name: Notification.Name(UvooNotiName.title), object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func UvooSetComView() {
        view.addSubview(showTitleCollectionView)
        
        showTitleCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        showTitleCollectionView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalTo(comTopTitle.snp.bottom).offset(20)
            make.bottom.equalToSuperview()
        }
    }
    
    @objc func reloadTitle() {
        UvooLoginVM.shared.UvooLoadTitles()
        showTitleCollectionView.reloadData()
    }
    
    @IBAction func comOnTap(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            UvooRouteUtils.UvooPublish()
            break
        case 1:
            UvooRouteUtils.UvooSetView()
            break
        default:
            break
        }
    }
    
}

extension UvooCommuntyViewVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return UvooLoginVM.shared.titleList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        UvooRouteUtils.UvooShowDetail()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let index = indexPath.row
        let cell : UvooShowTitleCell = collectionView.dequeueReusableCell(withReuseIdentifier: titleCell, for: indexPath) as! UvooShowTitleCell
        let data = UvooLoginVM.shared.titleList
        if data.count > index {
            
        }
        return cell
    }
    
}
