//
//  File.swift
//  
//
//  Created by 한상진 on 2023/01/28.
//

import Foundation
import TogetherNetwork
import ComposableArchitecture

struct TokenInterceptor: NetworkInterceptor {
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

extension TokenInterceptor {
    private func addToken(to urlRequest: URLRequest, for options: NetworkRequestOptions) async throws -> URLRequest {
        @Dependency(\.togetherAccount) var togetherAccount 
        var urlRequest = urlRequest
        let credential = try await togetherAccount.token()
        urlRequest.setHeader(.xAuthorization(credential.xAuth))
        return urlRequest
    }
}
