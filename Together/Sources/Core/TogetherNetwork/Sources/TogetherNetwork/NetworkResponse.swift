//
//  File.swift
//  
//
//  Created by 한상진 on 2023/01/26.
//

import Foundation

public struct NetworkResponse {
    public let data: Data?
    public let response: URLResponse?
    public let error: Error?
    
    public init(data: Data?, response: URLResponse?, error: Error?) {
        self.data = data
        self.response = response
        self.error = error
    }
}
