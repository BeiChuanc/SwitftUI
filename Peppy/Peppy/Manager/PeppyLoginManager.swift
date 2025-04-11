//
//  PeppyLoginViewModel.swift
//  Peppy
//
//  Created by 北川 on 2025/4/10.
//

import Foundation

// MARK: 登陆管理器
class PeppyLoginManager: ObservableObject {
    
    @Published var isLogin: Bool = false
}

// MARK: - 全局JSON转换
class PeppyJsonManager {
    
    /// 将字典序列化为 JSON 数据
    /// - Parameter parameters: 需要序列化的字典
    /// - Returns: 转换后的 JSON 数据，如果失败则返回 nil
    static func encode(parameters: [String: Any]) -> Data? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            return jsonData
        } catch {
            print("JSON 序列化失败: \(error.localizedDescription)")
            return nil
        }
    }
    
    /// 将 JSON 数据反序列化为字典
    /// - Parameter data: JSON 数据
    /// - Returns: 转换后的字典，如果失败则返回 nil
    static func decodeToDictionary(data: Data) -> [String: Any]? {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            return jsonObject as? [String: Any]
        } catch {
            print("JSON 反序列化失败: \(error.localizedDescription)")
            return nil
        }
    }
    
    /// 将 JSON 数据解码为泛型模型对象
    /// - Parameters:
    ///   - data: JSON 数据
    ///   - type: 要解码的目标类型，必须符合 Codable 协议
    /// - Returns: 解码后的目标类型对象，如果失败则返回 nil
    static func decode<T: Codable>(data: Data, to type: T.Type) -> T? {
        do {
            let decodedObject = try JSONDecoder().decode(T.self, from: data)
            return decodedObject
        } catch {
            print("JSON 泛型解码失败: \(error.localizedDescription)")
            return nil
        }
    }
    
    /// 将模型对象编码为 JSON 数据
    /// - Parameter object: 要编码的模型对象，必须符合 Codable 协议
    /// - Returns: 编码后的 JSON 数据，如果失败则返回 nil
    static func encode<T: Codable>(object: T) -> Data? {
        do {
            let jsonData = try JSONEncoder().encode(object)
            return jsonData
        } catch {
            print("JSON 泛型编码失败: \(error.localizedDescription)")
            return nil
        }
    }
}
