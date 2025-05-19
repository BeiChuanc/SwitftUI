import UIKit
import SnapKit

class UvooDiyGenDesignVC: UvooTopVC {

    var genModel: UvooLibM?
    
    let genImageBg: [String] = ["tick_de_1", "tick_de_2", "tick_de_3", "tick_de_4"]
    
    @IBOutlet weak var btnGenBack: UIButton!
    
    @IBOutlet weak var btnSaveGen: UIButton!
    
    @IBOutlet weak var genShow: UIImageView!
    
    @IBOutlet weak var showGenStick: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "#FED114")
        UvooSetGenView()
        UvooShowData()
        UvooSetStickImageCons()
    }
    
    func UvooSetGenView() {
        btnGenBack.addTarget(self, action: #selector(previous), for: .touchUpInside)
        btnSaveGen.addTarget(self, action: #selector(UvooSaveGen), for: .touchUpInside)
        showGenStick.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func UvooShowData() {
        guard let genModel = self.genModel else { return }
        genShow.image = UIImage(named: genImageBg[genModel.designId])
        showGenStick.image = genModel.image
    }
    
    func UvooSetStickImageCons() {
        guard let genModel = self.genModel else { return }
        showGenStick.layer.cornerRadius = 10
        showGenStick.layer.masksToBounds = true
        switch genModel.designId {
        case 0:
            showGenStick.snp.makeConstraints { make in
                make.centerY.equalTo(genShow)
                make.leading.equalTo(genShow.snp.leading).offset(85)
                make.width.height.equalTo(45)
            }
            break
        case 1:
            showGenStick.snp.makeConstraints { make in
                make.centerX.equalTo(genShow)
                make.centerY.equalTo(genShow).offset(-30)
                make.width.height.equalTo(102)
            }
            break
        case 2:
            showGenStick.snp.makeConstraints { make in
                make.centerY.equalTo(genShow).offset(-30)
                make.leading.equalTo(genShow.snp.leading).offset(85)
                make.width.height.equalTo(45)
            }
            break
        case 3:
            showGenStick.snp.makeConstraints { make in
                make.centerY.equalTo(genShow).offset(-45)
                make.leading.equalTo(genShow.snp.leading).offset(90)
                make.width.height.equalTo(45)
            }
            break
        default:
            break
        }
    }
    
    @objc func UvooSaveGen() {
        let land = UvooLoginVM.shared.isLand
        if land {
            guard let genModel = self.genModel else { return }
            if let image = genModel.image {
                let count = UvooUserDefaultsUtils.UvooGetUserInfo()!.diy.count + 1
                let genMod = UvooLibM(Id: count, designId: genModel.designId, genId: genModel.genId, imageData: image.jpegData(compressionQuality: 0.8))
                UvooUserDefaultsUtils.UvooUpdateUserInfo { model in
                    model.diy.append(genMod)
                }
            }
            UvooLoadVM.UvooShow(type: .succeed)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
                previous()
            }
        } else {
            UvooRouteUtils.UvooLogin()
        }
    }
}
