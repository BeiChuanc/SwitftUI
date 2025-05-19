import Foundation
import UIKit
import SnapKit

class UvooDiyDisplayVC: UvooTopVC {
    
    let disPlayCell = "UvooDiyDisplayCell"
    
    var topView: UIView = UIView()
    
    var disPlayBack: UIButton = UIButton(type: .custom)
    
    var topText: UIImageView = UIImageView()
    
    var delButton: UIButton = UIButton(type: .custom)
    
    var delCurrent: Int = 0
    
    lazy var showDisPlayCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let width = (UvooScreen.width - 62) / 4
        let height = width / 0.7
        layout.itemSize = CGSize(width: width, height: height)
        let coll = UICollectionView(frame: .zero, collectionViewLayout: layout)
        coll.clipsToBounds = true
        coll.backgroundColor = .clear
        coll.showsVerticalScrollIndicator = false
        coll.register(UvooDiyDisplayCell.self, forCellWithReuseIdentifier: disPlayCell)
        coll.dataSource = self
        coll.delegate = self
        
        return coll
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "#FED114")
        UvooDisplaySetView()
    }
    
    func UvooDisplaySetView() {
        view.addSubview(showDisPlayCollection)
        view.addSubview(topView)
        topView.addSubview(disPlayBack)
        topView.addSubview(topText)
        topView.addSubview(delButton)
        
        topView.backgroundColor = .clear
        
        showDisPlayCollection.translatesAutoresizingMaskIntoConstraints = false
        topView.translatesAutoresizingMaskIntoConstraints = false
        disPlayBack.translatesAutoresizingMaskIntoConstraints = false
        topText.translatesAutoresizingMaskIntoConstraints = false
        
        disPlayBack.addTarget(self, action: #selector(previous), for: .touchUpInside)
        disPlayBack.setImage(UIImage(named: "btnBack_black"), for: .normal)
        delButton.setImage(UIImage(named: "del_dis"), for: .normal)
        delButton.addTarget(self, action: #selector(delOnTap), for: .touchUpInside)
        
        topText.image = UIImage(named: "genText")
        
        topView.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        disPlayBack.snp.makeConstraints { make in
            make.size.equalTo(40)
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        topText.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        delButton.snp.makeConstraints { make in
            make.size.equalTo(40)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        showDisPlayCollection.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview()
        }
    }
    
    @objc func delOnTap() {
        let land = UvooLoginVM.shared.isLand
        if land {
            UvooUserDefaultsUtils.UvooUpdateUserInfo { model in
                model.diy.remove(at: delCurrent)
            }
            showDisPlayCollection.reloadData()
            delCurrent = 0
        }
    }
    
}

extension UvooDiyDisplayVC: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let land = UvooLoginVM.shared.isLand
        if land {
            let meData = UvooUserDefaultsUtils.UvooGetUserInfo()
            return meData!.diy.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.row
        delCurrent = index
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let index = indexPath.row
        let cell : UvooDiyDisplayCell = collectionView.dequeueReusableCell(withReuseIdentifier: disPlayCell, for: indexPath) as! UvooDiyDisplayCell
        let diyData = UvooUserDefaultsUtils.UvooGetUserInfo()!.diy
        if diyData.count > index {
            cell.UvooDisplayCellLoadData(model: diyData[index])
        }
        return cell
    }
}

class UvooDiyDisplayCell: UICollectionViewCell {
    
    var disPlayBg: UIImageView = UIImageView()
    
    var disShowClothe: UIImageView = UIImageView()
    
    var disStick: UIImageView = UIImageView()
    
    var delBu: UIButton = UIButton(type: .custom)
    
    let genImageBg: [String] = ["tick_de_1", "tick_de_2", "tick_de_3", "tick_de_4"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disPlayBg.image = nil
        disShowClothe.image = nil
        disStick.image = nil
        delBu.isSelected = false
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                delBu.isHidden = false
            } else {
                delBu.isHidden = true
            }
        }
    }
    
    func UvooSetDisPlayCell() {
        self.contentView.addSubview(disPlayBg)
        self.contentView.addSubview(disShowClothe)
        self.contentView.addSubview(disStick)
        self.contentView.addSubview(delBu)
        
        disPlayBg.translatesAutoresizingMaskIntoConstraints = false
        disShowClothe.translatesAutoresizingMaskIntoConstraints = false
        disStick.translatesAutoresizingMaskIntoConstraints = false
        delBu.translatesAutoresizingMaskIntoConstraints = false
        
        disPlayBg.image = UIImage(named: "disPlay")
        disShowClothe.contentMode = .scaleAspectFit
        disStick.backgroundColor = .clear
        delBu.isHidden = true
        delBu.setImage(UIImage(named: "del_select"), for: .normal)
        
        disPlayBg.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        disShowClothe.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(5)
            make.trailing.equalToSuperview().offset(-5)
            make.top.equalToSuperview().offset(11)
            make.bottom.equalToSuperview().offset(-11)
        }
        
        delBu.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(11)
            make.trailing.equalToSuperview().offset(-10)
        }
    }
    
    func UvooDisplayCellLoadData(model: UvooLibM) {
        UvooSetDisPlayCell()
        disShowClothe.image = UIImage(named: genImageBg[model.designId])
        disStick.image = model.image
        disStick.layer.cornerRadius = 5
        disStick.layer.masksToBounds = true
        switch model.designId {
        case 0:
            disStick.snp.makeConstraints { make in
                make.centerY.equalTo(disPlayBg)
                make.leading.equalTo(disPlayBg.snp.leading).offset(25)
                make.width.height.equalTo(15)
            }
            break
        case 1:
            disStick.snp.makeConstraints { make in
                make.centerX.equalTo(disPlayBg)
                make.centerY.equalTo(disPlayBg).offset(-15)
                make.width.height.equalTo(30)
            }
            break
        case 2:
            disStick.snp.makeConstraints { make in
                make.centerY.equalTo(disPlayBg).offset(-15)
                make.leading.equalTo(disPlayBg.snp.leading).offset(25)
                make.width.height.equalTo(15)
            }
            break
        case 3:
            disStick.snp.makeConstraints { make in
                make.centerY.equalTo(disPlayBg).offset(-10)
                make.leading.equalTo(disPlayBg.snp.leading).offset(30)
                make.width.height.equalTo(15)
            }
            break
        default:
            break
        }
    }
}
