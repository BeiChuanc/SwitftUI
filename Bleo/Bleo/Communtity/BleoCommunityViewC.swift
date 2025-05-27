import UIKit
import SnapKit

class BleoCommunityViewC: BleoCommonViewC {

    @IBOutlet weak var viewTeach: UIView!
    
    @IBOutlet weak var collectionVideo: UICollectionView!
    
    @IBOutlet weak var collectionTitle: UICollectionView!

    @IBOutlet weak var videoPageControl: UIPageControl!

    var topVideoData: [BleoTitleM] {
        get {
            return BleoTransData.shared.titleArr.filter { item in
                return item.uId == 10000
            }
        }
    }
        
    var pageItems: Int {
        let remainder = topVideoData.count % 3
        if remainder == 0 {
            return topVideoData.count
        } else {
            return topVideoData.count + (3 - remainder)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BleoSetComView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        BleoLoadData()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor(hex: "#89E367").cgColor, UIColor(hex: "#0B6A0B", alpha: 0.21).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: ScreenSize.W - 36, height: 184)
        viewTeach.layer.insertSublayer(gradientLayer, at: 0)
        viewTeach.layer.cornerRadius = 30
        viewTeach.layer.masksToBounds = true
    }
    
    func BleoSetComView() {
        
        videoPageControl.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
        
        videoPageControl.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(30)
            make.height.equalTo(20)
            make.width.equalTo(100)
        }
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: ScreenSize.W - 90, height: (140 - 30) / 3)
        collectionVideo.isPagingEnabled = true
        collectionVideo.collectionViewLayout = layout
        collectionVideo.showsVerticalScrollIndicator = false
        collectionVideo.register(BleoTopVideoCell.self, forCellWithReuseIdentifier: "BleoTopVideoCell")
        collectionVideo.dataSource = self
        collectionVideo.delegate = self
        
        let layout1 = UICollectionViewFlowLayout()
        layout1.scrollDirection = .vertical
        let width = (ScreenSize.W - 50) / 2
        let height = 229.0
        layout1.itemSize = CGSize(width: width, height: height)
        collectionTitle.collectionViewLayout = layout1
        collectionTitle.showsVerticalScrollIndicator = false
        collectionTitle.register(BleoTitleCell.self, forCellWithReuseIdentifier: "BleoTitleCell")
        collectionTitle.dataSource = self
        collectionTitle.delegate = self
    }
    
    func BleoLoadData() {
        BleoTransData.shared.BleoGetTitles()
        let totalItems = collectionView(collectionVideo, numberOfItemsInSection: 0)
        videoPageControl.numberOfPages = (totalItems + 3 - 1) / 3
        collectionVideo.reloadData()
        collectionTitle.reloadData()
    }
}

extension BleoCommunityViewC: UICollectionViewDataSource, UICollectionViewDelegate, TitleFu {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionVideo {
            return pageItems
        } else {
            let titles = BleoTransData.shared.titleArr.filter { item in return item.uId != 10000 }
            return titles.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collectionVideo {
            let index = indexPath.row
            if index < topVideoData.count {
                BleoPageRoute.navigate(BleoTitleDetailsVideoViewC.self, with: topVideoData[index])
            }
        } else {
            let titles = BleoTransData.shared.titleArr.filter { item in return item.uId != 10000 }
            let index = indexPath.row
            if index < titles.count {
                BleoPageRoute.navigate(BleoTitleDetailsViewC.self, with: titles[index])
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionVideo {
            let index = indexPath.row
            let cell : BleoTopVideoCell = collectionView.dequeueReusableCell(withReuseIdentifier: "BleoTopVideoCell", for: indexPath) as! BleoTopVideoCell
            if index < topVideoData.count {
                cell.videoContent.text = topVideoData[index].content
                cell.headImage.image = UIImage(named: topVideoData[index].head)
                cell.videoPlay.isHidden = false
                cell.isHidden = false
                cell.isUserInteractionEnabled = true
            }
            else {
                cell.videoContent.text = nil
                cell.headImage.image = nil
                cell.videoPlay.isHidden = true
                cell.isHidden = true
                cell.isUserInteractionEnabled = false
            }
            return cell
        } else {
            let index = indexPath.row
            let titles = BleoTransData.shared.titleArr.filter { item in return item.uId != 10000 }
            let cell : BleoTitleCell = collectionView.dequeueReusableCell(withReuseIdentifier: "BleoTitleCell", for: indexPath) as! BleoTitleCell
            if index < titles.count {
                cell.titleModel = titles[index]
                cell.delegate = self
            }
            return cell
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == collectionVideo {
            let pageHeight = scrollView.frame.height
            let currentPage = Int(round(scrollView.contentOffset.y / pageHeight))
            videoPageControl.currentPage = min(currentPage, videoPageControl.numberOfPages - 1)
        }
        collectionVideo.reloadData()
    }
    
    func reportTitle(cell: BleoTitleCell) {
        UIAlertController.report(Id: cell.titleModel!.tId) { [self] in
            BleoLoadData()
        }
    }
}

class BleoTopVideoCell: UICollectionViewCell {
    
    var headImage: UIImageView = UIImageView()
    
    var videoContent: UILabel = UILabel()
    
    var videoPlay: UIButton = UIButton(type: .custom)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        BleoSetTopVideo()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        headImage.image = nil
        videoContent.text = nil
    }
    
    func BleoSetTopVideo() {
        self.contentView.addSubview(headImage)
        self.contentView.addSubview(videoContent)
        self.contentView.addSubview(videoPlay)
        
        headImage.translatesAutoresizingMaskIntoConstraints = false
        videoContent.translatesAutoresizingMaskIntoConstraints = false
        videoContent.translatesAutoresizingMaskIntoConstraints = false
        
        videoContent.numberOfLines = 2
        videoContent.font = UIFont(name: "PingFangSC-Medium", size: 12)
        videoContent.textColor = .white
        
        headImage.layer.cornerRadius = 10
        headImage.layer.masksToBounds = true
        headImage.contentMode = .scaleAspectFill
        
        videoPlay.setImage(UIImage(named: "comPlay"), for: .normal)
        videoPlay.addTarget(self, action: #selector(goVideoPlay), for: .touchUpInside)
        
        headImage.snp.makeConstraints { make in
            make.size.equalTo(30)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        videoPlay.snp.makeConstraints { make in
            make.size.equalTo(20)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        videoContent.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(headImage.snp.trailing).offset(18)
            make.trailing.equalTo(videoPlay.snp.leading).offset(-18)
        }
    }
    
    @objc func goVideoPlay() {
        
    }
}

protocol TitleFu {
    func reportTitle(cell: BleoTitleCell)
}

class BleoTitleCell: UICollectionViewCell {
    
    var titleContain: UIView = UIView()
    
    var headImg: UIImageView = UIImageView()
    
    var userName: UILabel = UILabel()
    
    var reportBt: UIButton = UIButton(type: .custom)
    
    var mediaShow: UIImageView = UIImageView()
    
    var stackBt: UIStackView = UIStackView()
    
    var likeBt: UIButton = UIButton(type: .custom)
    
    var comBt: UIButton = UIButton(type: .custom)
    
    var contentContain: UIView = UIView()
    
    var contantMes: UILabel = UILabel()
    
    var delegate: TitleFu?
    
    var titleModel: BleoTitleM? {
        didSet {
            BleoLoadData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        BleoSetTitleView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        headImg.image = nil
        userName.text = nil
        mediaShow.image = nil
        contantMes.text = nil
    }
    
    func BleoSetTitleView() {
        self.contentView.addSubview(titleContain)
        titleContain.addSubview(headImg)
        titleContain.addSubview(userName)
        titleContain.addSubview(reportBt)
        titleContain.addSubview(mediaShow)
        titleContain.addSubview(stackBt)
        titleContain.addSubview(likeBt)
        titleContain.addSubview(comBt)
        titleContain.addSubview(contentContain)
        contentContain.addSubview(contantMes)
        
        titleContain.translatesAutoresizingMaskIntoConstraints = false
        headImg.translatesAutoresizingMaskIntoConstraints = false
        userName.translatesAutoresizingMaskIntoConstraints = false
        reportBt.translatesAutoresizingMaskIntoConstraints = false
        mediaShow.translatesAutoresizingMaskIntoConstraints = false
        stackBt.translatesAutoresizingMaskIntoConstraints = false
        likeBt.translatesAutoresizingMaskIntoConstraints = false
        comBt.translatesAutoresizingMaskIntoConstraints = false
        contentContain.translatesAutoresizingMaskIntoConstraints = false
        contantMes.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.backgroundColor = UIColor(hex: "#2A2E2C")
        self.contentView.layer.cornerRadius = 20
        self.contentView.layer.masksToBounds = true
        
        headImg.contentMode = .scaleAspectFill
        headImg.layer.cornerRadius = 10
        headImg.layer.masksToBounds = true
        
        userName.font = UIFont(name: "PingFangSC-Medium", size: 12)
        userName.textColor = .white
        
        contantMes.font = UIFont(name: "PingFangSC-Regular", size: 12)
        contantMes.textColor = .white
        contantMes.numberOfLines = 2
        
        reportBt.setImage(UIImage(named: "titlereport"), for: .normal)
        reportBt.addTarget(self, action: #selector(reportTap), for: .touchUpInside)
        
        mediaShow.contentMode = .scaleAspectFill
        mediaShow.layer.cornerRadius = 20
        mediaShow.layer.masksToBounds = true
        
        stackBt.axis = .vertical
        stackBt.spacing = 8
        stackBt.addArrangedSubview(likeBt)
        stackBt.addArrangedSubview(comBt)
        
        likeBt.setImage(UIImage(named: "titleLike"), for: .normal)
        likeBt.setImage(UIImage(named: "titleLike_select"), for: .selected)
        comBt.setImage(UIImage(named: "titlecom"), for: .normal)
        likeBt.addTarget(self, action: #selector(likeTap), for: .touchUpInside)
        comBt.addTarget(self, action: #selector(comTap), for: .touchUpInside)
        reportBt.addTarget(self, action: #selector(reportTap), for: .touchUpInside)
        
        contentContain.backgroundColor = UIColor(hex: "#0000000", alpha: 0.4)
        contentContain.layer.cornerRadius = 18.5
        contentContain.layer.masksToBounds = true

        titleContain.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        headImg.snp.makeConstraints { make in
            make.size.equalTo(30)
            make.top.leading.equalToSuperview().offset(10)
        }
        
        reportBt.snp.makeConstraints { make in
            make.centerY.equalTo(headImg)
            make.size.equalTo(20)
            make.trailing.equalToSuperview().offset(-10)
        }
        
        userName.snp.makeConstraints { make in
            make.centerY.equalTo(headImg)
            make.leading.equalTo(headImg.snp.trailing).offset(8)
            make.trailing.equalTo(reportBt.snp.leading).offset(-10)
        }
        
        mediaShow.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.top.equalTo(headImg.snp.bottom).offset(8)
        }
        
        stackBt.snp.makeConstraints { make in
            make.top.equalTo(mediaShow.snp.top).offset(10)
            make.trailing.equalTo(mediaShow.snp.trailing).offset(-10)
        }
        
        likeBt.snp.makeConstraints { make in
            make.size.equalTo(20)
        }
        
        comBt.snp.makeConstraints { make in
            make.size.equalTo(20)
        }
        
        contentContain.snp.makeConstraints { make in
            make.height.equalTo(37)
            make.leading.equalToSuperview().offset(10)
            make.trailing.bottom.equalToSuperview().offset(-10)
        }
        
        contantMes.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(13)
            make.trailing.equalToSuperview().offset(-13)
            make.top.equalToSuperview().offset(6)
            make.bottom.equalToSuperview().offset(-6)
        }
    }
    
    func BleoLoadData() {
        guard let model = self.titleModel else { return }
        headImg.image = UIImage(named: model.head)
        userName.text = model.name
        mediaShow.image = UIImage(named: model.tCover)
        contantMes.text = model.content
    }
    
    @objc func likeTap(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @objc func comTap() {
        guard let model = self.titleModel else { return }
        BleoPageRoute.navigate(BleoTitleDetailsViewC.self, with: model)
    }
    
    @objc func reportTap() {
        delegate?.reportTitle(cell: self)
    }
}
