import Foundation
import YPImagePicker

// MARK: 公共方法
class PeppyComManager {
    
    /// 获取当前时间: 时:分
    static func peppyCurChat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let currentDate = Date()
        return dateFormatter.string(from: currentDate)
    }
    
    /// 获取当前时间: 年.月.日
    static func peppyCurTimePublish() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        let currentDate = Date()
        return dateFormatter.string(from: currentDate)
    }
    
    /// 生成用户昵称
    static func peppyGrenName(nLen: Int) -> String {
        let peppyCharacter = "abcdefghijklmnopqrstuvwxyz"
        var name = ""
        for _ in 0..<nLen {
            name += String(peppyCharacter.randomElement()!)
        }
        let peppyName = name.prefix(1).uppercased() + name.dropFirst()
        return peppyName
    }
    
    /// 创造用户数据
    static func peppyCreatLoginData(peNam: String, peEma: String, pePwd: String, isApple: Bool = false) {
        PeppyUserManager.PEPPYUaveUserLogin(userAcc: peEma, userPwd: pePwd)
        PeppyUserManager.PEPPYUaveCurrentAcc(userAcc: peEma)
        
        var userId: Int
        userId = isApple ? 1000 : 10011
        let ppeyHead = PeppyLoginManager.shared.loginUser.head ?? "head_1"
        let ppeyHeadColor = PeppyLoginManager.shared.loginUser.head ?? PeppyColorType.ONE.rawValue
        let peppyUser = PeppyLoginMould(peppyId: userId, email: peEma, pwd: pePwd, kickName: peNam, head: ppeyHead, headColor: ppeyHeadColor, culAnimalList: [[1: 32], [2: 24], [3: 26], [4: 30], [5: 28], [6: 31], [7: 37], [8: 38], [9: 32], [10: 29]])
        PeppyUserManager.PEPPYUaveDetailsForCurrent(userAcc: peEma, data: encode(object: peppyUser)!)
        PeppyUserDataManager.peppyDeleteMedia(mediaPath: "\(userId)_publish")
        PeppyChatDataManager.shared.peppyDeleteChatFile()
    }
    
    /// SESSIONID
    static func peppySessionId() -> String {
        let curD = Date()
        let matter = DateFormatter()
        matter.dateFormat = "yyyyMMdd"
        let ymd = matter.string(from: curD)
        
        let chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let length = 16
        var result = ""
        
        for _ in 0..<length {
            if let randomChar = chars.randomElement() {
                result.append(randomChar)
            }
        }
    
        return "\(ymd)_\(result)"
    }
    
    /// 举报
    static func peppyReport(animalId: Int, block: @escaping () -> Void) {
        var reportAlter: UIAlertController!
        reportAlter = UIAlertController(title: "More", message: nil, preferredStyle: .actionSheet)
        
        let report : (UIAlertAction) -> Void = { action in
            block()
        }
        
        let report1 = UIAlertAction(title: "Report Sexually Explicit Material", style: .default,handler: report)
        let report2 = UIAlertAction(title: "Report spam", style: .default,handler: report)
        let report3 = UIAlertAction(title: "Report something else", style: .default,handler: report)
        let report4 = UIAlertAction(title: "Block", style: .default,handler: report)
        let cancel  = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel,handler: nil)
        reportAlter.addAction(report1)
        reportAlter.addAction(report2)
        reportAlter.addAction(report3)
        reportAlter.addAction(report4)
        reportAlter.addAction(cancel)
        reportAlter.modalPresentationStyle = .overFullScreen
        UIViewController.currentViewController()?.present(reportAlter, animated: true, completion: nil)
    }
    
    static func encode<T: Codable>(object: T) -> Data? {
        do {
            let jsonData = try JSONEncoder().encode(object)
            return jsonData
        } catch {
            return nil
        }
    }
    
    static func decode<T: Codable>(data: Data, to type: T.Type) -> T? {
        do {
            let decodedObject = try JSONDecoder().decode(T.self, from: data)
            return decodedObject
        } catch {
            return nil
        }
    }
}
