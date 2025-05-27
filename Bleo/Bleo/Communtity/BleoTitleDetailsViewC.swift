import UIKit

class BleoTitleDetailsViewC: BleoCommonViewC, Routable {
    
    typealias Model = BleoTitleM
    
    var titleModel: BleoTitleM?
    
    var comArr: [BleoCommentM] = []

    @IBOutlet weak var detailBack: UIButton!
    
    @IBOutlet weak var titlereport: UIButton!
    
    @IBOutlet weak var detilasShow: UIImageView!
    
    @IBOutlet weak var userView: UIView!
        
    @IBOutlet weak var userHead: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var chatdetilaBt: UIButton!
    
    @IBOutlet weak var likedetilsBt: UIButton!
    
    @IBOutlet weak var detailContent: UITextView!
    
    @IBOutlet weak var comTable: UITableView!
    
    @IBOutlet weak var viewComment: UIView!
    
    @IBOutlet weak var inputCom: UITextField!
    
    @IBOutlet weak var sendCom: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BleoSetDetailsView()
        BleoSetTabCom()
        BleoLoadData()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        BleoSetViewBorder(In: userView, width: 1.5, colors: [ComposeColor.gradOne.color, ComposeColor.gradTwo.color], cornerRadius: 15)
    }
    
    func configure(with model: BleoTitleM) {
        titleModel = model
    }
    
    func BleoLoadData() {
        guard let titleModel = self.titleModel else { return }
        comArr = titleModel.tCom
        detilasShow.image = UIImage(named: titleModel.tCover)
        userHead.image = UIImage(named: titleModel.head)
        userName.text = titleModel.name
        detailContent.text = titleModel.content
        comArr = BleoTransData.shared.BleoGetTitle(by: titleModel.tId)!.tCom
        comTable.scrollToRow(at: IndexPath(row: (comArr.count - 1), section: 0), at: .bottom, animated: true)
    }
    
    func BleoSetDetailsView() {
        detilasShow.layer.cornerRadius = 15
        detilasShow.layer.masksToBounds = true
        
        userHead.layer.cornerRadius = userHead.frame.height / 2
        userHead.layer.masksToBounds = true
        
        viewComment.layer.cornerRadius = viewComment.frame.height / 2
        viewComment.layer.masksToBounds = true
        inputCom.placeholder = "Enter Text"
        inputCom.placeHolderColor(UIColor(hex: "#FFFFFF", alpha: 0.72))
        
        detailBack.addTarget(self, action: #selector(detailback), for: .touchUpInside)
        titlereport.addTarget(self, action: #selector(detailreportTap), for: .touchUpInside)
        likedetilsBt.addTarget(self, action: #selector(likeTap), for: .touchUpInside)
        chatdetilaBt.addTarget(self, action: #selector(chatTap), for: .touchUpInside)
        sendCom.addTarget(self, action: #selector(sendTapCom), for: .touchUpInside)
    }
    
    func BleoSetTabCom() {
        comTable.register(BleoShowComCell.self, forCellReuseIdentifier: "BleoShowComCell")
        comTable.backgroundColor = .clear
        comTable.showsVerticalScrollIndicator = false
        comTable.dataSource = self
        comTable.delegate = self
    }
    
    @objc func detailback() {
        BleoPageRoute.backToLevel()
    }
    
    @objc func detailreportTap() {
        guard let titleModel = self.titleModel else { return }
        UIAlertController.report(Id: titleModel.tId) {
            BleoTransData.shared.BleoGetTitles()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
                detailback()
            }
        }
    }
    
    @objc func likeTap(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @objc func chatTap() {
        
    }
    
    @objc func sendTapCom() {
        guard let titleModel = self.titleModel else { return }
        guard let text = inputCom.text, !text.isEmpty else {
            inputCom.becomeFirstResponder()
            return }
        
        guard isLogin else {
            BleoPageRoute.backToLevel()
            BleoPageRoute.BleoLoginIn()
            return }
        let comModel = BleoCommentM(cuId: userMy.uId!, chead: "", comment: text, time: BleoGetTimeNow())
        comArr.append(comModel)
        if let post = BleoTransData.shared.BleoGetTitle(by: titleModel.tId) {
            var title = post
            title.tCom.append(comModel)
            BleoTransData.shared.BleoUpdateTitle(title)
        }
        
        do {
            inputCom.text = nil
            comTable.reloadData()
            comTable.scrollToRow(at: IndexPath(row: (comArr.count - 1), section: 0), at: .bottom, animated: true)
        }
    }
}

extension BleoTitleDetailsViewC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        let cell: BleoShowComCell = tableView.dequeueReusableCell(withIdentifier: "BleoShowComCell", for: indexPath) as! BleoShowComCell
        cell.backgroundColor = .clear
        if index < comArr.count {
            cell.comModel = comArr[index]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

class BleoShowComCell: UITableViewCell {
    
    var comContain: UIView = UIView()
    
    var comHead: UIImageView = UIImageView()
    
    var comtext: UITextView = UITextView()
    
    var comTime: UILabel = UILabel()
    
    var comModel: BleoCommentM? {
        didSet {
            BleoLoadCom()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        BleoSetComView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        comHead.image = nil
        comtext.text = nil
        comTime.text = nil
    }
    
    func BleoLoadCom() {
        guard let comModel = self.comModel else { return }
        comtext.text = comModel.comment
        comTime.text = comModel.time
        comHead.image = UIImage(named: comModel.chead)
        if comModel.chead.isEmpty {
            comHead.image = UIImage(named: "bleoUser")
            if BleoTransData.shared.isLoginIn {
                guard let headData = BleoTransData.shared.userMy.head else {
                    comHead.image = UIImage(named: "bleoUser")
                    return }
                let head = UIImage(data: headData)
                comHead.image = head
            }
        }
    }
    
    func BleoSetComView() {
        self.contentView.addSubview(comContain)
        comContain.addSubview(comHead)
        comContain.addSubview(comtext)
        comContain.addSubview(comTime)
        
        comHead.translatesAutoresizingMaskIntoConstraints = false
        comtext.translatesAutoresizingMaskIntoConstraints = false
        comTime.translatesAutoresizingMaskIntoConstraints = false
        
        comContain.layer.cornerRadius = 26
        comContain.layer.masksToBounds = true
        comContain.layer.borderColor = UIColor(hex: "#8CE565").cgColor
        comContain.layer.borderWidth = 1.5
        
        comHead.layer.cornerRadius = 15
        comHead.layer.masksToBounds = true
        
        comtext.font = UIFont(name: "PingFangSC-Light", size: 12)
        comtext.textColor = .white
        comTime.font = UIFont(name: "PingFangSC-Light", size: 10)
        comTime.textColor = .white
        comtext.backgroundColor = .clear
        
        comContain.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.leading.trailing.equalToSuperview()
        }
        
        comHead.snp.makeConstraints { make in
            make.size.equalTo(30)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(15)
        }
        
        comTime.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-15)
        }
        
        comtext.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.top.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().offset(-5)
            make.leading.equalTo(comHead.snp.trailing).offset(5)
            make.trailing.equalTo(comTime.snp.leading)
        }
    }
}
