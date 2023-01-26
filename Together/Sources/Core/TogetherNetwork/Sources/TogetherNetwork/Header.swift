//
//  File.swift
//  
//
//  Created by 한상진 on 2023/01/26.
//

import Foundation

public struct Header: Hashable {
    
    public let name: String
    public let value: String

    public init(name: String, value: String) {
        self.name = name
        self.value = value
    }
}

extension Header: CustomStringConvertible {
    public var description: String {
        "\(name): \(value)"
    }
}

extension Header {
    public static func accept(_ value: String) -> Header {
        Header(name: "Accept", value: value)
    }
    public static func acceptLanguage(_ value: String) -> Header {
        Header(name: "Accept-Language", value: value)
    }
    public static func acceptEncoding(_ value: String) -> Header {
        Header(name: "Accept-Encoding", value: value)
    }
    public static func authorization(_ value: String) -> Header {
        Header(name: "Authorization", value: value)
    }
    public static func xAuthorization(_ value: String) -> Header {
        Header(name: "X-Authorization", value: value)
    }
    public static func contentType(_ value: String) -> Header {
        Header(name: "Content-Type", value: value)
    }
    public static func userAgent(_ value: String) -> Header {
        Header(name: "User-Agent", value: value)
    }
}


public extension URLRequest {
    mutating func setHeaders( _ headers: Headers) {
        headers.forEach { self.setHeader($0) }
    }
    
    mutating func setHeader( _ header: Header) {
        self.setValue(header.value, forHTTPHeaderField: header.name)
    }
}
