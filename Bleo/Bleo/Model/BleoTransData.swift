import Foundation

class BleoTransData {
    
    var isLoginIn: Bool = false
    
    static let shared = BleoTransData()
    
    let titlePath: String = "BleoTitles.plist"
    
    var titleDirPath: URL {
        let documentsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDir.appendingPathComponent(titlePath)
    }
    
    var isExistFile: Bool {
        return FileManager.default.fileExists(atPath: titleDirPath.path)
    }
    
    var reportTitleList: [Int] = []
    
    var blockUserList: [Int] = []
    
    var titleArr: [BleoTitleM] = []
    
    var userArr: [BleoUserM] = []
    
    func BleoInitTitleUser() {
        let posts = BleoInitTitle()
        BleoSaveTitle(In: posts!)
    }
    
    func BleoGetTitles() {
        let titles = BleoLoadTitles()
        for title in titles {
            if !titleArr.contains(where: { $0.tId == title.tId }) {
                titleArr.append(title)
            }
        }
        titleArr = titleArr.filter { item in
            return !reportTitleList.contains(item.tId) && !blockUserList.contains(item.uId)
        }
    }
    
    func BleoGetUsers() {
        let users = BleoInitUser()
        for user in users {
            if !userArr.contains(where: { $0.uId == user.uId }) {
                userArr.append(user)
            }
        }
        
        userArr = userArr.filter { item in
            return !blockUserList.contains(item.uId)
        }
    }
    
    func BleoInitTitleData() {
        if !isExistFile {
            BleoSaveTitle(In: BleoInitTitle()!)
        }
    }
    
    func BleoSaveMyTitle(post: BleoTitleM) {
        var posts = BleoLoadTitles()
        posts.append(post)
        BleoSaveTitle(In: posts)
    }
    
    func BleoInitTitle() -> [BleoTitleM]? {
        guard let postPath = Bundle.main.url(forResource: "BleoTitle", withExtension: "txt") else { return nil }
        
        do {
            let decoder = JSONDecoder()
            let posts: [BleoTitleM] = try decoder.decodeFromFile(at: postPath)
            return posts
        } catch {}
        return []
    }
    
    func BleoInitUser() -> [BleoUserM] {
        let userPath = Bundle.main.url(forResource: "Bleoer", withExtension: "txt")!
        
        do {
            let decoder = JSONDecoder()
            let users: [BleoUserM] = try decoder.decodeFromFile(at: userPath)
            return users
        } catch {}
        return []
    }
    
    func BleoSaveTitle(In post: [BleoTitleM]) {
        do {
            let encodedData = try PropertyListEncoder().encode(post)
            try encodedData.write(to: titleDirPath, options: .atomic)
        } catch {}
    }
    
    func BleoLoadTitles() -> [BleoTitleM] {
        guard let data = FileManager.default.contents(atPath: titleDirPath.path) else {
            return [] }
        
        do {
            return try PropertyListDecoder().decode([BleoTitleM].self, from: data)
        } catch { return [] }
    }
    
    func BleoGetTitle(by tId: Int) -> BleoTitleM? {
        BleoLoadTitles().first { $0.tId == tId }
    }
    
    func BleoUpdateTitle(_ updatedPost: BleoTitleM) {
        var posts = BleoLoadTitles()
        
        if let index = posts.firstIndex(where: { $0.tId == updatedPost.tId }) {
            posts[index] = updatedPost
            BleoSaveTitle(In: posts)
        }
    }
    
    func encode<T: Codable>(object: T) -> Data? {
        do {
            let jsonData = try JSONEncoder().encode(object)
            return jsonData
        } catch {
            print("JSON 泛型编码失败: \(error.localizedDescription)")
            return nil
        }
    }
    
    func BleoSaveMyTitle(meidaData: Data, fileName: String, mediaFolder: String) throws -> URL {
        guard let documentsDir = FileManager.default.urls(for: .documentDirectory,in: .userDomainMask).first else {
            throw NSError(domain: "FileError", code: 1001, userInfo: [NSLocalizedDescriptionKey: "Unable to access the documents directory"])
        }
        
        let folder = documentsDir.appendingPathComponent(mediaFolder)
        
        try FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true, attributes: nil)
        
        let fileURL = folder.appendingPathComponent(fileName)
        try meidaData.write(to: fileURL)
        return fileURL
    }
    
    func BleoGetMyTitle(mediaFolder: String) throws -> Int {
        guard let documentsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw NSError(domain: "FileError", code: 1001, userInfo: [NSLocalizedDescriptionKey: "Unable to access the documents directory"])
        }
        
        let targetDirectory = documentsDir.appendingPathComponent(mediaFolder)
        
        var isDirectory: ObjCBool = false
        guard FileManager.default.fileExists(atPath: targetDirectory.path, isDirectory: &isDirectory) else { return 0 }
        
        let contents = try FileManager.default.contentsOfDirectory(at: targetDirectory, includingPropertiesForKeys: [.isDirectoryKey],
            options: [.skipsHiddenFiles])
        
        return contents.filter { url in
            do {
                let resourceValues = try url.resourceValues(forKeys: [.isDirectoryKey])
                return resourceValues.isDirectory == false
            } catch { return false }
        }.count
    }
    
    func BleoDeleteMyTitle(mediaFolder: String) {
        guard let documentsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask ).first else { return }
        
        let targetDirectory = documentsDir.appendingPathComponent(mediaFolder)
        
        let fileManager = FileManager.default
        do {
            if fileManager.fileExists(atPath: targetDirectory.path) {
                try fileManager.removeItem(at: targetDirectory)
            } else {}
        } catch {}
    }
}
