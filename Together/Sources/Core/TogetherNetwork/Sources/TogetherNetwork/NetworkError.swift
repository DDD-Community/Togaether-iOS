//
//  File.swift
//  
//
//  Created by 한상진 on 2023/01/26.
//

import Foundation

public enum NetworkError: Error, Sendable {
    case decodedFailed
    case dataIsNil
    case haveToOverride
    
    case invalidURL(url: String)
    case parameterURLEncodingFailed(reason: String)
    case parameterJSONEncodingFailed(reason: String)
    case invalidStatusCode(code: Int)
    case network(code: Int)
    
    case unhandled(rawValue: Error?)
}

extension NetworkError {
    static func isNetworkError(_ error: Error) -> Bool {
        return (error as NSError).domain == "NSURLErrorDomain"
    }
}
