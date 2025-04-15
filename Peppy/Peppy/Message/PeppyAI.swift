//
//  PeppyAI.swift
//  Peppy
//
//  Created by 北川 on 2025/4/15.
//

import Foundation
import Moya

// AI接口
enum PeppyAnimalChat {
    
    case withAnimalsAI(mes: String)
}

// 响应
class PeppyAnimailRS: Codable {
    
    var code: Int?
    
    var data: PeppyRES?
    
    var message: String?
}

// 回复
class PeppyRES: Codable {
    
    var res: String?
    
    var id: String?
    
    var tr: Int?
    
    enum CodingKeys: String, CodingKey {
        
        case res = "answer"
        
        case id = "conversation_id"
        
        case tr = "show_sec"
    }
}


// MARK: AI服务
class PeppyAnimailsAIChat: NSObject {
    
    static let share = PeppyAnimailsAIChat()
    
    var timeOut: Double = 15.0
    
    lazy var PeppyAnimalsAIChat = {
        return MoyaProvider<PeppyAnimalChat>(requestClosure: requestClosure(target: PeppyAnimalChat.self), plugins: [NetworkLoggerPlugin(verbose: true)])
    }()
    
    func requestClosure<T: TargetType>(target : T.Type) -> MoyaProvider<T>.RequestClosure {
        let requestClosure = { [self] (endpoint : Endpoint, done: MoyaProvider<T>.RequestResultClosure) -> Void in
            guard var request = try? endpoint.urlRequest() else { return }
                request.timeoutInterval = timeOut
                done(.success(request))
        }
        return requestClosure
    }
    
    func peppyWithAnimal(message: String, completion: @escaping(Result<PeppyAnimailRS, Error>) -> Void) {
        self.PeppyAnimalsAIChat.request(.withAnimalsAI(mes: message)) { (result) in
            switch result {
            case .success(let respone):
                if respone.statusCode == 200 {
                    let jsonData = respone.data
                    let responeData = PeppyJsonManager.decode(data: jsonData, to: PeppyAnimailRS.self)
                    completion(.success(responeData!))
                } else {
                    completion(.failure(NSError(domain: "", code: respone.statusCode)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}

extension PeppyAnimalChat: TargetType {
    
    var baseURL: URL {
        return URL(string: "https://api.wiseaii.com")!
    }
    
    var path: String {
        return "/wiseai/v1/chat"
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }
    
    var task: Moya.Task {
        var paramters: [String: Any] = [:]
        switch self {
        case .withAnimalsAI(mes: let mes):
            paramters["bundle_id"] = "com.terst"
            paramters["content"] = mes
            paramters["content_type"] = "text"
            paramters["session_id"] = PeppyComManager.peppySessionId()
            return .requestParameters(parameters: paramters, encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        var head: [String: String]? = ["": ""]
        head = [
            "Accept":"application/json",
            "Content-Type":"application/json"
        ]
        return head
    }
}
