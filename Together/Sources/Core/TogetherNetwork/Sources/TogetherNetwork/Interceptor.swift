//
//  File.swift
//  
//
//  Created by 한상진 on 2023/01/26.
//

import Foundation

public protocol NetworkInterceptor {
    func adapt(urlRequest: URLRequest, options: NetworkRequestOptions) async throws -> URLRequest
    func retry(
        urlRequest: URLRequest, 
        response: URLResponse?,
        data: Data?, 
        with error: Error, 
        options: NetworkRequestOptions
    ) async -> (URLRequest, RetryResult)
}
