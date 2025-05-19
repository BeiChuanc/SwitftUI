import Foundation
import UIKit
import SnapKit

class UvooCommentCell: UITableViewCell {
    
    var headUser: UIImageView = UIImageView()
    
    var userName: UILabel = UILabel()
    
    var btnlike: UIButton = UIButton(type: .custom)
    
    var comtext: UITextView = UITextView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        UvooSetComView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        headUser.image = nil
        userName.text = nil
        comtext.text = nil
    }
    
    func UvooLoadComData(reply: String) {
        comtext.text = reply
        let meData = UvooUserDefaultsUtils.UvooGetUserInfo()
        userName.text = meData!.name
        guard let imageData = meData?.head else {
            headUser.image = UIImage(named: "UvooHead")
            return }
        let image = UIImage(data: imageData)
        headUser.image = image
    }
    
    func UvooSetComView() {
        self.contentView.addSubview(headUser)
        self.contentView.addSubview(userName)
        self.contentView.addSubview(btnlike)
        self.contentView.addSubview(comtext)
        
        headUser.translatesAutoresizingMaskIntoConstraints = false
        userName.translatesAutoresizingMaskIntoConstraints = false
        btnlike.translatesAutoresizingMaskIntoConstraints = false
        comtext.translatesAutoresizingMaskIntoConstraints = false
        
        btnlike.addTarget(self, action: #selector(likeOnTap), for: .touchUpInside)
        headUser.layer.cornerRadius = 10
        headUser.layer.masksToBounds = true
        headUser.contentMode = .scaleAspectFill
        userName.textColor = .white
        comtext.textColor = .white
        userName.font = UIFont(name: "PingFangSC-Semibold", size: 14)
        comtext.font = UIFont(name: "PingFangSC-Regular", size: 12)
        comtext.backgroundColor = .clear
        comtext.isEditable = false
        
        headUser.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.size.equalTo(20)
        }
        
        btnlike.snp.makeConstraints { make in
            make.centerY.equalTo(headUser)
            make.trailing.equalToSuperview()
            make.size.equalTo(30)
        }
        
        userName.snp.makeConstraints { make in
            make.centerY.equalTo(headUser)
            make.leading.equalTo(headUser.snp.trailing).offset(10)
            make.trailing.equalTo(btnlike.snp.leading).offset(-10)
        }
        
        comtext.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-25)
            make.bottom.equalToSuperview()
            make.top.equalTo(userName.snp.bottom)
        }
    }
    
    @objc func likeOnTap(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
}
