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
    
    var bottomView: UIView = UIView()
    
    var btnStack: UIStackView = UIStackView()
    
    var likeView: UIView = UIView()
    
    var btnLike: UIButton = UIButton(type: .custom)
    
    var likelabel: UILabel = UILabel()
    
    var comView: UIView = UIView()
    
    var btnCom: UIButton = UIButton(type: .custom)
    
    var comlabel: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        UvooSetTitleData()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        headImage.image = nil
        usereName.text = nil
        titleLabel.text = nil
        mediaList.removeAll()
        btnLike.isSelected = false
        likelabel.text = nil
        comlabel.text = nil
    }
    
    func UvooSetTitleData() {
        
        UvooSetTitleView()
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
        self.containerView.addSubview(bottomView)
        self.bottomView.addSubview(btnStack)
        self.bottomView.addSubview(likeView)
        self.likeView.addSubview(btnLike)
        self.likeView.addSubview(likelabel)
        self.bottomView.addSubview(comView)
        self.comView.addSubview(btnCom)
        self.comView.addSubview(comlabel)
        
        self.contentView.layer.cornerRadius = 15
        self.contentView.layer.masksToBounds = true
        
        topView.backgroundColor = .clear
        containerView.backgroundColor = UIColor(hex: "#FED114")
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
        }
        
        bottomView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(42)
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
    
    @objc func likeOnTap(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        UIView.animate(withDuration: 0.25, animations: {
            sender.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }) { _ in
            UIView.animate(withDuration: 0.25) {
                sender.transform = .identity
            }
        }
    }
}
