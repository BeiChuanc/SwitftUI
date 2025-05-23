import UIKit
import SnapKit

class BleoModifyViewC: BleoCommonViewC {
    
    @IBOutlet weak var noteDat: UILabel!
    
    @IBOutlet weak var addNote: UIButton!
    
    @IBOutlet weak var diaLogView: UIView!
    
    @IBOutlet weak var modComponent: UIImageView!
    
    @IBOutlet weak var showDiaLog: UIButton!
    
    @IBOutlet weak var mineView: UIView!
    
    @IBOutlet weak var uploadcar: UIButton!
    
    @IBOutlet weak var mycarView: UIView!
    
    @IBOutlet weak var mycarImage: UIImageView!
    
    @IBOutlet weak var viewsMod: UIButton!
    
    var dataStack: UIStackView = UIStackView()
    
    var dataTitle: [String] = ["Size", "Weight", "Material", "Drivetrain", "time"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BleoSetMycarView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        BleoSetLayoutViews()
    }
    
    func BleoSetLayoutViews() {
        BleoSetBtGradient(In: addNote, colors: [ComposeColor.gradOne.color, ComposeColor.gradTwo.color])
        addNote.layer.cornerRadius = addNote.frame.height / 2
        addNote.layer.masksToBounds = true
        
        BleoSetBtGradient(In: showDiaLog, colors: [ComposeColor.gradOne.color, ComposeColor.gradTwo.color])
        showDiaLog.layer.cornerRadius = showDiaLog.frame.height / 2
        showDiaLog.layer.masksToBounds = true
        
        BleoSetViewBorder(In: diaLogView, width: 1.5, colors: [ComposeColor.gradOne.color, ComposeColor.gradTwo.color], cornerRadius: 20)
        BleoSetViewBorder(In: mineView, width: 2, colors: [ComposeColor.gradOne.color, ComposeColor.gradTwo.color], cornerRadius: 20)
        BleoSetViewBorder(In: mycarView, width: 2, colors: [ComposeColor.gradOne.color, ComposeColor.gradTwo.color], cornerRadius: 20)
        noteDat.setGradientText(colors: [ComposeColor.gradOne.color, ComposeColor.gradTwo.color])
    }
    
    func BleoSetMycarView() {
        mycarView.addSubview(dataStack)
        dataStack.translatesAutoresizingMaskIntoConstraints = false
        dataStack.axis = .vertical
        dataStack.spacing = 10
        
        addNote.addTarget(self, action: #selector(addNoteDay), for: .touchUpInside)
        uploadcar.addTarget(self, action: #selector(uploadCar), for: .touchUpInside)
        showDiaLog.addTarget(self, action: #selector(showDialog), for: .touchUpInside)
        viewsMod.addTarget(self, action: #selector(viewSMod), for: .touchUpInside)
        
        for index in 0..<5 {
            let view = UIView()
            let labTitle = UILabel()
            let labContent = UILabel()
            view.backgroundColor = .white
            view.layer.cornerRadius = 10
            view.layer.masksToBounds = true
            labTitle.font = UIFont(name: "PingFangSC-Semibold", size: 12)
            labTitle.textColor = ComposeColor.textOne.color
            labTitle.text = dataTitle[index]
            labContent.font = UIFont(name: "PingFangSC-Regular", size: 10)
            labContent.textColor = ComposeColor.textTwo.color
            view.addSubview(labTitle)
            view.addSubview(labContent)
            
            view.snp.makeConstraints { make in
                make.height.equalTo(40)
                make.width.equalTo(80)
            }
            labTitle.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalToSuperview().offset(5)
            }
            labContent.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalTo(labTitle.snp.bottom)
            }
            
            dataStack.addArrangedSubview(view)
        }
        
        dataStack.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(18)
            make.bottom.equalToSuperview().offset(-25)
        }
    }
    
    @objc func uploadCar() {
        BleoPageRoute.BleoUploadCarCom()
    }
    
    @objc func showDialog() {
        
    }
    
    @objc func addNoteDay() {
        BleoPageRoute.BleoAddMain()
    }
    
    @objc func viewSMod() {
        BleoPageRoute.BleoViewsMod()
    }
}


