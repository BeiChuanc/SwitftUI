import Foundation
import UIKit

class UvooHeadVC: UvooTopVC {
    
    @IBOutlet weak var userHead: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UvooSetHead()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UvooLoadHead()
    }
    
    func UvooSetHead() {
        userHead.layer.cornerRadius = userHead.frame.height / 2
        userHead.layer.masksToBounds = true
    }
    
    func UvooLoadHead() {
        let land = UvooLoginVM.shared.isLand
        if land {
            let meData = UvooUserDefaultsUtils.UvooGetUserInfo()
            guard let imageData = meData?.head else {
                userHead.image = UIImage(named: "UvooHead")
                return }
            let image = UIImage(data: imageData)
            userHead.image = image
        } else {
            userHead.image = UIImage(named: "UvooHead")
        }
        
        let gestureHead = UITapGestureRecognizer(target: self, action: #selector(headOnTap))
        userHead.addGestureRecognizer(gestureHead)
        userHead.isUserInteractionEnabled = true
    }
    
    @objc func headOnTap() {
        NotificationCenter.default.post(name: Notification.Name(UvooNotiName.tab), object: 3)
    }
}

class UvooTextVC: UvooTopVC {
    
    @IBOutlet weak var showLink: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UvooSetLinkView()
    }
    
    func UvooSetLinkView() {
        let loginWithAgree = "By Continuing you agree with %@ & %@."
        
        showLink.text = String(format: loginWithAgree, "Terms of Service", "Privacy Policy")
        if let text = showLink.text {
            let rangeTerms = NSMakeRange(text.distance(str: "Terms of Service"), "Terms of Service".count)
            let rangePrivacy = NSMakeRange(text.distance(str: "Privacy Policy"), "Privacy Policy".count)
            let attributedText = NSMutableAttributedString(string: text)
            attributedText.addAttribute(.link, value: "terms", range: rangeTerms)
            attributedText.addAttribute(.link, value: "privacy", range: rangePrivacy)
            attributedText.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: rangeTerms)
            attributedText.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: rangePrivacy)
            attributedText.addAttribute(.foregroundColor, value: UIColor.white, range: rangeTerms)
            attributedText.addAttribute(.foregroundColor, value: UIColor.white, range: rangePrivacy)
            showLink.attributedText = attributedText
            showLink.textAlignment = .center
            showLink.textColor = UIColor(hex: "#FFFFFF", alpha: 0.5)
            showLink.tintColor = .white
            showLink.delegate = self
        }
    }
}


extension UvooTextVC: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        switch URL.absoluteString {
        case "terms":
            UvooRouteUtils.UvooWebView(url: UvooUrl.term)
            return false
        case "privacy":
            UvooRouteUtils.UvooWebView(url: UvooUrl.privacy)
            return false
        case "eula":
            UvooRouteUtils.UvooWebView(url: UvooUrl.eula)
            return false
        default:
            break
        }
        return true
    }
}
