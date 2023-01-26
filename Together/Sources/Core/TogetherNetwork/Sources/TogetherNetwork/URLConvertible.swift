//
//  File.swift
//  
//
//  Created by 한상진 on 2023/01/26.
//

import Foundation

public protocol URLConvertible {
    func asURL() throws -> URL
}

extension String: URLConvertible {
    public func asURL() throws -> URL {
        guard let url = URL(string: self) else { throw NetworkError.invalidURL(url: self) }
        return url
    } 
}

extension URL: URLConvertible {
    public func asURL() throws -> URL { return self }
}

extension URLComponents: URLConvertible {
    public func asURL() throws -> URL {
        guard let url = url else { throw NetworkError.invalidURL(url: self.url?.absoluteString ?? "" ) }
        return url
    }
}
