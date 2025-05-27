import Foundation
import AVFoundation
import UIKit
import SnapKit
import Kingfisher

protocol titleAction {
    func reportTitle(title: UvooPublishM)
    func delTitle(title: UvooPublishM)
}

class UvooShowTitleCell: UICollectionViewCell {
    
    var containerView: UIView = UIView()
    
    var containerBg: UIImageView = UIImageView()
    
    var topView: UIView = UIView()
    
    var headImage: UIImageView = UIImageView()
    
    var usereName: UILabel = UILabel()
    
    var btnShare: UIButton = UIButton(type: .custom)
    
    var titleLabel: UILabel = UILabel()
    
    var mediaList: [String] = []
    
    var imageScroll: UIScrollView = UIScrollView()
    
    var imageStack: UIStackView = UIStackView()
    
    var bottomView: UIView = UIView()
    
    var btnStack: UIStackView = UIStackView()
    
    var likeView: UIView = UIView()
    
    var btnLike: UIButton = UIButton(type: .custom)
    
    var likelabel: UILabel = UILabel()
    
    var comView: UIView = UIView()
    
    var btnCom: UIButton = UIButton(type: .custom)
    
    var detail: UIButton = UIButton(type: .custom)
    
    var meCover: UIImageView = UIImageView()
    
    var comlabel: UILabel = UILabel()
    
    var report: UIButton = UIButton(type: .custom)
    
    var delB: UIButton = UIButton(type: .custom)
    
    var buplay: UIImageView = UIImageView()
    
    var titleModel: UvooPublishM? {
        didSet {
            UvooSetTitleData()
        }
    }
    
    var delegate: titleAction?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        UvooSetTitleView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        headImage.image = nil
        usereName.text = nil
        titleLabel.text = nil
        btnLike.isSelected = false
        likelabel.text = nil
        comlabel.text = nil
        btnLike.isSelected = false
        meCover.image = nil
        report.isHidden = true
        delB.isHidden = true
        buplay.isHidden = true
        mediaList.removeAll()
        for subview in imageStack.arrangedSubviews {
            imageStack.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
    }
    
    func UvooSetTitleData() {
        guard let title = titleModel else { return }
        let land = UvooLoginVM.shared.isLand
        let meData = UvooUserDefaultsUtils.UvooGetUserInfo()
        
        usereName.text = title.name
        titleLabel.text = title.title
        comlabel.text = "\(PostManager.shared.UvooGetPost(by: title.tId)!.comment.count)"
        headImage.image = UIImage(named: title.head)
        likelabel.text = "\(title.likes)"
        mediaList = title.cover
        delB.isHidden = true
        report.isHidden = false
        buplay.isHidden = !title.isVideo
        
        for index in 0..<mediaList.count {
            let image = UIImageView()
            image.contentMode = .scaleAspectFill
            image.layer.cornerRadius = 5
            image.layer.masksToBounds = true
            image.image = UIImage(named: mediaList[index])
            imageStack.addArrangedSubview(image)
            image.snp.makeConstraints { make in
                if mediaList.count == 1 {
                    make.width.equalTo(UvooScreen.width - 62)
                } else {
                    make.width.equalTo(UvooScreen.width * 0.75 * 0.26)
                }
                make.height.equalTo(UvooScreen.width * 0.75 * 0.38)
            }
        }
        
        if land {
            let isLike = meData!.like.contains(where: { $0.tId == title.tId })
            btnLike.isSelected = isLike
            likelabel.text = "\(isLike ? title.likes + 1 : title.likes)"
            
            if title.bId == UvooUserDefaultsUtils.UvooGetUserInfo()!.uId {
                if title.isVideo {
                    meCover.image = UvooGetVideoCover(title: title)
                } else {
                    meCover.kf.setImage(with: URL(string: mediaList[0])!)
                }
                meCover.isHidden = false
                report.isHidden = true
                delB.isHidden = false
                guard let imagedata = meData?.head else { headImage.image = UIImage(named: "UvooHead")
                    return }
                let image = UIImage(data: imagedata)
                headImage.image = image
            }
        }
    }
    
    func UvooSetTitleView() {
        self.contentView.addSubview(containerView)
        self.containerView.addSubview(containerBg)
        self.containerView.addSubview(topView)
        self.topView.addSubview(headImage)
        self.topView.addSubview(usereName)
        self.topView.addSubview(btnShare)
        self.topView.addSubview(report)
        self.topView.addSubview(delB)
        self.containerView.addSubview(titleLabel)
        self.containerView.addSubview(imageScroll)
        self.containerView.addSubview(meCover)
        self.imageScroll.addSubview(imageStack)
        self.imageScroll.addSubview(buplay)
        self.containerView.addSubview(bottomView)
        self.bottomView.addSubview(btnStack)
        self.bottomView.addSubview(likeView)
        self.likeView.addSubview(btnLike)
        self.likeView.addSubview(likelabel)
        self.bottomView.addSubview(comView)
        self.comView.addSubview(btnCom)
        self.comView.addSubview(comlabel)
        self.contentView.addSubview(detail)
        
        self.contentView.layer.cornerRadius = 15
        self.contentView.layer.masksToBounds = true
        
        topView.backgroundColor = .clear
        containerBg.image = UIImage(named: "title_bg")
        containerBg.contentMode = .scaleAspectFill
        headImage.layer.cornerRadius = 10
        headImage.layer.masksToBounds = true
        headImage.contentMode = .scaleAspectFill
        usereName.numberOfLines = 1
        titleLabel.numberOfLines = 1
        btnStack.addArrangedSubview(likeView)
        btnStack.addArrangedSubview(comView)
        btnStack.spacing = 20
        bottomView.backgroundColor = .white
        likelabel.textColor = UIColor(hex: "#4D4D4D")
        likelabel.font = UIFont(name: "PingFangSC-Regular", size: 12)
        comlabel.font = UIFont(name: "PingFangSC-Regular", size: 12)
        comlabel.textColor = UIColor(hex: "#4D4D4D")
        usereName.font = UIFont(name: "Arial-ItalicMT", size: 14)

        btnLike.setImage(UIImage(named: "like_media_normal"), for: .normal)
        btnLike.setImage(UIImage(named: "like_media_select"), for: .selected)
        btnCom.setImage(UIImage(named: "comment_media"), for: .normal)
        report.setImage(UIImage(named: "reprot_btn"), for: .normal)
        delB.setImage(UIImage(named: "del_dis"), for: .normal)
        meCover.contentMode = .scaleAspectFill
        meCover.layer.cornerRadius = 5
        meCover.layer.masksToBounds = true
        meCover.isHidden = true
        btnLike.addTarget(self, action: #selector(likeOnTap), for: .touchUpInside)
        btnCom.addTarget(self, action: #selector(comOnTap), for: .touchUpInside)
        detail.addTarget(self, action: #selector(comOnTap), for: .touchUpInside)
        report.addTarget(self, action: #selector(reportTitleOnTap), for: .touchUpInside)
        delB.addTarget(self, action: #selector(delTitleOnTap), for: .touchUpInside)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerBg.translatesAutoresizingMaskIntoConstraints = false
        topView.translatesAutoresizingMaskIntoConstraints = false
        headImage.translatesAutoresizingMaskIntoConstraints = false
        usereName.translatesAutoresizingMaskIntoConstraints = false
        btnShare.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        imageScroll.translatesAutoresizingMaskIntoConstraints = false
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        btnStack.translatesAutoresizingMaskIntoConstraints = false
        likeView.translatesAutoresizingMaskIntoConstraints = false
        btnLike.translatesAutoresizingMaskIntoConstraints = false
        likelabel.translatesAutoresizingMaskIntoConstraints = false
        comView.translatesAutoresizingMaskIntoConstraints = false
        btnCom.translatesAutoresizingMaskIntoConstraints = false
        comlabel.translatesAutoresizingMaskIntoConstraints = false
        imageStack.translatesAutoresizingMaskIntoConstraints = false
        meCover.translatesAutoresizingMaskIntoConstraints = false
        buplay.translatesAutoresizingMaskIntoConstraints = false
        
        imageScroll.showsHorizontalScrollIndicator = false
        imageStack.axis = .horizontal
        imageStack.spacing = 5
        buplay.image = UIImage(named: "player_play")
        buplay.isHidden = true
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        containerBg.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-40)
        }
        
        topView.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.leading.equalToSuperview().offset(15)
            make.top.trailing.equalToSuperview()
        }
        
        report.snp.makeConstraints { make in
            make.size.equalTo(30)
            make.centerY.equalTo(headImage)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        delB.snp.makeConstraints { make in
            make.size.equalTo(30)
            make.centerY.equalTo(headImage)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        headImage.snp.makeConstraints { make in
            make.size.equalTo(35)
            make.leading.bottom.equalToSuperview()
        }
        
        usereName.snp.makeConstraints { make in
            make.centerY.equalTo(headImage)
            make.leading.equalTo(headImage.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(100)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        imageScroll.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(UvooScreen.width * 0.75 * 0.38)
            make.top.equalTo(topView.snp.bottom).offset(35)
        }
        
        buplay.snp.makeConstraints { make in
            make.center.equalTo(imageScroll)
        }
        
        meCover.snp.makeConstraints { make in
            make.edges.equalTo(imageScroll.snp.edges)
        }
        
        imageStack.snp.makeConstraints { make in
            make.edges.equalTo(imageScroll)
        }
        
        detail.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(topView.snp.bottom)
            make.bottom.equalTo(bottomView.snp.top)
        }
        
        bottomView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(60)
        }
        
        likeView.snp.makeConstraints { make in
            make.width.equalTo(50)
            make.height.equalTo(20)
        }
        
        comView.snp.makeConstraints { make in
            make.width.equalTo(50)
            make.height.equalTo(20)
        }
        
        btnLike.snp.makeConstraints { make in
            make.size.equalTo(30)
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        likelabel.snp.makeConstraints { make in
            make.leading.equalTo(btnLike.snp.trailing)
            make.centerY.equalToSuperview()
        }
        
        btnCom.snp.makeConstraints { make in
            make.size.equalTo(30)
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        comlabel.snp.makeConstraints { make in
            make.leading.equalTo(btnCom.snp.trailing)
            make.centerY.equalToSuperview()
        }
        
        btnStack.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
        }
    }
    
    func UvooGetVideoCover(title: UvooPublishM) -> UIImage? {
        guard title.isVideo else { return UIImage() }
        
        let userId = UvooUserDefaultsUtils.UvooGetUserInfo()!.uId
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let mediaURL = documentsURL.appendingPathComponent("Uvoo\(userId)/\(title.tId).mp4")
        
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
    
    @objc func likeOnTap(_ sender: UIButton) {
        let land = UvooLoginVM.shared.isLand
        if land {
            guard let title = titleModel else { return }
            sender.isSelected = !sender.isSelected
            
            UvooUserDefaultsUtils.UvooUpdateUserInfo { model in
                if model.like.contains(where: { $0.tId == title.tId }) {
                    model.like.removeAll(where: { $0.tId == title.tId })
                    likelabel.text = "\(title.likes)"
                } else {
                    model.like.append(title)
                    likelabel.text = "\(title.likes + 1)"
                }
            }
            
            UIView.animate(withDuration: 0.25, animations: {
                sender.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            }) { _ in
                UIView.animate(withDuration: 0.25) {
                    sender.transform = .identity
                }
            }
        } else {
            UvooRouteUtils.UvooLogin()
        }
    }
    
    @objc func comOnTap() {
        guard let title = titleModel else { return }
        if title.isVideo {
            let land = UvooLoginVM.shared.isLand
            if land {
                let meData = UvooUserDefaultsUtils.UvooGetUserInfo()
                UvooRouteUtils.UvooPlayerShow(title: title, isMe: title.bId == meData!.uId)
                return
            }
            UvooRouteUtils.UvooPlayerShow(title: title, isMe: false)
            return
        }
        UvooRouteUtils.UvooShowDetail(model: title)
    }
    
    @objc func reportTitleOnTap() {
        guard let title = titleModel else { return }
        delegate?.reportTitle(title: title)
    }
    
    @objc func delTitleOnTap() {
        guard let title = titleModel else { return }
        delegate?.delTitle(title: title)
    }
}
