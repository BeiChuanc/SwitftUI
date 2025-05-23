import Foundation
import UIKit

enum NotificationName: String {
    
    case TAB
    
    case TITLE
    
    case USER
    
    case UPDATE
    
    case MES
    
    case UPLOAD
    
    case NOTICE
}

enum ProtocolLink {
    
    static var TERMLINK: String { return "https://www.freeprivacypolicy.com/live/464f7d68-bd5d-4e9f-b84f-84b4422397ee" }
    
    static var PRIVACYLINK: String { return "https://www.freeprivacypolicy.com/live/acc2a61a-d7c5-4277-9409-672e7505ba7f" }
    
    static var EULALINK: String { return "https://www.freeprivacypolicy.com/live/bbf4ad42-ac33-4f15-935d-3465fe0da797" }
}


enum ScreenSize {
    
    static var W: CGFloat { return UIScreen.main.bounds.width }
    
    static var H: CGFloat { return UIScreen.main.bounds.height }
}

enum ReportType {
    
    case TITLE
    
    case USER
    
    case COMMENT
}

enum ComposeColor: String {
    
    case gradOne = "#9DF159"
    
    case gradTwo = "#32A4A3"
    
    case gradThree = "#52BA8E"
    
    case gradFour = "#85E06A"
    
    case mesBulle = "#8BE566"
    
    case mesInput = "#364046"
    
    case logInput = "#C6C6C6"
    
    case textOne = "#141414"
    
    case textTwo = "#898787"
    
    case textThree = "#676767"
    
    case btOne = "#FFF0AE"
    
    case uploadOne = "#CBCBCB"
    
    var color: UIColor {
        return UIColor(hex: self.rawValue)
    }
}
