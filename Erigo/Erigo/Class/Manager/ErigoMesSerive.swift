//
//  ErigoMesSerive.swift
//  Erigo
//
//  Created by 北川 on 2025/4/23.
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
protocol ErigoMesServiceType {
    
    func ErigoChat(message: String, sid: String, completion: @escaping (Result<EResponse, Error>) -> Void)
}

// MARK: - Moya
enum ErigoMesTarget {
    
    case chat(message: String, sid: String)
}

extension ErigoMesTarget: TargetType {
    
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
class ErigoMesService: ErigoMesServiceType {

    static let shared = ErigoMesService()
    
    let provider: MoyaProvider<ErigoMesTarget>
    
    init(provider: MoyaProvider<ErigoMesTarget> = MoyaProvider(
        requestClosure: ErigoMesService.requestTimeoutClosure,
        plugins: [NetworkLoggerPlugin(verbose: true)]
    )) {
        self.provider = provider
    }
    
    static var requestTimeoutClosure: MoyaProvider<ErigoMesTarget>.RequestClosure = { endpoint, done in
        guard var request = try? endpoint.urlRequest() else { return }
        request.timeoutInterval = 15.0
        done(.success(request))
    }
    
    /// 聊天 - AI
    func ErigoChat(message: String, sid: String, completion: @escaping (Result<EResponse, Error>) -> Void) {
        provider.request(.chat(message: message, sid: sid)) { result in
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
