//
//  File.swift
//  
//
//  Created by 한상진 on 2023/01/28.
//

import Foundation
import TogetherNetwork

struct ErrorInterceptor: NetworkInterceptor {
    func adapt(urlRequest: URLRequest, options: NetworkRequestOptions) async throws -> URLRequest {
        return urlRequest
    }
    
    func retry(
        urlRequest: URLRequest, 
        response: URLResponse?, 
        data: Data?, 
        with error: Error, 
        options: NetworkRequestOptions
    ) async -> (URLRequest, RetryResult) {
        let mappedError = map(error: error, response: response, data: data)
        // sessionError일 경우 kickout 해야하지만 현재 미구현
        return (urlRequest, .doNotRetry(with: error))
    }
}

extension ErrorInterceptor {
    private func map(error: Error, response: URLResponse?, data: Data?) -> Error {
        if (error as NSError).code == NSURLErrorCancelled { return ResposeError.cancelled }
        if let networkError = error as? NetworkError { return networkError }
        guard let httpResponse = response as? HTTPURLResponse else { return ResposeError.unhandled(error: error) }
        let statusCode = httpResponse.statusCode
        // if let sessionError = SessionError(statusCode, error)
        return ResposeError(statusCode: statusCode, error: error)
    }
}

/// 현재는 사용할 일 x
@frozen
enum SessionError: Error {
    case invalidSession
    case invalidToken
    case updateRequired
}

@frozen
enum ResposeError: Error {
    case cancelled
    case unhandled(error: Error)
    case invalidStatusCode(code: Int)
    
    init(statusCode: Int, error: Error) {
        if statusCode == 500 {
            self = .invalidStatusCode(code: statusCode)
        } else {
            self = .unhandled(error: error)
        }
    }
} 
