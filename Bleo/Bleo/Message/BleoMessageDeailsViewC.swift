import UIKit
import SnapKit

class BleoMessageDeailsViewC: BleoCommonViewC {

    @IBOutlet weak var mesDetailBack: UIButton!
    
    @IBOutlet weak var mesUserName: UILabel!
    
    @IBOutlet weak var mesDetailreport: UIButton!
    
    @IBOutlet weak var viewMesSend: UIView!
    
    @IBOutlet weak var mesSend: UIButton!
    
    @IBOutlet weak var mesInput: UITextField!
    
    @IBOutlet weak var mesShowTable: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BleoSetMesDetailView()
        BleoSetMesTabl()
    }
    
    func BleoSetMesDetailView() {
        
    }
    
    func BleoSetMesTabl() {
        mesShowTable.rowHeight = UITableView.automaticDimension
        mesShowTable.estimatedRowHeight = 44
        mesShowTable.separatorStyle = .none
        mesShowTable.rowHeight = UITableView.automaticDimension
        mesShowTable.showsVerticalScrollIndicator = false
        mesShowTable.showsVerticalScrollIndicator = false
        mesShowTable.register(BleoMesUsersCell.self, forCellReuseIdentifier: "BleoMesUsersCell")
        mesShowTable.dataSource = self
        mesShowTable.delegate = self
    }
    
    func BleoLoadMesList() {
        
    }
}

extension BleoMessageDeailsViewC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        let cell: BleoMesUsersCell = tableView.dequeueReusableCell(withIdentifier: "BleoMesUsersCell", for: indexPath) as! BleoMesUsersCell
        cell.backgroundColor = .clear
        return cell
    }
}

class BleoMesUsersCell: UITableViewCell {
    
    var viewBlubbView: UIView = UIView()
    
    var mesContent: UILabel = UILabel()
    
    var mesUser: UIImageView = UIImageView(image: UIImage(named: "mesrobot"))
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
