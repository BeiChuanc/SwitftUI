import UIKit
import IQKeyboardManager

class BleoPublishViewC: BleoCommonViewC {

    @IBOutlet weak var viewMedia: UIView!
    
    @IBOutlet weak var inputContent: IQTextView!
    
    @IBOutlet weak var uploadMid: UIButton!
    
    @IBOutlet weak var confirmBt: UIButton!
    
    @IBOutlet weak var showEulaBt: UIButton!
    
    @IBOutlet weak var showMedia: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BleoSetPublishVeiw()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        BleoSetViewBorder(In: viewMedia, width: 1.5, colors: [ComposeColor.gradOne.color, ComposeColor.gradTwo.color], cornerRadius: 20)
        BleoSetBtGradient(In: confirmBt, colors: [ComposeColor.gradOne.color, ComposeColor.gradTwo.color])
    }
    
    func BleoSetPublishVeiw() {
        uploadMid.addTarget(self, action: #selector(publishUploadM), for: .touchUpInside)
        confirmBt.addTarget(self, action: #selector(publishConfirm), for: .touchUpInside)
        showEulaBt.addTarget(self, action: #selector(showeula), for: .touchUpInside)
        showMedia.layer.cornerRadius = 10
        showMedia.layer.masksToBounds = true
        viewMedia.backgroundColor = UIColor(hex: ComposeColor.uploadOne.rawValue, alpha: 0.2)
        inputContent.placeholder = "Input Text..."
        inputContent.placeholderTextColor = .white
        confirmBt.layer.cornerRadius = confirmBt.frame.height / 2
        confirmBt.layer.masksToBounds = true
    }
    
    @objc func publishUploadM() {
        BleoUploadMedia {
            
        }
    }
    
    @objc func publishConfirm() {
        
        guard let content = inputContent.text, !content.isEmpty else {
            inputContent.becomeFirstResponder()
            return }
        
        guard isLogin else {
            BleoPageRoute.BleoLoginIn()
            return }
        
        defer {
            inputContent.text = nil
        }
        
        
    }
    
    @objc func showeula() {
        BleoPageRoute.BleoWebLink(link: ProtocolLink.EULALINK)
    }
}

/*
 
 func scrollViewDidScroll(_ scrollView: UIScrollView) {
     let width = scrollView.bounds.width
     let offsetX = scrollView.contentOffset.x
     let currentPage = Int(offsetX / width)
     videoPageControl.currentPage = currentPage
     videoPageControl.numberOfPages = collectionVideo.numberOfItems(inSection: 0) / 3
 }
 
 */
