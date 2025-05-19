import UIKit

class UvooComTitleDetailVC: UvooTopVC {

    @IBOutlet weak var btnTitleBack: UIButton!
    
    @IBOutlet weak var titleContainer: UIView!
    
    @IBOutlet weak var headUser: UIImageView!
    
    @IBOutlet weak var titleTopic: UILabel!
    
    @IBOutlet weak var titleContent: UILabel!
    
    @IBOutlet weak var like_title: UIButton!
    
    @IBOutlet weak var like_text: UILabel!
    
    @IBOutlet weak var comment_title: UIButton!
    
    @IBOutlet weak var comment_text: UILabel!
    
    @IBOutlet weak var btnreport: UIButton!
    
    @IBOutlet weak var textComment: UITextField!
    
    @IBOutlet weak var input_view: UIView!
    
    @IBOutlet weak var comment_send: UIButton!
    
    @IBOutlet weak var comment_tablview: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UvooSetDetailView()
        UvooSetCommentView()
        UvooDetailLoadData()
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
    }
    
    
    func UvooSetCommentView() {
        comment_tablview.register(UvooCommentCell.self, forCellReuseIdentifier: "UvooCommentCell")
        comment_tablview.dataSource = self
        comment_tablview.delegate = self
    }
    
    func UvooDetailLoadData() {
        
    }
    
    @objc func sendComment() {
        guard let text = textComment.text, !text.isEmpty else {
            textComment.becomeFirstResponder()
            return }
        textComment.text = nil
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

extension UvooComTitleDetailVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        return cell
    }
}

