import Foundation
import UIKit
import SnapKit

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
    
    var comlabel: UILabel = UILabel()
    
    var titleModel: UvooPublishM? {
        didSet {
            UvooSetTitleData()
        }
    }
    
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
        mediaList = title.imags
        
        if land {
            let isLike = meData!.like.contains(where: { $0.tId == title.tId })
            btnLike.isSelected = isLike
            likelabel.text = "\(isLike ? title.likes + 1 : title.likes)"
            
            if title.bId == UvooUserDefaultsUtils.UvooGetUserInfo()!.uId {
                guard let imagedata = meData?.head else { headImage.image = UIImage(named: "UvooHead")
                    return }
                let image = UIImage(data: imagedata)
                headImage.image = image
            }
        }
        setImages()
    }
    
    func UvooSetTitleView() {
        self.contentView.addSubview(containerView)
        self.containerView.addSubview(containerBg)
        self.containerView.addSubview(topView)
        self.topView.addSubview(headImage)
        self.topView.addSubview(usereName)
        self.topView.addSubview(btnShare)
        self.containerView.addSubview(titleLabel)
        self.containerView.addSubview(imageScroll)
        self.imageScroll.addSubview(imageStack)
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
        btnLike.addTarget(self, action: #selector(likeOnTap), for: .touchUpInside)
        btnCom.addTarget(self, action: #selector(comOnTap), for: .touchUpInside)
        detail.addTarget(self, action: #selector(comOnTap), for: .touchUpInside)
        
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
        
        imageScroll.showsHorizontalScrollIndicator = false
        imageStack.axis = .horizontal
        imageStack.spacing = 5
        
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
            make.height.equalTo(138)
            make.top.equalTo(topView.snp.bottom).offset(35)
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
    
    func setImages() {
        for index in 0..<mediaList.count {
            let image = UIImageView()
            image.contentMode = .scaleAspectFill
            image.layer.cornerRadius = 5
            image.layer.masksToBounds = true
            image.image = UIImage(named: mediaList[index])
            imageStack.addArrangedSubview(image)
            image.snp.makeConstraints { make in
                make.width.equalTo(103)
                make.height.equalTo(138)
            }
        }
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
        UvooRouteUtils.UvooShowDetail(model: title)
    }
}
