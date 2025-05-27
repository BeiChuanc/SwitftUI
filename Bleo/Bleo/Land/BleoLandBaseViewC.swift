import Foundation
import UIKit

class BleoLandBaseViewC: BleoCommonViewC {
    
    @IBOutlet weak var loginLink: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        BleoSetLinkView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        BleoSetViewGradient()
    }
    
    func BleoSetViewGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [ComposeColor.gradFour.color.cgColor, ComposeColor.gradThree.color.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func BleoSetLinkView() {
        let protocolLink = "By Continuing you agree with %@ and %@."
        
        loginLink.text = String(format: protocolLink, "Terms of Service", "Privacy Policy")
        if let text = loginLink.text {
            let termsRange = NSMakeRange(text.distance(str: "Terms of Service"), "Terms of Service".count)
            let privacyRange = NSMakeRange(text.distance(str: "Privacy Policy"), "Privacy Policy".count)
            let attributedText = NSMutableAttributedString(string: text)
            attributedText.addAttribute(.link, value: "terms", range: termsRange)
            attributedText.addAttribute(.link, value: "privacy", range: privacyRange)
            attributedText.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: termsRange)
            attributedText.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: privacyRange)
            attributedText.addAttribute(.foregroundColor, value: UIColor.black, range: termsRange)
            attributedText.addAttribute(.foregroundColor, value: UIColor.black, range: privacyRange)
            loginLink.attributedText = attributedText
            loginLink.textAlignment = .center
            loginLink.textColor = .white
            loginLink.tintColor = ComposeColor.textOne.color
            loginLink.delegate = self
        }
    }
}


extension BleoLandBaseViewC: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        switch URL.absoluteString {
        case "terms":
            BleoPageRoute.BleoWebLink()
            return false
        case "privacy":
            BleoPageRoute.BleoWebLink(link: ProtocolLink.PRIVACYLINK)
            return false
        case "eula":
            BleoPageRoute.BleoWebLink(link: ProtocolLink.EULALINK)
            return false
        default:
            break
        }
        return true
    }
}
