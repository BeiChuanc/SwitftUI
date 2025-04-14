//
//  PeppyUserDataManager.swift
//  Peppy
//
//  Created by 北川 on 2025/4/10.
//

import Foundation
import SwiftUI

// MARK: 用户数据管理器
class PeppyUserDataManager: ObservableObject {
    
    static let shared = PeppyUserDataManager()
    
    let documentsDirectory = FileManager.default.urls(
        for: .documentDirectory,
        in: .userDomainMask
    ).first
    
    @Published var animailList: [PeppyAnimalMould] = []
    
    @Published var myMediaList: [PeppyMyMedia] = []
    
    /// 获取自己媒体 - uid_media目录下数据
    func peppyGetUserMedias() {
        let userMedia = PeppyUserManager.PEPPYGetCurrentDancer()
        myMediaList = userMedia.mediaList!
    }
    
    /// 获取动物
    func peppyGetAnimals() {
        guard let jsonPath = Bundle.main.path(forResource: "AnimalData", ofType: "json") else {
            return }
        if #available(iOS 16.0, *) {
            let data = try? Data(contentsOf: URL(filePath: jsonPath))
            if let dancers = PeppyJsonManager.decode(data: data!, to: [PeppyAnimalMould].self) {
                for dac in dancers {
                    if !animailList.contains(where: { $0.animalId == dac.animalId}) {
                        animailList.append(dac)
                    }
                }
            }
        } else {}
    }
}

extension PeppyUserDataManager {
    
    /// 发布保存媒体
    class func peppySaveMedia(meida: Data, filePath: String, mediaPath: String) throws -> URL {
        guard let document = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first else {
            throw NSError(domain: "FileError", code: 1001, userInfo: [NSLocalizedDescriptionKey: "无法访问文档目录"])
        }
        
        let dirURL = document.appendingPathComponent(mediaPath)
        
        try FileManager.default.createDirectory(
            at: dirURL,
            withIntermediateDirectories: true,
            attributes: nil
        )
        
        let fileURL = dirURL.appendingPathComponent(filePath)
        try meida.write(to: fileURL)
        print("保存的路径为:", fileURL)
        return fileURL
    }
    
    /// 获取媒体文件下的个数
    class func peppyGetMedias(mediaPath: String) throws -> Int {
        guard let document = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first else {
            throw NSError(domain: "FileError", code: 1001, userInfo: [NSLocalizedDescriptionKey: "无法访问文档目录"])
        }
        
        let targetDir = document.appendingPathComponent(mediaPath)
        print("媒体文件目录路径：", targetDir.path)
        
        var isDirectory: ObjCBool = false
        guard FileManager.default.fileExists(atPath: targetDir.path, isDirectory: &isDirectory) else {
            return 0
        }
        
        let contents = try FileManager.default.contentsOfDirectory(
            at: targetDir,
            includingPropertiesForKeys: [.isDirectoryKey],
            options: [.skipsHiddenFiles]
        )
        
        return contents.filter { url in
            do {
                let resourceValues = try url.resourceValues(forKeys: [.isDirectoryKey])
                return resourceValues.isDirectory == false
            } catch {
                return false
            }
        }.count
    }
    
    /// 删除文件及文件下的项目
    class func peppyDeleteMedia(mediaPath: String) {
        guard let documents = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first else { return }
        
        let targetDir = documents.appendingPathComponent(mediaPath)
        print("媒体文件目录路径：", targetDir.path)
        
        let fileManager = FileManager.default
        do {
            if fileManager.fileExists(atPath: targetDir.path) {
                try fileManager.removeItem(at: targetDir)
                print("成功删除目录：\(targetDir.path)")
            } else { print("目标目录不存在：\(targetDir.path)") }
        } catch { print("删除目录时出错：\(error.localizedDescription)") }
    }
    
}
