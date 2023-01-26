//
//  File.swift
//  
//
//  Created by 한상진 on 2023/01/26.
//

import Foundation

public typealias Parameters = [String: Any]

public protocol ParameterEncodable {
    func encode(urlRequest: URLRequest, with parameters: Parameters?) throws -> URLRequest
}

public struct ParameterURLEncoder: ParameterEncodable {
    
    private let queryEncoder: ParameterQueryEncoder
    
    public init(
        arrayEncoder: ParameterArrayEncoder = .noBrackets,
        boolEncoder: ParameterBoolEncoder = .numeric
    ) {
        self.queryEncoder = ParameterQueryEncoder(arrayEncoder: arrayEncoder, boolEncoder: boolEncoder)
    }
    
    public func encode(urlRequest: URLRequest, with parameters: Parameters?) throws -> URLRequest {
        var urlRequest = urlRequest
        
        guard let parameters = parameters else { return urlRequest }
        guard let url = urlRequest.url else { throw NetworkError.parameterURLEncodingFailed(reason: "Missing URL") }
        guard var urlComponent = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return urlRequest }
        
        let queryItems = queryEncoder.query(parameters)
        urlComponent.queryItems = queryItems
        urlRequest.url = urlComponent.url
        
        return urlRequest
    }    
}

public struct ParameterJSONEncoder: ParameterEncodable {
    public init() { }
    
    public func encode(urlRequest: URLRequest, with parameters: Parameters?) throws -> URLRequest {
        var urlRequest = urlRequest
        guard let method = urlRequest.method, method.isQueryStringMethod == false else {
            assertionFailure("\(urlRequest.method?.rawValue ?? "") 메서드는 json 인코딩을 사용할 수 없습니다.")
            throw NetworkError.parameterJSONEncodingFailed(reason: "Get, Head, Delete method must not have a body")
        }
        
        guard let parameters = parameters else { return urlRequest }

        do {
            let data = try JSONSerialization.data(withJSONObject: parameters, options: [.prettyPrinted, .withoutEscapingSlashes, .fragmentsAllowed])
            urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = data
        } catch {
            throw NetworkError.parameterJSONEncodingFailed(reason: "incorrect url: \(urlRequest.url?.absoluteString ?? "")")
        }
        
        return urlRequest
    }
}

public struct ParameterQueryEncoder {
    
    private let arrayEncoder: ParameterArrayEncoder
    private let boolEncoder: ParameterBoolEncoder
    
    public init(
        arrayEncoder: ParameterArrayEncoder = .noBrackets,
        boolEncoder: ParameterBoolEncoder = .numeric
    ) {
        self.arrayEncoder = arrayEncoder
        self.boolEncoder = boolEncoder
    }
    
    public func query(_ parameters: Parameters) -> [URLQueryItem] {
        var items: [URLQueryItem] = []
        
        for key in parameters.keys.sorted(by: <) {
            let value = parameters[key]!
            items += queryComponents(key: key, value: value)
        }
        return items
    }
    
    public func queryComponents(key: String, value: Any) -> [URLQueryItem] {
        var items: [URLQueryItem] = []
        switch value {
        case let dictionary as [String: Any]:
            for (nestedKey, value) in dictionary {
                items += queryComponents(key: "\(key)[\(nestedKey)]", value: value)
            }
        case let array as [Any]:
            for (index, value) in array.enumerated() {
                items += queryComponents(key: arrayEncoder.encode(key: key, atIndex: index), value: value)
            }
        case let number as NSNumber:
            if number.isBool {
                items.append(URLQueryItem(name: key, value: boolEncoder.encode(value: number.boolValue)))
            } else {
                items.append(URLQueryItem(name: key, value: "\(number)"))
            }
        case let bool as Bool:
            items.append(URLQueryItem(name: key, value: boolEncoder.encode(value: bool)))
        default:
            items.append(URLQueryItem(name: key, value: "\(value)"))
        }
        return items
    }
    
}

public enum ParameterArrayEncoder {
    case brackets
    case noBrackets
    case indexInBrackets
    
    func encode(key: String, atIndex index: Int) -> String {
        switch self {
        case .brackets:
            return "\(key)[]"
        case .noBrackets:
            return key
        case .indexInBrackets:
            return "\(key)[\(index)]"
        }
    }
}

public enum ParameterBoolEncoder {
    case numeric
    case literal
    
    func encode(value: Bool) -> String {
        switch self {
        case .numeric:
            return value ? "1" : "0"
        case .literal:
            return value ? "true" : "false"
        }
    }
}

extension NSNumber {
    fileprivate var isBool: Bool { return String(cString: objCType) == "c" }
}
