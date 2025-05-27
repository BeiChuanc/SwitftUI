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
        comTable.dataSource = self
        comTable.delegate = self
    }
    
    @objc func detailback() {
        BleoPageRoute.backToLevel()
    }
    
    @objc func detailreportTap() {
        
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
        
        if let post = BleoTransData.shared.BleoGetTitle(by: titleModel.tId) {
            var title = post
            title.tCom.append(comModel)
            BleoTransData.shared.BleoUpdateTitle(title)
        }
        
        do {
            inputCom.text = nil
            comTable.reloadData()
        }
    }
}

extension BleoTitleDetailsViewC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        let cell: BleoShowComCell = tableView.dequeueReusableCell(withIdentifier: "BleoShowComCell", for: indexPath) as! BleoShowComCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

class BleoShowComCell: UITableViewCell {
    
    var comHead: UIImageView = UIImageView()
    
    var comtext: UITextView = UITextView()
    
    var comTime: UILabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        BleoSetComView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func BleoSetComView() {
        self.contentView.addSubview(comHead)
        self.contentView.addSubview(comtext)
        self.contentView.addSubview(comTime)
        
        comHead.translatesAutoresizingMaskIntoConstraints = false
        comtext.translatesAutoresizingMaskIntoConstraints = false
        comTime.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.layer.cornerRadius = 26
        self.contentView.layer.masksToBounds = true
        self.contentView.layer.borderColor = UIColor(hex: "#8CE565").cgColor
        self.contentView.layer.borderWidth = 1.5
        
        comHead.layer.cornerRadius = 10
        comHead.layer.masksToBounds = true
        
        comtext.font = UIFont(name: "PingFangSC-Light", size: 12)
        comtext.textColor = .white
        comTime.font = UIFont(name: "PingFangSC-Light", size: 10)
        comTime.textColor = .white
        
        comHead.snp.makeConstraints { make in
            make.size.equalTo(20)
            make.centerY.equalToSuperview()
        }
        
        comTime.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-15)
        }
        
        comtext.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(comHead.snp.trailing).offset(5)
            make.trailing.equalTo(comTime.snp.leading)
        }
    }
}
