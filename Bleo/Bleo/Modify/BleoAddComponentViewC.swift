import UIKit

class BleoAddComponentViewC: BleoCommonViewC {
    
    @IBOutlet weak var addBack: UIButton!
    
    @IBOutlet weak var uoloadView: UIView!
    
    @IBOutlet weak var uploadCom: UIButton!
    
    @IBOutlet weak var uploadImage: UIImageView!
    
    @IBOutlet weak var labNote: UILabel!
    
    @IBOutlet weak var sizeView: UIView!
    
    @IBOutlet weak var weightView: UIView!
    
    @IBOutlet weak var materialView: UIView!
    
    @IBOutlet weak var drivetrainView: UIView!
    
    @IBOutlet weak var timeView: UIView!
    
    @IBOutlet weak var sizeInput: UITextField!
    
    @IBOutlet weak var weightInput: UITextField!
    
    @IBOutlet weak var materialInput: UITextField!
    
    @IBOutlet weak var drivertrainInput: UITextField!
    
    @IBOutlet weak var timeInput: UITextField!
    
    @IBOutlet weak var confirmBt: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BleoSetAddView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        BleoSetGradientView()
    }
    
    func BleoSetGradientView() {
        BleoSetViewBorder(In: uoloadView, width: 1.5, colors: [ComposeColor.gradOne.color, ComposeColor.gradTwo.color], cornerRadius: 20)
        BleoSetViewBorder(In: sizeView, width: 1.5, colors: [ComposeColor.gradOne.color, ComposeColor.gradTwo.color], cornerRadius: 16)
        BleoSetViewBorder(In: weightView, width: 1.5, colors: [ComposeColor.gradOne.color, ComposeColor.gradTwo.color], cornerRadius: 16)
        BleoSetViewBorder(In: materialView, width: 1.5, colors: [ComposeColor.gradOne.color, ComposeColor.gradTwo.color], cornerRadius: 16)
        BleoSetViewBorder(In: drivetrainView, width: 1.5, colors: [ComposeColor.gradOne.color, ComposeColor.gradTwo.color], cornerRadius: 16)
        BleoSetViewBorder(In: timeView, width: 1.5, colors: [ComposeColor.gradOne.color, ComposeColor.gradTwo.color], cornerRadius: 16)
        BleoSetBtGradient(In: confirmBt, colors: [ComposeColor.gradOne.color, ComposeColor.gradTwo.color])
    }
    
    func BleoSetAddView() {
        uoloadView.backgroundColor = UIColor(hex: ComposeColor.uploadOne.rawValue, alpha: 0.2)
        sizeView.backgroundColor = UIColor(hex: ComposeColor.uploadOne.rawValue, alpha: 0.2)
        weightView.backgroundColor = UIColor(hex: ComposeColor.uploadOne.rawValue, alpha: 0.2)
        materialView.backgroundColor = UIColor(hex: ComposeColor.uploadOne.rawValue, alpha: 0.2)
        drivetrainView.backgroundColor = UIColor(hex: ComposeColor.uploadOne.rawValue, alpha: 0.2)
        timeView.backgroundColor = UIColor(hex: ComposeColor.uploadOne.rawValue, alpha: 0.2)
        confirmBt.layer.cornerRadius = confirmBt.frame.height / 2
        confirmBt.layer.masksToBounds = true
        
        addBack.addTarget(self, action: #selector(addback), for: .touchUpInside)
        uploadCom.addTarget(self, action: #selector(uploadComponent), for: .touchUpInside)
        confirmBt.addTarget(self, action: #selector(uploadModify), for: .touchUpInside)
    }
    
    @objc func addback() {
        BleoPageRoute.backToLevel()
    }
    
    @objc func uploadComponent() {
        
    }
    
    @objc func uploadModify() {
        
    }
}
