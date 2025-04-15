//
//  PeppyChatDataManager.swift
//  Peppy
//
//  Created by 北川 on 2025/4/10.
//

import Foundation
import SwiftUI

// MARK: 聊天管理器
class PeppyChatDataManager: ObservableObject {
    
    static let shared = PeppyChatDataManager()
    
    let userId = PeppyUserManager.PEPPYCurrentUser().peppyId!
    
    var dazzlFileManagerDoucument = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
}

// MARK: 消息
extension PeppyChatDataManager {
    
    /// 保存消息
    func saveAnimalsChat(colloquist: String, content: PeppyChatMould) {
        let plistURL = dazzlFileManagerDoucument!.appendingPathComponent("Peppy.plist")
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
        let fileURL = dazzlFileManagerDoucument!.appendingPathComponent("Peppy.plist")
        let chats = peppyReadChats(url: fileURL)
        
        guard let userMes = chats["\(userId)"],
              let tarMes = userMes[colId] else { return [] }
        
        return tarMes.compactMap { dict in
            let isM = (dict["isM"] ?? "false").lowercased() == "true"
            let content = dict["c"]?.isEmpty ?? true ? nil : dict["c"]
            
            return PeppyChatMould(c: content ?? "", isMy: isM)
        }
    }
    
    /// 删除指定用户聊天数据
    func peppyDeleteAvaUserChat(uid: Int) {
        let fileURL = dazzlFileManagerDoucument!.appendingPathComponent("Peppy.plist")
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
        } catch {
            print("写入plist文件时出错: \(error)")
        }
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
                print("已删除文件: \(fileURL.path)")
            }
            print("所有 .plist 文件已删除")
        } catch {
            print("操作失败: \(error)")
        }
    }
}
