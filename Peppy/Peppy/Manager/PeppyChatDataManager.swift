import Foundation
import SwiftUI

// MARK: 聊天管理器
class PeppyChatDataManager: ObservableObject {
    
    static let shared = PeppyChatDataManager()
    
    let userId = PeppyUserManager.PEPPYCurrentUser().peppyId!
    
    var peppyFileManager = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
}

// MARK: 消息
extension PeppyChatDataManager {
    
    /// 保存消息
    func saveAnimalsChat(colloquist: String, content: PeppyChatMould) {
        guard let fileManager = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let plistURL = fileManager.appendingPathComponent("Peppy.plist")
        var chats = peppyReadChats(url: plistURL)
        let mesDir: [String: String] = ["isM": content.isMy.description, "c": content.c]
        
        var userData = chats["\(userId)"] ?? [:]
        var tarMes = userData[colloquist] ?? []
        tarMes.append(mesDir)
        userData[colloquist] = tarMes
        chats["\(userId)"] = userData

        peppyWriteChats(chats: chats, plistURL: plistURL)
    }
    
    /// 读取当前用户指定对话用户消息
    func peppyAvbUserChat(colId: String) -> [PeppyChatMould] {
        guard let fileManager = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return [] }
        let fileURL = fileManager.appendingPathComponent("Peppy.plist")
        let chats = peppyReadChats(url: fileURL)
        
        guard let userMes = chats["\(userId)"], let tarMes = userMes[colId] else { return [] }
        
        return tarMes.compactMap { dict in
            let isM = (dict["isM"] ?? "false").lowercased() == "true"
            let content = dict["c"]?.isEmpty ?? true ? nil : dict["c"]
            
            return PeppyChatMould(c: content ?? "", isMy: isM)
        }
    }
    
    /// 删除指定用户聊天数据
    func peppyDeleteAvaUserChat(uid: Int) {
        guard let fileManager = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileURL = fileManager.appendingPathComponent("Peppy.plist")
        var chats = peppyReadChats(url: fileURL)
        for (key, _) in chats {
            chats[key]?.removeValue(forKey: "\(uid)")
        }
        peppyWriteChats(chats: chats, plistURL: fileURL)
    }
    
    /// 写入聊天数据
    func peppyWriteChats(chats: [String: [String: [[String: String]]]], plistURL: URL) {
        do {
            let data = try PropertyListSerialization.data(
                fromPropertyList: chats,
                format: .xml,
                options: 0
            )
            try data.write(to: plistURL)
        } catch {}
    }
    
    /// 解锁动物
    func peppyGetMessageList() -> [Int] {
        guard let fileManager = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return [] }
        let fileURL = fileManager.appendingPathComponent("Peppy.plist")
        let chatData = peppyReadChats(url: fileURL)
        guard let userData = chatData["\(userId)"] else { return [] }
        let userIds = userData.keys.compactMap { Int($0) }
        return userIds
    }
    
    /// 聊天数据
    func peppyReadChats(url: URL) -> [String: [String: [[String: String]]]] {
        guard FileManager.default.fileExists(atPath: url.path),
                let data = try? Data(contentsOf: url),
                let plistData = try? PropertyListSerialization.propertyList( from: data, options: .mutableContainersAndLeaves, format: nil)
                as? [String: [String: [[String: String]]]] else {
            return [:]
        }
        return plistData
    }
    
    /// 删除聊天文件
    func peppyDeleteChatFile() {
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: .documentsDirectory, includingPropertiesForKeys: nil)
            let plistFiles = fileURLs.filter { $0.pathExtension == "plist" }
            for fileURL in plistFiles {
                try FileManager.default.removeItem(at: fileURL)
            }
        } catch {}
    }
}
