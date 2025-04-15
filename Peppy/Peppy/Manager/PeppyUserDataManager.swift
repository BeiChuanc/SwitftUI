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
    
    var blockAnimals: [Int] = []
    
    @Published var animailList: [PeppyAnimalMould] = []
    
    @Published var myMediaList: [PeppyMyMedia] = []
}

// MARK: 用户 & 动物数据
extension PeppyUserDataManager {
    
    /// 获取自己媒体目录数据
    func peppyGetUserMedias() {
        let userMedia = PeppyUserManager.PEPPYCurrentUser()
        myMediaList = userMedia.mediaList!
    }
    
    /// 获取动物数据
    func peppyGetAnimals() {
        guard let jsonPath = Bundle.main.path(forResource: "AnimalData", ofType: "json") else {
            return }
        let data = try? Data(contentsOf: URL(filePath: jsonPath))
        if let animals = PeppyJsonManager.decode(data: data!, to: [PeppyAnimalMould].self) {
            for dac in animals {
                if !animailList.contains(where: { $0.animalId == dac.animalId}) {
                    animailList.append(dac)
                }
            }
            animailList = animailList.filter { item in
                return !blockAnimals.contains(item.animalId)
            }
        }
    }
}

// MARK: 发布
extension PeppyUserDataManager {
    
    /// 保存媒体到documentDirectory
    class func peppySaveMedia(meida: Data, filePath: String, mediaPath: String) throws -> URL {
        guard let doc = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw NSError(domain: "FileError", code: 1001, userInfo: [NSLocalizedDescriptionKey: "Error read file"])
        }
        
        let dirURL = doc.appendingPathComponent(mediaPath)
        
        try FileManager.default.createDirectory(at: dirURL, withIntermediateDirectories: true, attributes: nil)
        
        let fileURL = dirURL.appendingPathComponent(filePath)
        
        try meida.write(to: fileURL)
        
        return fileURL
    }
    
    /// 获取指定文件下媒体个数
    class func peppyGetMedias(mediaPath: String) throws -> Int {
        guard let doc = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw NSError(domain: "FileError", code: 1001, userInfo: [NSLocalizedDescriptionKey: "Error read file"])
        }
        
        let targetDir = doc.appendingPathComponent(mediaPath)
        
        var isDir: ObjCBool = false
        
        guard FileManager.default.fileExists(atPath: targetDir.path, isDirectory: &isDir) else { return 0 }
        
        let contents = try FileManager.default.contentsOfDirectory(at: targetDir, includingPropertiesForKeys: [.isDirectoryKey], options: [.skipsHiddenFiles])
        
        return contents.filter { url in
            do {
                let resValues = try url.resourceValues(forKeys: [.isDirectoryKey])
                return resValues.isDirectory == false
            } catch { return false }
        }.count
    }
    
    /// 删除指定文件及文件下数据
    class func peppyDeleteMedia(mediaPath: String) {
        guard let doc = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        let targetDir = doc.appendingPathComponent(mediaPath)
        
        let fileManager = FileManager.default
        do {
            if fileManager.fileExists(atPath: targetDir.path) {
                try fileManager.removeItem(at: targetDir)
            } else {}
        } catch {}
    }
    
    /// 删除指定目录下的单个媒体数据
    class func peppyDeletSignleMedia(mediaPath: String, targetFile: Int) {
        guard let doc = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        let targetDir = doc.appendingPathComponent(mediaPath)
        
        let fileManager = FileManager.default
        do {
            if fileManager.fileExists(atPath: targetDir.path) {
                try fileManager.removeItem(at: targetDir)
                PeppyUserManager.PEPPYUpdateDancerDetails(pey: { pey in
                    pey.mediaList!.remove(at: targetFile)
                    return pey
                })
            } else {}
        } catch {}
    }
}
