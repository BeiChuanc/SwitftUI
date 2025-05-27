import Foundation

class PostManager: NSObject {
    
    static let shared = PostManager()
    
    private let postFileName: String = "UvooPosts.plist"
    
    private var postDirPath: String {
        let documentsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDir.appendingPathComponent(postFileName).path
    }
    
    private override init() {}
    
    func UvooInitPostWithU() {
        let posts = UvooGenPost()
        UvooSavePost(In: posts!)
    }
    
    func UvooInitPostData() {
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: postDirPath) {
            let posts = UvooGenPost()
            UvooSavePost(In: posts!)
        }
    }
    
    func UvooSaveMePost(post: UvooPublishM) {
        var posts = UvooLoadPosts()
        posts.append(post)
        UvooSavePost(In: posts)
    }
    
    func UvooGenPost() -> [UvooPublishM]? {
        guard let postPath = Bundle.main.url(forResource: "PostData", withExtension: "txt") else { return nil }
        
        do {
            let decoder = JSONDecoder()
            let posts: [UvooPublishM] = try decoder.decodeFromFile(at: postPath)
            return posts
        } catch {}
        return []
    }
    
    func UvooSavePost(In post: [UvooPublishM]) {
        do {
            let postP = try PropertyListEncoder().encode(post)
            let url = URL(fileURLWithPath: postDirPath)
            try postP.write(to: url)
        } catch {}
    }
    
    func UvooLoadPosts() -> [UvooPublishM] {
        guard let data = FileManager.default.contents(atPath: postDirPath) else {
            return [] }
        
        do {
            return try PropertyListDecoder().decode([UvooPublishM].self, from: data)
        } catch { return [] }
    }
    
    func UvooGetPost(by tId: Int) -> UvooPublishM? {
        return UvooLoadPosts().first { $0.tId == tId }
    }
    
    func UvooUpdatePost(_ updatedPost: UvooPublishM) {
        var posts = UvooLoadPosts()
        
        if let index = posts.firstIndex(where: { $0.tId == updatedPost.tId }) {
            posts[index] = updatedPost
            UvooSavePost(In: posts)
        }
    }
    
    func UvooSaveMedia(meidaData: Data, fileName: String, mediaFolder: String) throws -> URL {
        guard let documentsDir = FileManager.default.urls(for: .documentDirectory,in: .userDomainMask).first else {
            throw NSError(domain: "FileError", code: 1001, userInfo: [NSLocalizedDescriptionKey: "Unable to access the documents directory"])
        }
        
        let folder = documentsDir.appendingPathComponent(mediaFolder)
        
        try FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true, attributes: nil)
        
        let fileURL = folder.appendingPathComponent(fileName)
        try meidaData.write(to: fileURL)
        return fileURL
    }
    
    func UvooGetMeMedia(mediaFolder: String) throws -> Int {
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
    
    func UvooDeleteMeMedia(mediaFolder: String) {
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
