import UIKit

class UvooComTitleDetailVC: UvooTopVC {

    @IBOutlet weak var btnTitleBack: UIButton!
    
    @IBOutlet weak var titleContainer: UIView!
    
    @IBOutlet weak var nameUser: UILabel!
    
    @IBOutlet weak var userDetails: UIButton!
    
    @IBOutlet weak var headUser: UIImageView!
    
    @IBOutlet weak var titleTopic: UILabel!
    
    @IBOutlet weak var titleContent: UITextView!
    
    @IBOutlet weak var like_title: UIButton!
    
    @IBOutlet weak var like_text: UILabel!
    
    @IBOutlet weak var comment_title: UIButton!
    
    @IBOutlet weak var comment_text: UILabel!
    
    @IBOutlet weak var btnreport: UIButton!
    
    @IBOutlet weak var textComment: UITextField!
    
    @IBOutlet weak var input_view: UIView!
    
    @IBOutlet weak var comment_send: UIButton!
    
    @IBOutlet weak var imgeScroll: UIScrollView!
    
    @IBOutlet weak var comment_tablview: UITableView!
    
    var titleModel: UvooPublishM?
    
    let detailsCom = "UvooCommentCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UvooSetDetailView()
        UvooSetCommentView()
        UvooDetailLoadData()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadComment), name: Notification.Name(UvooNotiName.title), object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func UvooSetDetailView() {
        btnTitleBack.addTarget(self, action: #selector(previous), for: .touchUpInside)
        titleContainer.layer.cornerRadius = 15
        titleContainer.layer.masksToBounds = true
        
        headUser.layer.cornerRadius = 10
        headUser.layer.masksToBounds = true
        
        titleTopic.font = UIFont(name: "PingFangSC-Semibold", size: 12)
        titleContent.font = UIFont(name: "PingFangSC-Regular", size: 12)
        
        input_view.layer.cornerRadius = 15
        input_view.layer.masksToBounds = true
        input_view.layer.borderColor = UIColor(hex: "#E5E5E5").cgColor
        input_view.layer.borderWidth = 1
        
        textComment.leftPadding(10)
        comment_send.addTarget(self, action: #selector(sendComment), for: .touchUpInside)
        like_title.addTarget(self, action: #selector(likeOnTap), for: .touchUpInside)
        btnreport.addTarget(self, action: #selector(reportOnTap), for: .touchUpInside)
        userDetails.addTarget(self, action: #selector(goDetails), for: .touchUpInside)
    }
    
    
    func UvooSetCommentView() {
        comment_tablview.register(UvooCommentCell.self, forCellReuseIdentifier: detailsCom)
        comment_tablview.dataSource = self
        comment_tablview.delegate = self
    }
    
    func UvooDetailLoadData() {
        guard let title = titleModel else { return }
        
        nameUser.text = title.name
        titleTopic.text = title.title
        titleContent.text = title.content
        like_text.text = "\(title.likes)"
        comment_text.text = "\(PostManager.shared.UvooGetPost(by: title.tId)!.comment.count)"
        headUser.image = UIImage(named: title.head)
        
        
        let land = UvooLoginVM.shared.isLand
        if land {
            let meData = UvooUserDefaultsUtils.UvooGetUserInfo()
            let isLike = meData!.like.contains(where: { $0.tId == title.tId })
            like_title.isSelected = isLike
            like_text.text = "\(isLike ? title.likes + 1 : title.likes)"
            
            if title.bId == meData!.uId {
                btnreport.isHidden = true
            }
        }
        
        let imageStack = UIStackView()
        imageStack.axis = .horizontal
        imageStack.spacing = 5
        imgeScroll.addSubview(imageStack)
        for index in 0..<title.imags.count {
            let image = UIImageView()
            image.contentMode = .scaleAspectFill
            image.layer.cornerRadius = 5
            image.layer.masksToBounds = true
            image.image = UIImage(named: title.imags[index])
            imageStack.addArrangedSubview(image)
            image.snp.makeConstraints { make in
                make.width.equalTo(103)
                make.height.equalTo(138)
            }
            imageStack.snp.makeConstraints { make in
                make.edges.equalTo(imgeScroll)
            }
        }
    }
    
    @objc func reloadComment() {
        guard let title = titleModel else { return }
        textComment.text = "\(PostManager.shared.UvooGetPost(by: title.tId)!.comment.count)"
    }
    
    @objc func sendComment() {
        if UvooLoginVM.shared.isLand {
            guard let title = titleModel else { return }
            guard let text = textComment.text, !text.isEmpty else { textComment.becomeFirstResponder()
                return }
            
            if let post = PostManager.shared.UvooGetPost(by: title.tId) {
                var title = post
                title.comment.append(text)
                PostManager.shared.UvooUpdatePost(title)
                textComment.text = nil
                comment_tablview.reloadData()
                NotificationCenter.default.post(name: Notification.Name(UvooNotiName.com), object: nil)
            }
        } else {
            previous()
            UvooRouteUtils.UvooLogin()
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
                    like_text.text = "\(title.likes)"
                } else {
                    model.like.append(title)
                    like_text.text = "\(title.likes + 1)"
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
    
    @objc func reportOnTap() {
        guard let title = titleModel else { return }
        UIAlertController.report(Id: title.tId) { [self] in
            previous()
        }
    }
    
    @objc func goDetails() {
        previous()
        guard let title = titleModel else {
            return }
        let user = UvooLoginVM.shared.userOnline.filter { item in return item.uId == title.bId }
        UvooRouteUtils.UvooUserInfo(user: user.first!)
    }
}

extension UvooComTitleDetailVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let data = PostManager.shared.UvooGetPost(by: titleModel!.tId)!.comment
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        let cell: UvooCommentCell = tableView.dequeueReusableCell(withIdentifier: detailsCom, for: indexPath) as! UvooCommentCell
        let data = PostManager.shared.UvooGetPost(by: titleModel!.tId)!.comment
        if data.count > index {
            cell.UvooLoadComData(reply: data[index])
            cell.backgroundColor = .clear
            cell.userName.textColor = .black
            cell.comtext.textColor = .black
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
