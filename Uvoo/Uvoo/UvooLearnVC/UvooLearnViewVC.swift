import Foundation
import UIKit

class UvooLearnViewVC: UvooHeadVC {
    
    var officeTitle: [UvooPublishM] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        officeTitle = UvooLoginVM.shared.titleList.filter { item in return item.bId == 1006 }
    }
    
    @IBAction func learnTopOntap(_ sender: UIButton) {
        UvooRouteUtils.UvooSetView()
    }
    
    @IBAction func learnOnTapScience(_ sender: UIButton) {
        UvooRouteUtils.UvooShowPopular(select: sender.tag)
    }
    
    @IBAction func learnOnTapVideo(_ sender: UIButton) {
        UvooRouteUtils.UvooPlayerShow(title: officeTitle[sender.tag])
    }
}
