import Foundation
import Moya

// MARK: - 数据模型
struct PeppyAnimalResponse: Codable {
    
    var code: Int?
    
    var data: PeppyResponseData?
    
    var message: String?
    
    enum CodingKeys: String, CodingKey {
        case code, data
        case message = "mes"
    }
}

struct PeppyResponseData: Codable {
    
    var answer: String?
    
    var conversationId: String?
    
    var showSeconds: Int?
    
    enum CodingKeys: String, CodingKey {
        case answer = "answer"
        case conversationId = "conversation_id"
        case showSeconds = "show_sec"
    }
}

// MARK: - 网络服务协议
protocol AnimalChatServiceType {
    
    func chatWithAnimal(message: String, completion: @escaping (Result<PeppyAnimalResponse, Error>) -> Void)
}

// MARK: - Moya Target定义
enum AnimalChatTarget {
    
    case chat(message: String)
}

extension AnimalChatTarget: TargetType {
    
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
        case .chat(let message):
            let parameters: [String: Any] = [
                "bundle_id": "com.terst",
                "content": message,
                "content_type": "text",
                "session_id": PeppyComManager.peppySessionId()
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
final class AnimalChatService: AnimalChatServiceType {
    
    static let shared = AnimalChatService()
    
    private let provider: MoyaProvider<AnimalChatTarget>
    
    init(provider: MoyaProvider<AnimalChatTarget> = MoyaProvider(
        requestClosure: AnimalChatService.requestTimeoutClosure,
        plugins: [NetworkLoggerPlugin(verbose: true)]
    )) {
        self.provider = provider
    }
    
    private static var requestTimeoutClosure: MoyaProvider<AnimalChatTarget>.RequestClosure = { endpoint, done in
        guard var request = try? endpoint.urlRequest() else { return }
        request.timeoutInterval = 15.0
        done(.success(request))
    }
    
    func chatWithAnimal(message: String, completion: @escaping (Result<PeppyAnimalResponse, Error>) -> Void) {
        provider.request(.chat(message: message)) { result in
            switch result {
            case .success(let response):
                guard response.statusCode == 200 else {
                    completion(.failure(NSError(domain: "", code: response.statusCode)))
                    return
                }
                
                do {
                    let decodedResponse = try JSONDecoder().decode(PeppyAnimalResponse.self, from: response.data)
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
