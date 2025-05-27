import UIKit
import SnapKit
import PhotosUI

class UvooDiyDesignVC: UvooTopVC {
    
    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var bgScrollView: UIScrollView!
    
    @IBOutlet weak var designShowBg: UIView!
    
    @IBOutlet weak var designTickBg: UIImageView!
    
    @IBOutlet weak var designShowColthe: UIImageView!
    
    @IBOutlet weak var designStick: UIImageView!
    
    @IBOutlet weak var selectButtonView: UIView!
    
    let designBgColor: [UIColor] = [UIColor(hex: "#FED114"), UIColor(hex: "#DDC0FF"), UIColor(hex: "#52F1A7"), UIColor(hex: "#00D0FF")]
    
    let designImageBg: [String] = ["tick_bg_1", "tick_bg_2", "tick_bg_3", "tick_bg_4"]
    
    let showClothe: [String] = ["tick_de_1", "tick_de_2", "tick_de_3", "tick_de_4"]
    
    let stickerList: [String] = ["Sticker_1", "Sticker_2", "Sticker_3", "Sticker_4", "Sticker_5", "Sticker_6", "Sticker_7"]
    
    var selectDeisgn: Int = 0
    
    var stickerButtonList: [UIButton] = []
    
    var currentIndexForButton: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UvooDesignSetView()
        UvooSetButtonView()
        UvooSetStickImageCons()
    }
    
    func UvooDesignSetView() {
        designShowBg.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        designShowBg.layer.cornerRadius = 30
        designShowBg.layer.masksToBounds = true
        designShowBg.backgroundColor = designBgColor[selectDeisgn]
        designTickBg.image = UIImage(named: designImageBg[selectDeisgn])
        designShowColthe.image = UIImage(named: showClothe[selectDeisgn])
        btnBack.addTarget(self, action: #selector(previous), for: .touchUpInside)
        designStick.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func UvooSetStickImageCons() {
        designStick.image = UIImage(named: selectDeisgn == 1 ? "show_big_bg" : "show_de_bg")
        designStick.layer.cornerRadius = 10
        designStick.layer.masksToBounds = true
        switch selectDeisgn {
        case 0:
            designStick.snp.makeConstraints { make in
                make.centerY.equalTo(designShowColthe)
                make.leading.equalTo(designShowColthe.snp.leading).offset(100)
                make.size.equalTo(45)
            }
            break
        case 1:
            designStick.snp.makeConstraints { make in
                make.centerX.equalTo(designShowColthe)
                make.centerY.equalTo(designShowColthe).offset(-30)
                make.size.equalTo(102)
            }
            break
        case 2:
            designStick.snp.makeConstraints { make in
                make.centerY.equalTo(designShowColthe).offset(-30)
                make.leading.equalTo(designShowColthe.snp.leading).offset(100)
                make.size.equalTo(45)
            }
            break
        case 3:
            designStick.snp.makeConstraints { make in
                make.centerY.equalTo(designShowColthe).offset(-40)
                make.leading.equalTo(designShowColthe.snp.leading).offset(110)
                make.size.equalTo(45)
            }
            break
        default:
            break
        }
    }
    
    func UvooSetButtonView() {
        
        let buttonWidth: CGFloat = UvooScreen.width * 0.17
        
        let horizontalSpacing: CGFloat = 20.0
        
        let verticalSpacing: CGFloat = 20.0
        
        let startX: CGFloat = (UvooScreen.width - (4 * buttonWidth + 3 * horizontalSpacing)) / 2
        
        for row in 0..<2 {
            for col in 0..<4 {
                let selectButton = UIButton(type: .custom)
                
                let isLastButton: Bool = (row == 1 && col == 3)
                let imageName: String = isLastButton ? "btnUpSticker" : "Sticker_\(row * 4 + col + 1)"
                
                if let image = UIImage(named: imageName) {
                    selectButton.setImage(image, for: .normal)
                    selectButton.contentMode = .scaleAspectFill
                }
                
                selectButton.tag = row * 4 + col + 1
                selectButton.translatesAutoresizingMaskIntoConstraints = false
                selectButton.backgroundColor = UIColor(hex: "#525252")
                selectButton.layer.cornerRadius = 10
                selectButton.layer.masksToBounds = true
                selectButton.alpha = 1
                
                if isLastButton {
                    selectButton.addTarget(self, action: #selector(lastOnTap), for: .touchUpInside)
                } else {
                    selectButton.addTarget(self, action: #selector(stickOnTap), for: .touchUpInside)
                }
                
                selectButtonView.addSubview(selectButton)
                
                selectButton.snp.makeConstraints { make in
                    make.width.height.equalTo(buttonWidth)
                    
                    if row == 0 && col == 0 {
                        make.top.equalToSuperview().offset(10)
                        make.leading.equalToSuperview().offset(10)
                    } else if col == 0 {
                        let buttonAbove = selectButtonView.viewWithTag((row - 1) * 4 + col + 1) as! UIButton
                        make.top.equalTo(buttonAbove.snp.bottom).offset(verticalSpacing)
                        make.leading.equalToSuperview().offset(10)
                    } else {
                        let previousButton = selectButtonView.viewWithTag(row * 4 + col) as! UIButton
                        make.leading.equalTo(previousButton.snp.trailing).offset(horizontalSpacing)
                        make.top.equalTo(previousButton)
                    }
                }
                
                if !isLastButton {
                    stickerButtonList.append(selectButton)
                }
            }
        }
    }
    
    func UvooUpdateImagePicker() {
        let picker = UIImagePickerController()
        picker.delegate = self
        
        UvooPermissionUtils.UvooCheckLibPermisson(true) { isOpen in
            picker.sourceType = .photoLibrary
            self.present(picker, animated: true)
        }
    }
    
    
    func UvooUpdate(index: Int) {
        let imageName = "Sticker_\(index)"
        if let image = UIImage(named: imageName) {
            designStick.image = image
        }
    }
    
    @objc func stickOnTap(_ sender: UIButton) {
        for bt in stickerButtonList {
            bt.isSelected = (bt == sender)
            bt.layer.borderColor = (bt == sender) ? UIColor(hex: "#FED114").cgColor : UIColor.clear.cgColor
            bt.layer.borderWidth = 4
        }
        currentIndexForButton = sender.tag
        UvooUpdate(index: sender.tag)
    }
    
    @objc func lastOnTap(_ sender: UIButton) {
        UvooUpdateImagePicker()
    }
    
    @IBAction func designOnTap(_ sender: UIButton) {
        if let image = designStick.image {
            let genModel = UvooLibM(designId: selectDeisgn,
                                    genId: currentIndexForButton == 0 ? 0 : currentIndexForButton - 1 , imageData: image.jpegData(compressionQuality: 0.8))
            UvooRouteUtils.UvooGenShow(genModel: genModel)
        }
    }
}

extension UvooDiyDesignVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) { [self] in
            let libImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            for bt in stickerButtonList {
                bt.isSelected = false
                bt.layer.borderColor = UIColor.clear.cgColor
                bt.layer.borderWidth = 4
            }
            currentIndexForButton = 0
            designStick.image = libImage
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
