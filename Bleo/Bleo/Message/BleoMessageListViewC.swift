import UIKit
import SnapKit

class BleoMessageListViewC: BleoCommonViewC {

    @IBOutlet weak var mesListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BleoSetMesListTable()
    }
    
    func BleoSetMesListTable() {
        mesListTableView.showsVerticalScrollIndicator = false
        mesListTableView.register(BleoMesListCell.self, forCellReuseIdentifier: "BleoMesListCell")
        mesListTableView.dataSource = self
        mesListTableView.delegate = self
    }
    
    func BleoLoadMesList() {
        
    }
}

extension BleoMessageListViewC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        let cell: BleoMesListCell = tableView.dequeueReusableCell(withIdentifier: "BleoMesListCell", for: indexPath) as! BleoMesListCell
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}


class BleoMesListCell: UITableViewCell {
    
    var headImg: UIImageView = UIImageView()
    
    var userNa: UILabel = UILabel()
    
    var goChat: UIButton = UIButton(type: .custom)
    
    var mesContain: UIView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        BleoSetMesListView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        headImg.image = nil
        userNa.text = nil
    }
    
    func BleoSetMesListView() {
        self.contentView.addSubview(mesContain)
        mesContain.addSubview(headImg)
        mesContain.addSubview(userNa)
        mesContain.addSubview(goChat)
    
        self.contentView.backgroundColor = .clear
        
        headImg.layer.cornerRadius = 39
        headImg.layer.masksToBounds = true
        goChat.layer.cornerRadius = 5
        goChat.layer.masksToBounds = true
        goChat.backgroundColor = UIColor(hex: "#49B493")
        goChat.setTitle("Send", for: .normal)
        goChat.titleLabel?.font = UIFont(name: "PingFangSC-Medium", size: 14)
        goChat.setTitleColor(.white, for: .normal)
        
        mesContain.backgroundColor = UIColor(hex: "#F0FFED")
        mesContain.layer.cornerRadius = 22
        mesContain.layer.masksToBounds = true
        
        mesContain.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        headImg.snp.makeConstraints { make in
            make.size.equalTo(78)
            make.leading.equalToSuperview().offset(5)
            make.centerY.equalToSuperview()
        }
        
        userNa.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(headImg.snp.trailing).offset(13)
            make.trailing.equalToSuperview().offset(-13)
        }
        
        goChat.snp.makeConstraints { make in
            make.height.equalTo(34)
            make.width.equalTo(80)
            make.bottom.equalToSuperview().offset(-8)
            make.trailing.equalToSuperview().offset(-18)
        }
    }
    
    @objc func gochatDetail() {
        
    }
}
