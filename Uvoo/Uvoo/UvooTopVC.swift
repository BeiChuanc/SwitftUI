import Foundation
import UIKit

class UvooTopVC: UIViewController {
    
    enum UvooUrl {
        
        static var term: String { return "https://www.freeprivacypolicy.com/live/b38a2695-2472-4518-9ac2-8c3771da353c" }
        
        static var privacy: String { return "https://www.freeprivacypolicy.com/live/0db078af-6414-400e-9d67-3a6432e9e21e" }
        
        static var eula: String { return "https://www.freeprivacypolicy.com/live/292770b3-0ac1-45de-8e8e-7ec22792882e" }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
    }
    
    @objc func previous() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func previousDis() {
        dismiss(animated: true)
    }
}
