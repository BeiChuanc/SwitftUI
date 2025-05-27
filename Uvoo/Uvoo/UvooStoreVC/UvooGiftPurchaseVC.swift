import UIKit
import SnapKit

class UvooGiftPurchaseVC: UvooTopVC {

    @IBOutlet weak var giftBack: UIButton!
    
    @IBOutlet weak var collectionGift: UICollectionView!
    
    var giftCurrent: Int = -1
    
    var storeGiftArr: [UvooStoreM] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "#000000", alpha: 0)
        giftBack.addTarget(self, action: #selector(previousDis), for: .touchUpInside)
        UvooSetGiftCol()
        UvooLoadGift()
    }
    
    func UvooSetGiftCol() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let width = (UvooScreen.width - 100) / 4
        let height = 142.0
        layout.itemSize = CGSize(width: width, height: height)
        layout.minimumInteritemSpacing = 20
        layout.minimumLineSpacing = 20
        collectionGift.collectionViewLayout = layout
        collectionGift.clipsToBounds = true
        collectionGift.backgroundColor = .clear
        collectionGift.showsHorizontalScrollIndicator = false
        collectionGift.register(UvooGiftSendCell.self, forCellWithReuseIdentifier: "UvooGiftSendCell")
        collectionGift.dataSource = self
        collectionGift.delegate = self
    }
    
    func UvooLoadGift() {
        let limit = UvooUserDefaultsUtils.UvooGetLimit()
        UvooStoreVM.shared.UvooGetGift()
        storeGiftArr = UvooStoreVM.shared.UvooGiftGoods
        storeGiftArr = storeGiftArr.filter { item in return !(limit && item.isLimit == limit) }
    }
    
    @objc func reloadGift() {
        UvooLoadGift()
        collectionGift.reloadData()
    }
}

extension UvooGiftPurchaseVC: UICollectionViewDataSource, UICollectionViewDelegate, GiftPu {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return storeGiftArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let index = indexPath.row
        let cell : UvooGiftSendCell = collectionView.dequeueReusableCell(withReuseIdentifier: "UvooGiftSendCell", for: indexPath) as! UvooGiftSendCell
        if storeGiftArr.count > index {
            cell.goodModel = storeGiftArr[index]
            cell.delegate = self
        }
        return cell
    }
    
    func purchase(cell: UvooGiftSendCell) {
        if let model = cell.goodModel {
            UvooStoreVM.shared.UvooPurchaseGift(gId: "\(model.goodId)") { [self] in
                reloadGift()
            }
        }
    }
}


protocol GiftPu {
    func purchase(cell: UvooGiftSendCell)
}

class UvooGiftSendCell: UICollectionViewCell {
    
    var giftImage: UIImageView = UIImageView()
    
    var giftName: UILabel = UILabel()
    
    var giftPrice: UILabel = UILabel()
    
    var sendGift: UIButton = UIButton(type: .custom)
    
    var delegate: GiftPu?
    
    var goodModel: UvooStoreM? {
        didSet {
            guard let data = self.goodModel else { return }
            giftName.text = data.goodName
            giftPrice.text = data.goodPrice
            if data.goodId.contains("prem") {
                giftImage.image = UIImage(named: "giftLimit")
            } else if data.goodId.contains("pri_pic") {
                giftImage.image = UIImage(named: "giftOne")
            } else if data.goodId.contains("pri_vid") {
                giftImage.image = UIImage(named: "giftTwo")
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        UvooSetGiftCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        giftImage.image = nil
        giftName.text = nil
        giftPrice.text = nil
    }
    
    func UvooSetGiftCell() {
        self.contentView.addSubview(giftImage)
        self.contentView.addSubview(giftName)
        self.contentView.addSubview(giftPrice)
        self.contentView.addSubview(sendGift)
        
        giftImage.translatesAutoresizingMaskIntoConstraints = false
        giftName.translatesAutoresizingMaskIntoConstraints = false
        giftPrice.translatesAutoresizingMaskIntoConstraints = false
        sendGift.translatesAutoresizingMaskIntoConstraints = false
        
        giftImage.contentMode = .scaleAspectFit
        giftName.font = UIFont(name: "PingFangSC-Regular", size: 12)
        giftName.textColor = .white
        giftPrice.font = UIFont(name: "PingFangSC-Regular", size: 12)
        giftPrice.textColor = .white
        sendGift.layer.cornerRadius = 5
        sendGift.layer.masksToBounds = true
        sendGift.backgroundColor = UIColor(hex: "FFCA00")
        sendGift.setTitle("Gift", for: .normal)
        sendGift.titleLabel?.font = UIFont(name: "PingFangSC-Semibold", size: 12)
        sendGift.addTarget(self, action: #selector(purchaseGift), for: .touchUpInside)
        
        giftImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.size.equalTo(74)
        }
        
        giftName.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(giftImage.snp.bottom).offset(-2)
        }
        
        giftPrice.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(giftName.snp.bottom).offset(-5)
        }
        
        sendGift.snp.makeConstraints { make in
            make.height.equalTo(24)
            make.width.equalTo(50)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    @objc func purchaseGift() {
        guard let data = self.goodModel else { return }
        delegate?.purchase(cell: self)
    }
}
