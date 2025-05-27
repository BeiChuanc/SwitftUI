import UIKit
import AVFoundation
import IQKeyboardManager
import SnapKit
import Kingfisher

class BleoPersonalInfoViewC: BleoCommonViewC {

    @IBOutlet weak var me_cover: UIImageView!
    
    @IBOutlet weak var meContain: UIView!
    
    @IBOutlet weak var uploadLibCover: UIButton!
    
    @IBOutlet weak var meSetBt: UIButton!
    
    @IBOutlet weak var blerUsereHead: UIImageView!
    
    @IBOutlet weak var uploadLibHead: UIButton!
    
    @IBOutlet weak var editName: UIButton!
    
    @IBOutlet weak var editNameInput: UITextField!
    
    @IBOutlet weak var aboutView: UIView!
    
    @IBOutlet weak var editAboutText: IQTextView!
    
    @IBOutlet weak var postSelect: UIButton!
    
    @IBOutlet weak var likeSelect: UIButton!
    
    @IBOutlet weak var collectionMediaUser: UICollectionView!
    
    @IBOutlet weak var noMedia: UIImageView!
    
    var userSelectMedia: [UIButton] = []
    
    var userMediaArr: [BleoTitleM] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BeloSetMeUserInfo()
        BleoSetCollectionMedia()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        BleoLoadUserInfo()
    }
    
    func BeloSetMeUserInfo() {
        meContain.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        meContain.layer.cornerRadius = 30
        
        blerUsereHead.layer.cornerRadius = blerUsereHead.frame.height / 2
        blerUsereHead.layer.masksToBounds = true
        blerUsereHead.layer.borderWidth = 4
        blerUsereHead.layer.borderColor = UIColor.white.cgColor
        
        aboutView.layer.cornerRadius = 10
        aboutView.layer.masksToBounds =  true
        aboutView.layer.borderWidth = 1
        aboutView.layer.borderColor = UIColor(hex: "#000000", alpha: 0.07).cgColor
        
        meSetBt.addTarget(self, action: #selector(goSettingView), for: .touchUpInside)
        
        userSelectMedia = [postSelect, likeSelect]
        for bt in userSelectMedia {
            bt.addTarget(self, action: #selector(updateMedia), for: .touchUpInside)
        }
        updateMedia(postSelect)
        uploadLibHead.addTarget(self, action: #selector(uploadHead), for: .touchUpInside)
        uploadLibCover.addTarget(self, action: #selector(uploadCover), for: .touchUpInside)
    }
    
    func BleoSetCollectionMedia() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let width = (ScreenSize.W - 60) / 3
        let height = width
        layout.itemSize = CGSize(width: width, height: height)
        collectionMediaUser.collectionViewLayout = layout
        collectionMediaUser.clipsToBounds = true
        collectionMediaUser.backgroundColor = .clear
        collectionMediaUser.showsVerticalScrollIndicator = false
        collectionMediaUser.register(BleoUserMediaCell.self, forCellWithReuseIdentifier: "BleoUserMediaCell")
        collectionMediaUser.dataSource = self
        collectionMediaUser.delegate = self
    }
    
    func BleoLoadUserInfo() {
        if isLogin {
            guard let coverData = userMy.cover else {
                me_cover.image = UIImage(named: "me_bg")
                return }
            let cover = UIImage(data: coverData)
            me_cover.image = cover
            
            guard let headData = userMy.cover else {
                blerUsereHead.image = UIImage(named: "bleoUser")
                return }
            let head = UIImage(data: headData)
            blerUsereHead.image = head
            userMediaArr = userMy.post
        } else {
            me_cover.image = UIImage(named: "me_bg")
            blerUsereHead.image = UIImage(named: "bleoUser")
            userMediaArr.removeAll()
        }
    }
    
    @objc func updateMedia(_ sender: UIButton) {
        userMediaArr.removeAll()
        for bt in userSelectMedia {
            bt.setTitleColor(sender == bt ? UIColor.black : UIColor(hex: "#000000", alpha: 0.53), for: .normal)
            if isLogin {
                if bt == likeSelect {
                    for like in BleoTransData.shared.titleArr {
                        if userMy.likePost.contains(like.tId), !userMediaArr.contains(where: { $0.tId == like.tId }) {
                            userMediaArr.append(like)
                        }
                    }
                } else if bt == postSelect {
                    for post in userMy.post {
                        if !userMediaArr.contains(where: { $0.tId == post.tId }) {
                            userMediaArr.append(post)
                        }
                    }
                } else {
                    userMediaArr.removeAll()
                }
            } else {
                userMediaArr.removeAll()
            }
        }
        noMedia.isHidden = !userMediaArr.isEmpty
    }
    
    @objc func goSettingView() {
        BleoPageRoute.BleoSetttingView()
    }
    
    @objc func uploadCover() {
        BleoUploadImage { [self] image in
            me_cover.image = image
            userMy.cover = image.jpegData(compressionQuality: 0.8)
        }
    }
    
    @objc func uploadHead() {
        
    }
}

extension BleoPersonalInfoViewC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userMediaArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let index = indexPath.row
        let cell : BleoUserMediaCell = collectionView.dequeueReusableCell(withReuseIdentifier: "BleoUserMediaCell", for: indexPath) as! BleoUserMediaCell
        if userMediaArr.count > index {
            cell.titleModel = userMediaArr[index]
        }
        return cell
    }
}

class BleoUserMediaCell: UICollectionViewCell {
    
    var mediaCover: UIImageView = UIImageView(image: UIImage(named: "bleo_launch"))
    
    var mediaViews: UILabel = UILabel()
    
    var mediaVimage: UIImageView = UIImageView(image: UIImage(named: "media_views"))
    
    var titleModel: BleoTitleM? {
        didSet {
            BleoLoadData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        BleoSetMediaView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        mediaCover.image = nil
        mediaViews.text = nil
    }
    
    func BleoLoadData() {
        guard let titleModel = self.titleModel else { return }
        mediaCover.image = UIImage(named: titleModel.tCover)
        mediaViews.text = "\(Int.random(in: 0...30))"
        if BleoTransData.shared.isLoginIn {
            let user = BleoPrefence.BleoGetCurUserData()
            if user.uId == titleModel.uId {
                if titleModel.meType {
                    mediaCover.image = BleoVideoCover(title: titleModel)
                } else {
                    mediaCover.kf.setImage(with: URL(string: titleModel.tCover)!)
                }
            }
        }
    }
    
    func BleoSetMediaView() {
        self.contentView.addSubview(mediaCover)
        self.contentView.addSubview(mediaViews)
        self.contentView.addSubview(mediaVimage)
        self.contentView.layer.cornerRadius = 10
        self.contentView.layer.masksToBounds = true
        
        mediaCover.translatesAutoresizingMaskIntoConstraints = false
        mediaViews.translatesAutoresizingMaskIntoConstraints = false
        mediaVimage.translatesAutoresizingMaskIntoConstraints = false
        
        mediaCover.contentMode = .scaleAspectFill
        
        mediaViews.font = UIFont(name: "PingFangSC-Regular", size: 10)
        mediaViews.textColor = .white
        mediaViews.text = "0"
        
        mediaCover.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        mediaViews.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-6)
        }
        
        mediaVimage.snp.makeConstraints { make in
            make.size.equalTo(12)
            make.centerY.equalTo(mediaViews)
            make.trailing.equalTo(mediaViews.snp.leading).offset(-5)
        }
    }
    
    func BleoVideoCover(title: BleoTitleM) -> UIImage? {
        guard title.meType else { return UIImage() }
        
        let userId = BleoPrefence.BleoGetCurUserData().uId
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let mediaURL = documentsURL.appendingPathComponent("BleoMedia\(userId!)/\(title.tId).mp4")
        
        let asset = AVAsset(url: mediaURL)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        
        do {
            let thumbnailTime = CMTimeMake(value: 1, timescale: 60)
            let cgImage = try imageGenerator.copyCGImage(at: thumbnailTime, actualTime: nil)
            return UIImage(cgImage: cgImage)
        } catch {}
        return UIImage()
    }
}
