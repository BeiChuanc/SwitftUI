import UIKit

class UvooShowComVC: UvooHeadVC {
    
    @IBOutlet weak var back: UIButton!
    
    @IBOutlet weak var com_title: UILabel!
    
    @IBOutlet weak var com_content: UITextView!
    
    @IBOutlet weak var com_view: UIView!
    
    @IBOutlet weak var com_input: UITextField!
    
    @IBOutlet weak var com_send: UIButton!
    
    @IBOutlet weak var com_table: UITableView!
    
    var comData: UvooPublishM?
    
    let comCell = "UvooCommentCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UvooSetComView()
        UvooSetTablView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = UIColor(hex: "#000000", alpha: 0)
        UvooLoadCom()
    }
    
    func UvooSetComView() {
        com_view.layer.cornerRadius = com_view.frame.height / 2
        com_view.layer.masksToBounds = true
        back.addTarget(self, action: #selector(previousDis), for: .touchUpInside)
        com_send.addTarget(self, action: #selector(comSenOnTap), for: .touchUpInside)
        com_input.leftPadding(10)
    }
    
    func UvooSetTablView() {
        com_table.register(UvooCommentCell.self, forCellReuseIdentifier: comCell)
        com_table.dataSource = self
        com_table.delegate = self
        com_table.backgroundColor = .clear
        com_table.showsVerticalScrollIndicator = false
    }
    
    func UvooLoadCom() {
        guard let comData = comData else { return }
        com_title.text = comData.title
        com_content.text = comData.content
    }
    
    @objc func comSenOnTap() {
        if UvooLoginVM.shared.isLand {
            guard let comData = comData else { return }
            guard let tex = com_input.text, !tex.isEmpty else { com_input.becomeFirstResponder()
                return }
            
            if let post = PostManager.shared.UvooGetPost(by: comData.tId) {
                var title = post
                title.comment.append(tex)
                PostManager.shared.UvooUpdatePost(title)
                com_input.text = nil
                com_table.reloadData()
                NotificationCenter.default.post(name: Notification.Name(UvooNotiName.com), object: nil)
            }
        } else {
            dismiss(animated: false) {
                UvooRouteUtils.UvooLogin()
            }
        }
    }
}

extension UvooShowComVC: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let data = PostManager.shared.UvooGetPost(by: comData!.tId)!.comment
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        let cell: UvooCommentCell = tableView.dequeueReusableCell(withIdentifier: comCell, for: indexPath) as! UvooCommentCell
        let data = PostManager.shared.UvooGetPost(by: comData!.tId)!.comment
        if data.count > index {
            cell.UvooLoadComData(reply: data[index])
            cell.backgroundColor = .clear
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
