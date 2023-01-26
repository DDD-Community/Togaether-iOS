//
//  File.swift
//  
//
//  Created by 한상진 on 2023/01/26.
//

import Foundation

public protocol URLRequestConvertible {
    func asURLRequest() throws -> URLRequest
}

extension URLRequest: URLRequestConvertible {
    public func asURLRequest() throws -> URLRequest { self }
}

public struct DataRequestConvertor: URLRequestConvertible {
    let url: URLConvertible
    let method: HTTPMethod
    let parameters: Parameters?
    let encoding: ParameterEncodable
    let headers: Headers?
    
    public func asURLRequest() throws -> URLRequest {
        var request = try URLRequest(url: url.asURL())
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers?.dictionary
        
        return try encoding.encode(urlRequest: request, with: parameters)
    }
}
