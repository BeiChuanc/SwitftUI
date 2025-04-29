//
//  ErigoMesVM.swift
//  Erigo
//
//  Created by 北川 on 2025/4/22.
//

import Foundation
import UIKit

// MARK: 消息
class ErigoMesAndPubVM: ObservableObject {
    
    static let shared = ErigoMesAndPubVM()
    
    var fileM: URL? {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    }
    
    var userJsonFile: URL? {
        guard let baseUrl = fileM else { return nil }
        return baseUrl.appendingPathComponent("Erigo.json")
    }
    
    var userNowAccId: Int? {
        return ErigoUserDefaults.ErigoAvNowUser().uerId
    }
    
    @Published var mesListUser: [ErigoEyeUserM] = []
}

// MARK: 消息
extension ErigoMesAndPubVM {
    
    /// 保存消息
    func ErigoSaveMes(dialogist: String, message: ErigoChatM) {
        guard let fileURL = userJsonFile else { return }
        var chats = ErigoAvMes(from: fileURL)
        
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
        
        ErigoWriteMes(mes: chats, to: fileURL)
    }
    
    /// 读取当前用户指定对话用户消息
    func ErigoAvbMes(diaId: String) -> [ErigoChatM] {
        guard let fileURL = userJsonFile else { return [] }
        
        let chats = ErigoAvMes(from: fileURL)
        guard let userAccId = userNowAccId,
              let userMes = chats["\(userAccId)"],
              let tarMes = userMes[diaId] else {
            print("Failed to get messages for the specified user and interlocutor.")
            return [] }
        
        return tarMes.compactMap { dict in
            ErigoCreateChatMFromDict(dict)
        }
    }
    
    /// 获取消息列表
    func ErigoAvChatUsers() -> [ErigoEyeUserM] {
        guard let fileURL = userJsonFile else { return [] }
        let chats = ErigoAvMes(from: fileURL)
        
        let nowUser = ErigoUserDefaults.ErigoAvNowUser()
        let users = ErigoLoginVM.shared.eyeUsers
        guard let userData = chats["\(nowUser.uerId!)"] else { return [] }
        
        var mesL: [ErigoEyeUserM] = []
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
    func ErigoAvLastMes(dialogistId: String) -> ErigoChatM? {
        guard let fileURL = userJsonFile else { return nil }
        let chats = ErigoAvMes(from: fileURL)
        
        let nowUser = ErigoUserDefaults.ErigoAvNowUser()
        guard let userData = chats["\(nowUser.uerId ?? 0)"] else { return nil }
        
        if let messages = userData[dialogistId], let latestMessageDict = messages.last {
            let isM = (latestMessageDict["isM"] ?? "false").lowercased() == "true"
            let content = latestMessageDict["c"]?.isEmpty ?? true ? nil : latestMessageDict["c"]
            let time = latestMessageDict["t"]?.isEmpty ?? true ? nil : latestMessageDict["t"]
            
            var lastM = ErigoChatM()
            lastM.isForMe = isM
            lastM.mesTime = time
            lastM.mesContent = content
            return lastM
        }
        
        return nil
    }
    
    /// 创建实例
    func ErigoCreateChatMFromDict(_ dict: [String: String]) -> ErigoChatM {
        let isForMe = (dict["isM"] ?? "false").lowercased() == "true"
        let mesTime = dict["t"]
        let mesContent = dict["c"]
        
        var chatM = ErigoChatM()
        chatM.isForMe = isForMe
        chatM.mesTime = mesTime
        chatM.mesContent = mesContent
        
        return chatM
    }
    
    /// 删除指定用户聊天数据
    func ErigoDelAvMes(uid: Int) {
        guard let fileURL = userJsonFile else { return }
        guard let userNowAccId = userNowAccId else { return }
        var chats = ErigoAvMes(from: fileURL)
        chats["\(userNowAccId)"]?[String(uid)] = nil
        ErigoWriteMes(mes: chats, to: fileURL)
    }
    
    /// 写入聊天数据
    func ErigoWriteMes(mes: [String: [String: [[String: String]]]], to url: URL) {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: mes, options: .prettyPrinted)
            try jsonData.write(to: url)
        } catch {
            print("Error writing JSON data: \(error)")
        }
    }
    
    /// 聊天数据
    func ErigoAvMes(from url: URL) -> [String: [String: [[String: String]]]] {
        guard FileManager.default.fileExists(atPath: url.path),
              let data = try? Data(contentsOf: url),
              let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: [String: [[String: String]]]] else {
            return [:]
        }
        return json
    }
    
    /// 删除聊天文件
    func ErigoDelMesFile() {
        guard let fileURL = userJsonFile,
              FileManager.default.fileExists(atPath: fileURL.path) else { return }
        do {
            try FileManager.default.removeItem(at: fileURL)
        } catch {}
    }
    
    /// 会话ID
    func ErigoGenSid() -> String {
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
extension ErigoMesAndPubVM {
    
    /// 保存媒体
    class func ErigoSaveMyM(myM: Data, myFPath: String, myMPath: String) -> URL? {
        guard let fileM = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        
        let docUrl = fileM.appendingPathComponent(myMPath)
        
        try? FileManager.default.createDirectory(at: docUrl, withIntermediateDirectories: true, attributes: nil)
        
        let myfURL = docUrl.appendingPathComponent(myFPath)
        
        try? myM.write(to: myfURL)
        
        return myfURL
    }
    
    /// 媒体个数
    class func ErigoAVMedias(myMPath: String) -> Int {
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
    class func ErigoDeleteMyM(myMPath: String) {
        guard let fileM = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        let tarDoc = fileM.appendingPathComponent(myMPath)
        do {
            if FileManager.default.fileExists(atPath: tarDoc.path) {
                try FileManager.default.removeItem(at: tarDoc)
            } else {}
        } catch {}
    }
}

// MARK: 举报
extension ErigoMesAndPubVM {
    
    /// 举报
    class func ErigoShowReport(block: @escaping () -> Void) {
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
}
