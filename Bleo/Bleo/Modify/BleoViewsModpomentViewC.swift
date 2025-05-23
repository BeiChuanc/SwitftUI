import UIKit
import SnapKit

class BleoViewsModpomentViewC: BleoCommonViewC {

    @IBOutlet weak var viewsBack: UIButton!
    
    @IBOutlet weak var showModImage: UIImageView!
    
    @IBOutlet weak var roadBt: UIButton!
    
    @IBOutlet weak var eleBt: UIButton!
    
    @IBOutlet weak var mouBt: UIButton!
    
    @IBOutlet weak var offElBt: UIButton!
    
    @IBOutlet weak var collectinViews: UICollectionView!
    
    var showViewsBt: [UIButton] = []
    
    var viewsData: [BleoShowViewsCellM] = []
    
    var switchPartName: [String] = ["Road Bike", "Electric Bicycle", "Mountain Bike", "Off-Road bicycle"]
    
    var cyModRoadName: [String] = ["Clipless Pedals", "Saddle Bag", "Cycling Computer", "Disc Road Wheel"]
    
    var cyModElName: [String] = ["Drive Unit", "Battery Cover", "Battery", "Motor", "TQ Chainring", "Cover"]
    
    var cyModMounName: [String] = ["Pedal Set", "Fender Set", "Bike Helmet"]
    
    var cyModOffName: [String] = ["Disc Brake Pads", "Helmet", "Bike Shoe", "Road Handlebar", "Mountain Tire", "Tape Set"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BleoSetViews()
        BleoSetCollectionView()
    }
    
    func BleoSetViews() {
        showViewsBt = [roadBt, eleBt, mouBt, offElBt]
        for bt in showViewsBt {
            bt.addTarget(self, action: #selector(switchData), for: .touchUpInside)
        }
        viewsBack.addTarget(self, action: #selector(viewback), for: .touchUpInside)
        switchData(roadBt)
    }
    
    func BleoSetCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let width = (ScreenSize.W - 60) / 3
        let height = 138.0
        layout.itemSize = CGSize(width: width, height: height)
        collectinViews.collectionViewLayout = layout
        collectinViews.clipsToBounds = true
        collectinViews.backgroundColor = .clear
        collectinViews.showsVerticalScrollIndicator = false
        collectinViews.register(BleoShowViesModCell.self, forCellWithReuseIdentifier: "BleoShowViesModCell")
        collectinViews.dataSource = self
        collectinViews.delegate = self
    }
    
    @objc func viewback() {
        BleoPageRoute.backToLevel()
    }
    
    @objc func switchData(_ sender: UIButton) {
        
        for bt in showViewsBt {
            bt.isSelected = (sender == bt)
        }
        
        viewsData.removeAll()
        var model = BleoShowViewsCellM()
        switch sender.tag {
        case 1:
            for (index, _) in cyModRoadName.enumerated() {
                model.showViewsImage = "road_\(index + 1)"
                model.showViewsText = cyModRoadName[index]
                viewsData.append(model)
            }
            break
        case 2:
            for (index, _) in cyModElName.enumerated() {
                model.showViewsImage = "el_\(index + 1)"
                model.showViewsText = cyModElName[index]
                viewsData.append(model)
            }
            break
        case 3:
            for (index, _) in cyModMounName.enumerated() {
                model.showViewsImage = "mou_\(index + 1)"
                model.showViewsText = cyModMounName[index]
                viewsData.append(model)
            }
            break
        case 4:
            for (index, _) in cyModOffName.enumerated() {
                model.showViewsImage = "off_\(index + 1)"
                model.showViewsText = cyModOffName[index]
                viewsData.append(model)
            }
            break
        default:
            viewsData = []
            break
        }
        collectinViews.reloadData()
    }
}

extension BleoViewsModpomentViewC: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewsData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let index = indexPath.row
        let cell : BleoShowViesModCell = collectionView.dequeueReusableCell(withReuseIdentifier: "BleoShowViesModCell", for: indexPath) as! BleoShowViesModCell
        if viewsData.count > index {
            cell.BleoConfigure(data: viewsData[index])
        }
        return cell
    }
}

class BleoShowViesModCell: UICollectionViewCell {
    
    var showView: UIView = UIView()
    
    var showText: UILabel = UILabel()
    
    var showImage: UIImageView = UIImageView()
    
    var showImageView: UIView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        BleoSetShowView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        showText.text = nil
        showImage.image = nil
    }
    
    func BleoConfigure(data: BleoShowViewsCellM) {
        showText.text = data.showViewsText!
        showImage.image = UIImage(named: data.showViewsImage!)
    }
    
    func BleoSetShowView() {
        self.contentView.addSubview(showView)
        showView.addSubview(showText)
        showView.addSubview(showImageView)
        showImageView.addSubview(showImage)
        
        showView.translatesAutoresizingMaskIntoConstraints = false
        showText.translatesAutoresizingMaskIntoConstraints = false
        showImage.translatesAutoresizingMaskIntoConstraints = false
        showImageView.translatesAutoresizingMaskIntoConstraints = false
        
        showImageView.backgroundColor = .white
        showImage.contentMode = .scaleToFill
        showImageView.layer.cornerRadius = 14
        showImageView.layer.masksToBounds = true
        showText.font = UIFont(name: "PingFangSC-Semibold", size: 12)
        showText.textColor = .white
        
        showView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        showImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo((ScreenSize.W - 60) / 3)
        }
        
        showImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        showText.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(showImageView.snp.bottom).offset(7)
        }
    }
}
