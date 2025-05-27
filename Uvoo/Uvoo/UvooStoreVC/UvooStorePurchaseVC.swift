import UIKit
import SnapKit

class UvooStorePurchaseVC: UvooTopVC {
    
    @IBOutlet weak var vipBack: UIButton!
    
    @IBOutlet weak var storeText: UITextView!
    
    @IBOutlet weak var restoreBt: UIButton!
    
    @IBOutlet weak var storePurchaseBt: UIButton!
    
    @IBOutlet weak var collectionStore: UICollectionView!
    
    var storeCurrent: Int = -1
    
    var storeVopArr: [UvooStoreM] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UvooSetLinkView()
        UvooSetStoreView()
        UvooSetStoreCol()
        UvooLoadStoreVIP()
    }
    
    func UvooSetStoreView() {
        restoreBt.addTarget(self, action: #selector(UvooRestore), for: .touchUpInside)
        storePurchaseBt.addTarget(self, action: #selector(UvooPurchaseStore), for: .touchUpInside)
        vipBack.addTarget(self, action: #selector(previous), for: .touchUpInside)
    }
    
    func UvooSetStoreCol() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let width = UvooScreen.width - 100
        let height = 42.0
        layout.itemSize = CGSize(width: width, height: height)
        collectionStore.collectionViewLayout = layout
        collectionStore.clipsToBounds = true
        collectionStore.backgroundColor = .clear
        collectionStore.showsVerticalScrollIndicator = false
        collectionStore.register(UvooStoreCell.self, forCellWithReuseIdentifier: "UvooStoreCell")
        collectionStore.dataSource = self
        collectionStore.delegate = self
    }
    
    func UvooSetLinkView() {
        let storeAgree = "By Continuing you agree with %@ & %@."
        
        storeText.text = String(format: storeAgree, "Terms of Service", "EULA")
        if let text = storeText.text {
            let rangeTerms = NSMakeRange(text.distance(str: "Terms of Service"), "Terms of Service".count)
            let rangeEula = NSMakeRange(text.distance(str: "EULA"), "EULA".count)
            let attributedText = NSMutableAttributedString(string: text)
            attributedText.addAttribute(.link, value: "terms", range: rangeTerms)
            attributedText.addAttribute(.link, value: "eula", range: rangeEula)
            attributedText.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: rangeTerms)
            attributedText.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: rangeEula)
            attributedText.addAttribute(.foregroundColor, value: UIColor.white, range: rangeTerms)
            attributedText.addAttribute(.foregroundColor, value: UIColor.white, range: rangeEula)
            storeText.attributedText = attributedText
            storeText.textAlignment = .center
            storeText.textColor = UIColor(hex: "#FFFFFF", alpha: 0.5)
            storeText.tintColor = .white
            storeText.delegate = self
        }
    }
    
    func UvooLoadStoreVIP() {
        UvooStoreVM.shared.UvooGetVIP()
        storeVopArr = UvooStoreVM.shared.UvooVIPGoods
    }
    
    @objc func UvooRestore() {
        UvooStoreVM.shared.UvooRestore()
    }
    
    @objc func UvooPurchaseStore() {
        guard storeCurrent != -1 else { return }
        UvooStoreVM.shared.UvooPurcahseVIP(vipId: "\(storeVopArr[storeCurrent].goodId)") { [self] in
            reloadStore()
        }
    }
    
    @objc func reloadStore() {
        storeCurrent = 0
        collectionStore.reloadData()
    }
}

extension UvooStorePurchaseVC: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.row
        storeCurrent = index
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let index = indexPath.row
        let cell : UvooStoreCell = collectionView.dequeueReusableCell(withReuseIdentifier: "UvooStoreCell", for: indexPath) as! UvooStoreCell
        if storeVopArr.count > index {
            cell.UvooConfigure(data: storeVopArr[index])
        }
        return cell
    }
}

extension UvooStorePurchaseVC: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        switch URL.absoluteString {
        case "terms":
            UvooRouteUtils.UvooWebView(url: UvooUrl.term)
            return false
        case "eula":
            UvooRouteUtils.UvooWebView(url: UvooUrl.eula)
            return false
        default:
            break
        }
        return true
    }
}

class UvooStoreCell: UICollectionViewCell {
    
    var vipContain: UIView = UIView()
    
    var selectBt: UIButton = UIButton(type: .custom)
    
    var vipText: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        UvooSetVipCellView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        vipText.text = nil
        selectBt.isSelected = false
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                vipContain.layer.borderColor = UIColor(hex: "#FFCA00").cgColor
                selectBt.isSelected = true
            } else {
                vipContain.layer.borderColor = UIColor.clear.cgColor
                selectBt.isSelected = false
            }
            vipContain.layer.borderWidth = 1.5
        }
    }
    
    func UvooSetVipCellView() {
        self.contentView.addSubview(vipContain)
        vipContain.addSubview(vipText)
        vipContain.addSubview(selectBt)
        
        vipContain.translatesAutoresizingMaskIntoConstraints = false
        selectBt.translatesAutoresizingMaskIntoConstraints = false
        vipText.translatesAutoresizingMaskIntoConstraints = false
        
        vipContain.layer.cornerRadius = 10
        vipContain.layer.masksToBounds = true
        vipContain.layer.borderColor = UIColor.clear.cgColor
        vipContain.layer.borderWidth = 1.5
        vipContain.backgroundColor = .black
        vipText.font = UIFont(name: "PingFangSC-Semibold", size: 16)
        vipText.textColor = .white
        selectBt.setImage(UIImage(named: "store_nomal"), for: .normal)
        selectBt.setImage(UIImage(named: "store_selectOn"), for: .selected)
        
        vipContain.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        selectBt.snp.makeConstraints { make in
            make.size.equalTo(18)
            make.centerX.equalToSuperview().offset(-50)
            make.centerY.equalToSuperview()
        }
        
        vipText.snp.makeConstraints { make in
            make.leading.equalTo(selectBt.snp.trailing).offset(9)
            make.centerY.equalToSuperview()
        }
    }
    
    func UvooConfigure(data: UvooStoreM) {
        vipText.text = data.goodPrice + "/ " + data.goodName
    }
}
