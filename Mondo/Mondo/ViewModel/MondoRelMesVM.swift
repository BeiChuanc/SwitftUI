//
//  MondoRelease+Message.swift
//  Mondo
//
//  Created by 北川 on 2025/4/29.
//

import Foundation

// MARK: 消息
class MondoRelMesVM: ObservableObject {
    
    static let shared = MondoRelMesVM()
    
    var fileM: URL? {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    }
    
    var userJsonFile: URL? {
        guard let baseUrl = fileM else { return nil }
        return baseUrl.appendingPathComponent("Mondo.json")
    }
    
    var userNowAccId: Int? {
        return MondoCacheVM.MondoAvCurUser().uid
    }
    
    @Published var mesListUser: [MondoerM] = []
}

// MARK: 消息
extension MondoRelMesVM {
    
    /// 保存消息
    func MondoSaveMes(dialogist: String, message: MondoChatM) {
        guard let fileURL = userJsonFile else { return }
        var chats = MondoAvMes(from: fileURL)
        
        let isForMe = message.isForMe?.description ?? "false"
        let mesTime = message.mesTime ?? ""
        let mesContent = message.mesContent ?? ""
        
        let mesDir: [String: String] = ["isM": isForMe, "t": mesTime, "c": mesContent]
        
        guard let userNowAccId = userNowAccId else { return }
        var userData = chats["\(userNowAccId)"] ?? [:]
        var tarMes = userData[dialogist] ?? []
        tarMes.append(mesDir)
        userData[dialogist] = tarMes
        chats["\(userNowAccId)"] = userData
        
        MondoWriteMes(mes: chats, to: fileURL)
    }
    
    /// 读取当前用户指定对话用户消息
    func MondoAvbMes(diaId: String) -> [MondoChatM] {
        guard let fileURL = userJsonFile else { return [] }
        
        let chats = MondoAvMes(from: fileURL)
        guard let userAccId = userNowAccId,
              let userMes = chats["\(userAccId)"],
              let tarMes = userMes[diaId] else {
            print("Failed to get messages for the specified user and interlocutor.")
            return [] }
        
        return tarMes.compactMap { dict in
            MondoCreateChatMFromDict(dict)
        }
    }
    
    /// 获取消息列表
    func MondoAvChatUsers() -> [MondoerM] {
        guard let fileURL = userJsonFile else { return [] }
        let chats = MondoAvMes(from: fileURL)
    
        let users = MondoUserVM.shared.monUsers
        guard let userNowAccId = userNowAccId else { return [] }
        guard let userData = chats["\(userNowAccId)"] else { return [] }
        
        var mesL: [MondoerM] = []
        for uid in Array(userData.keys) {
            if let foundUser = users.first(where: { $0.uid == Int(uid) }) {
                if !mesL.contains(where: { $0.uid == foundUser.uid }) {
                    mesL.append(foundUser)
                }
            }
        }
        mesL = mesL.sorted(by: { $0.uid! < $1.uid! })
        return mesL
    }
    
    /// 获取最新消息 >> id
    func MondoAvLastMes(dialogistId: String) -> MondoChatM? {
        guard let fileURL = userJsonFile else { return nil }
        let chats = MondoAvMes(from: fileURL)
        
        let nowUser = MondoCacheVM.MondoAvCurUser()
        guard let userData = chats["\(nowUser.uid)"] else { return nil }
        
        if let messages = userData[dialogistId], let latestMessageDict = messages.last {
            let isM = (latestMessageDict["isM"] ?? "false").lowercased() == "true"
            let content = latestMessageDict["c"]?.isEmpty ?? true ? nil : latestMessageDict["c"]
            let time = latestMessageDict["t"]?.isEmpty ?? true ? nil : latestMessageDict["t"]
            
            var lastM = MondoChatM()
            lastM.isForMe = isM
            lastM.mesTime = time
            lastM.mesContent = content
            return lastM
        }
        
        return nil
    }
    
    /// 创建实例
    func MondoCreateChatMFromDict(_ dict: [String: String]) -> MondoChatM {
        let isForMe = (dict["isM"] ?? "false").lowercased() == "true"
        let mesTime = dict["t"]
        let mesContent = dict["c"]
        
        var chatM = MondoChatM()
        chatM.isForMe = isForMe
        chatM.mesTime = mesTime
        chatM.mesContent = mesContent
        
        return chatM
    }
    
    /// 删除指定用户聊天数据
    func MondoDelAvMes(uid: Int) {
        guard let fileURL = userJsonFile else { return }
        guard let userNowAccId = userNowAccId else { return }
        var chats = MondoAvMes(from: fileURL)
        chats["\(userNowAccId)"]?[String(uid)] = nil
        MondoWriteMes(mes: chats, to: fileURL)
    }
    
    /// 写入聊天数据
    func MondoWriteMes(mes: [String: [String: [[String: String]]]], to url: URL) {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: mes, options: .prettyPrinted)
            try jsonData.write(to: url)
        } catch { print("Error writing JSON data: \(error)") }
    }
    
    /// 聊天数据
    func MondoAvMes(from url: URL) -> [String: [String: [[String: String]]]] {
        guard FileManager.default.fileExists(atPath: url.path),
              let data = try? Data(contentsOf: url),
              let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: [String: [[String: String]]]] else {
            return [:]
        }
        return json
    }
    
    /// 删除聊天文件
    func MondoDelMesFile() {
        guard let fileURL = userJsonFile, FileManager.default.fileExists(atPath: fileURL.path) else { return }
        do {
            try FileManager.default.removeItem(at: fileURL)
        } catch {}
    }
    
    /// 会话ID
    func MondoGenSid() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        let dateString = formatter.string(from: Date())
        
        let randomString = String((0..<16).compactMap { _ in
            "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789".randomElement()
        })
        
        return "\(dateString)_\(randomString)"
    }
}

// MARK: 发布
extension MondoRelMesVM {
    
    /// 保存媒体
    class func MondoSaveMyM(myM: Data, myFPath: String, myMPath: String) -> URL? {
        guard let fileM = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        
        let docUrl = fileM.appendingPathComponent(myMPath)
        
        try? FileManager.default.createDirectory(at: docUrl, withIntermediateDirectories: true, attributes: nil)
        
        let myfURL = docUrl.appendingPathComponent(myFPath)
        
        try? myM.write(to: myfURL)
        
        return myfURL
    }
    
    /// 媒体个数
    class func MondoAVMedias(myMPath: String) -> Int {
        guard let fileM = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return 0 }
        
        let tarDoc = fileM.appendingPathComponent(myMPath)
        
        var isDir: ObjCBool = false
        
        guard FileManager.default.fileExists(atPath: tarDoc.path, isDirectory: &isDir) else { return 0 }
        
        let cont = try? FileManager.default.contentsOfDirectory(at: tarDoc, includingPropertiesForKeys: [.isDirectoryKey], options: [.skipsHiddenFiles])
        
        return cont!.filter { url in
            do {
                let resVal = try url.resourceValues(forKeys: [.isDirectoryKey])
                return resVal.isDirectory == false
            } catch { return false }
        }.count
    }
    
    /// 删除媒体
    class func MondoDeleteMyM(myMPath: String) {
        guard let fileM = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        let tarDoc = fileM.appendingPathComponent(myMPath)
        do {
            if FileManager.default.fileExists(atPath: tarDoc.path) {
                try FileManager.default.removeItem(at: tarDoc)
            } else {}
        } catch {}
    }
}
