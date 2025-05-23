import UIKit
import SnapKit

class BleoAddMaintenanceViewC: BleoCommonViewC {

    @IBOutlet weak var viewPart: UIView!
    
    @IBOutlet weak var viewAdd: UIView!
    
    @IBOutlet weak var topPart: UILabel!
    
    @IBOutlet weak var viewday: UIView!
    
    @IBOutlet weak var maintenancetext: UITextField!
    
    @IBOutlet weak var maintenanceAdd: UIButton!
    
    @IBOutlet weak var medaiMod: UIImageView!
    
    @IBOutlet weak var confirmAdd: UIButton!
    
    @IBOutlet weak var addBack: UIButton!
    
    
    let addMainName: [String] = ["Car Chain Disk", "Car Tray", "Brake", "Tyre", "Chain", "Handlebar"]
    
    let modeName: [String] = ["moddisk", "modcary", "modebarke", "modtyre", "modchain", "modhandleber"]
    
    var addMainBt: [UIButton] = []
    
    var selectMod: [UIImage] = []
    
    let offX: CGFloat = 22
    
    let offY: CGFloat = 20
    
    let modSize: CGFloat = 100
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BleoSetAddMainView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        BleoSetMaintenanceGran()
    }
    
    func BleoSetMaintenanceGran() {
        BleoSetViewBorder(In: viewPart, width: 1.5, colors: [ComposeColor.gradOne.color, ComposeColor.gradTwo.color], cornerRadius: 20)
        BleoSetViewBorder(In: viewAdd, width: 1.5, colors: [ComposeColor.gradOne.color, ComposeColor.gradTwo.color], cornerRadius: 20)
        BleoSetViewBorder(In: viewday, width: 1.5, colors: [ComposeColor.gradOne.color, ComposeColor.gradTwo.color], cornerRadius: 10)
        BleoSetBtGradient(In: confirmAdd, colors: [ComposeColor.gradOne.color, ComposeColor.gradTwo.color])
    }
    
    func BleoSetAddMainView() {
        addBack.addTarget(self, action: #selector(backAdd), for: .touchUpInside)
        maintenanceAdd.addTarget(self, action: #selector(uploadMod), for: .touchUpInside)
        confirmAdd.addTarget(self, action: #selector(addMod), for: .touchUpInside)
        viewPart.backgroundColor = UIColor(hex: ComposeColor.uploadOne.rawValue, alpha: 0.2)
        viewAdd.backgroundColor = UIColor(hex: ComposeColor.uploadOne.rawValue, alpha: 0.2)
        viewday.backgroundColor = UIColor(hex: ComposeColor.uploadOne.rawValue, alpha: 0.2)
        confirmAdd.layer.cornerRadius = confirmAdd.frame.height / 2
        confirmAdd.layer.masksToBounds = true
        maintenancetext.keyboardType = .numberPad
        maintenancetext.delegate = self
        
        medaiMod.layer.cornerRadius = 10
        medaiMod.layer.masksToBounds = true
        
        let placeHodeleView: UIView = UIView()
        viewPart.addSubview(placeHodeleView)
        placeHodeleView.translatesAutoresizingMaskIntoConstraints = false
        
        placeHodeleView.snp.makeConstraints { make in
            make.centerX.equalTo(viewPart)
            make.top.equalTo(topPart.snp.bottom).offset(20)
        }
        
        for index in 0..<6 {
            let contaninMod: UIView = UIView()
            let modImage: UIImageView = UIImageView()
            let modName: UILabel = UILabel()
            let selectMod: UIButton = UIButton(type: .custom)
            
            contaninMod.translatesAutoresizingMaskIntoConstraints = false
            modImage.translatesAutoresizingMaskIntoConstraints = false
            modName.translatesAutoresizingMaskIntoConstraints = false
            selectMod.translatesAutoresizingMaskIntoConstraints = false
            
            selectMod.tag = index
            selectMod.isSelected = false
            selectMod.layer.borderWidth = 4
            selectMod.layer.borderColor = UIColor.clear.cgColor
            selectMod.layer.cornerRadius = 12
            selectMod.layer.masksToBounds = true
            selectMod.isUserInteractionEnabled = true
            selectMod.addTarget(self, action: #selector(selectAddMod), for: .touchUpInside)
            
            modImage.contentMode = .scaleToFill
            modImage.image = UIImage(named: modeName[index])
            modImage.backgroundColor = .white
            modImage.layer.cornerRadius = 12
            modImage.layer.masksToBounds = true
            modName.textColor = .white
            modName.font = UIFont(name: "PingFangSC-Regular", size: 12)
            modName.text = addMainName[index]
            
            addMainBt.append(selectMod)
            
            viewPart.addSubview(contaninMod)
            contaninMod.addSubview(modImage)
            contaninMod.addSubview(modName)
            contaninMod.addSubview(selectMod)
            
            let row = index / 3
            let col = index % 3
            
            var xPos: CGFloat
            if col == 1 {
                xPos = 0
            } else if col == 0 {
                xPos = -(modSize + offX)
            } else {
                xPos = (modSize + offX)
            }
            let yPos = CGFloat(row) * (modSize + offY)
            
            contaninMod.snp.makeConstraints { make in
                        make.size.equalTo(modSize)
                        make.centerX.equalTo(placeHodeleView.snp.centerX).offset(xPos)
                        make.top.equalTo(placeHodeleView.snp.top).offset(yPos)
                    }
            
            modImage.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(10)
                make.centerX.equalToSuperview()
                make.width.height.equalTo(70)
            }
            
            modName.snp.makeConstraints { make in
                make.top.equalTo(modImage.snp.bottom).offset(8)
                make.centerX.equalToSuperview()
            }
            
            selectMod.snp.makeConstraints { make in
                make.edges.equalTo(modImage)
            }
        }
    }
    
    @objc func backAdd() {
        BleoPageRoute.backToLevel()
    }
    
    @objc func selectAddMod(_ sender: UIButton) {
        for bt in addMainBt {
            bt.isSelected = (sender == bt)
            bt.layer.borderColor = bt.isSelected ? UIColor(hex: "#9DF159").cgColor : UIColor.clear.cgColor
        }
        if !selectMod.contains(UIImage(named: modeName[sender.tag])!) {
            selectMod.removeAll()
            selectMod.append(UIImage(named: modeName[sender.tag])!)
            medaiMod.isHidden = false
            maintenanceAdd.isHidden = !medaiMod.isHidden
            medaiMod.image = selectMod[0]
        }
    }
    
    @objc func uploadMod() {
        BleoUploadImage { [self] image in
            selectMod.removeAll()
            selectMod.append(image)
            medaiMod.isHidden = false
            maintenanceAdd.isHidden = !medaiMod.isHidden
            medaiMod.image = selectMod[0]
        }
    }
    
    @objc func addMod() {
        guard let num = maintenancetext.text, !num.isEmpty else { return }
        
        guard !selectMod.isEmpty else {
            
            return }
        
    }
}

extension BleoAddMaintenanceViewC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty {
            return true
        }
        
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        
        return allowedCharacters.isSuperset(of: characterSet)
    }
}
