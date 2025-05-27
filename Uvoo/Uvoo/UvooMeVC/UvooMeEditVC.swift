import UIKit

class UvooMeEditVC: UvooHeadVC {

    @IBOutlet weak var editBack: UIButton!
    
    @IBOutlet weak var upload_head: UIButton!
    
    @IBOutlet weak var inputName: UITextField!
    
    @IBOutlet weak var inputAbout: UITextField!
    
    @IBOutlet weak var save_profile: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UvooSetEdieView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UvooLoadMeData()
    }
    
    override func UvooSetHead() {
        userHead.layer.cornerRadius = userHead.frame.height / 2
        userHead.layer.masksToBounds = true
    }
    
    func UvooSetEdieView() {
        inputName.placeholder = "Input name"
        inputName.leftPadding(10)
        inputName.placeHolderColor(UIColor(hex: "#FFFFFF", alpha: 0.5))
        inputName.layer.cornerRadius = inputName.frame.height / 2
        inputName.layer.masksToBounds = true
        
        inputAbout.placeholder = "Input about"
        inputAbout.leftPadding(10)
        inputAbout.placeHolderColor(UIColor(hex: "#FFFFFF", alpha: 0.5))
        inputAbout.layer.cornerRadius = inputAbout.frame.height / 2
        inputAbout.layer.masksToBounds = true
        
        editBack.addTarget(self, action: #selector(previous), for: .touchUpInside)
        upload_head.addTarget(self, action: #selector(UvooUploadHead), for: .touchUpInside)
        save_profile.addTarget(self, action: #selector(UvooSaveProfile), for: .touchUpInside)
    }
    
    func UvooLoadMeData() {
        let land = UvooLoginVM.shared.isLand
        let meData = UvooUserDefaultsUtils.UvooGetUserInfo()
        if land {
            inputName.text = meData!.name
            inputAbout.text = meData!.about
        }
    }
    
    @objc func UvooUploadHead() {
        let picker = UIImagePickerController()
        picker.delegate = self
        UvooPermissionUtils.UvooCheckLibPermisson(true) { isOpen in
            picker.sourceType = .photoLibrary
            self.present(picker, animated: true)
        }
    }
    
    @objc func UvooSaveProfile() {
        let land = UvooLoginVM.shared.isLand
        if land {
            
            guard let name = inputName.text, !name.isEmpty else {
                inputName.becomeFirstResponder()
                return }
            
            guard let about = inputAbout.text, !about.isEmpty else {
                inputAbout.becomeFirstResponder()
                return }
            
            UvooUserDefaultsUtils.UvooUpdateUserInfo { model in
                model.name = name
                model.about = about
                model.head = userHead.image?.jpegData(compressionQuality: 0.8)
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
                UvooLoadVM.UvooShow(type: .succeed)
                previous()
            }
            
        } else {
            UvooRouteUtils.UvooLogin()
        }
    }
}

extension UvooMeEditVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) { [self] in
            let libImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            userHead.image = libImage
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
