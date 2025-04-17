import Foundation
import UIKit

// 宽
let peppyW = PEPPYSCREEN.WDITH

// 高
let peppyH = PEPPYSCREEN.HEIGHT

// MARK: 窗口
enum PEPPYSCREEN {
    
    // 宽
    static let WDITH = UIScreen.main.bounds.width
    
    // 高
    static let HEIGHT = UIScreen.main.bounds.height
}

// MARK: 存储
enum PEPPYU: String {
    
    // 用户登陆
    case PLOG
    
    // 登陆账号
    case EMAIL
    
    // 登陆密码
    case PWD
    
    // 个人详情
    case FEATURE
    
    // 当前登陆账号
    case CURRENT
    
    // 当前用户限制礼物
    case ONEGIFT
    
    // 当前用户VIP权限
    case VIPPRIVILEGES
}

// MARK: 协议
enum PEPPYPROTOCOL {
    
    // 技术支持
    static let PEPPYTERMS = "https://www.freeprivacypolicy.com/live/526364de-f809-46c7-9c94-96f33f8a559c"
    
    // 隐私政策
    static let PEPPYPRIVACY = "https://www.freeprivacypolicy.com/live/2e3d0dd0-35b0-499a-86f2-b98db58e1811"
    
    // EULA
    static let PEPPYEULA = "https://www.freeprivacypolicy.com/live/3c61aeb0-88c0-4cb7-95ba-fa6be3205ebd"
}

// MARK: 媒体
enum PEPPYMEDIATYPE: Int, Codable {
    
    // 图片
    case PITURE
    
    // 视频
    case VIDEO
}

// MARK: 展示协议
enum PEPPYPROWINDOW {
    
    // 技术支持
    case PEPPYTERMS
    
    // 隐私政策
    case PEPPYPRIVACY
    
    // EULA
    case PEPPYEULA
}

// MARK: - 路由类型
enum PeppyRoute: Hashable {
    
    // 聊天
    case CHAT(PeppyAnimalMould)
    
    // 登陆
    case LOGIN
    
    // 注册
    case REGISTER
    
    // 选择头像
    case UPLOADHEAD
    
    // 播放
    case PLAYMEDIA(PeppyMyMedia)
    
    // 排行
    case RANKING
}

// MARK: 选择颜色值
enum PeppyColorType: String {
    
    case ONE = "#F54337"
    
    case TWO = "#2196F3"
    
    case THREE = "#FFC208"
    
    case FOUR = "#68BD6C"
}
