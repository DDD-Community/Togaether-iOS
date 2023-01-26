//
//  File.swift
//  
//
//  Created by 한상진 on 2023/01/26.
//

import Foundation

@frozen public enum HTTPMethod: String {
    case get = "GET"
    case head = "HEAD"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

public extension HTTPMethod {
    var isQueryStringMethod: Bool {
        return [.get, .head, .delete].contains(self)
    }
}

extension URLRequest {
    var method: HTTPMethod? {
        get { httpMethod.flatMap(HTTPMethod.init) }
        set { httpMethod = newValue?.rawValue }
    }
}
