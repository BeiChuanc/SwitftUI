//
//  MondoMesService.swift
//  Mondo
//
//  Created by 北川 on 2025/4/29.
//

import Foundation
import Moya

// MARK: - 数据模型
struct EResponse: Codable {
    
    var code: Int?
    
    var data: EResponseDate?
    
    var message: String?
    
    enum CodingKeys: String, CodingKey {
        
        case code, data
        
        case message = "mes"
    }
}

struct EResponseDate: Codable {
    
    var res: String?
    
    var cid: String?
    
    var sec: Int?
    
    enum CodingKeys: String, CodingKey {
        
        case res = "answer"
        
        case cid = "conversation_id"
        
        case sec = "show_sec"
    }
}

// MARK: - 网络服务协议
protocol MondoMesServiceType {
    
    func MondoChat(message: String, sid: String, completion: @escaping (Result<EResponse, Error>) -> Void)
}

// MARK: - Moya
enum MondoMesTarget {
    
    case chat(message: String, sid: String)
}

extension MondoMesTarget: TargetType {
    
    var baseURL: URL { URL(string: "https://api.wiseaii.com")! }
    
    var path: String {
        switch self {
        case .chat: return "/wiseai/v1/chat"
        }
    }
    
    var method: Moya.Method { .post }
    
    var sampleData: Data {
        return "{}".data(using: .utf8)!
    }
    
    var task: Task {
        switch self {
        case .chat(let message, let sid):
            let parameters: [String: Any] = [
                "bundle_id": "com.terst",
                "content": message,
                "content_type": "text",
                "session_id": sid
            ]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        return [
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
    }
}

// MARK: - 网络服务实现
class MondoMesService: MondoMesServiceType {

    static let shared = MondoMesService()
    
    let mondProvider: MoyaProvider<MondoMesTarget>
    
    init(provider: MoyaProvider<MondoMesTarget> = MoyaProvider(
        requestClosure: MondoMesService.mondoClosure,
        plugins: [NetworkLoggerPlugin(verbose: true)]
    )) {
        self.mondProvider = provider
    }
    
    static var mondoClosure: MoyaProvider<MondoMesTarget>.RequestClosure = { endpoint, done in
        guard var request = try? endpoint.urlRequest() else { return }
        request.timeoutInterval = 15.0
        done(.success(request))
    }
    
    /// 聊天 - AI
    func MondoChat(message: String, sid: String, completion: @escaping (Result<EResponse, Error>) -> Void) {
        mondProvider.request(.chat(message: message, sid: sid)) { result in
            switch result {
            case .success(let response):
                guard response.statusCode == 200 else {
                    completion(.failure(NSError(domain: "", code: response.statusCode)))
                    return
                }
                
                do {
                    let decodedResponse = try JSONDecoder().decode(EResponse.self, from: response.data)
                    completion(.success(decodedResponse))
                } catch {
                    completion(.failure(error))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
