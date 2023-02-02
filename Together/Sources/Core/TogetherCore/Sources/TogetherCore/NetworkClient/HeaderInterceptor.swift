//
//  File.swift
//  
//
//  Created by 한상진 on 2023/01/28.
//

import Foundation
import TogetherNetwork

struct HeaderInterceptor: NetworkInterceptor {
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
        return (urlRequest, .doNotRetry(with: error))
    }
}

extension HeaderInterceptor {
    static var headers: Headers = {
        var headers: Headers = .init()
        headers.add(.contentType("application/json"))
        return headers
    }()
}
