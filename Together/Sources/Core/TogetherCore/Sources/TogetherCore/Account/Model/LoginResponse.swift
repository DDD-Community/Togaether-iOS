//
//  File.swift
//  
//
//  Created by 한상진 on 2023/01/28.
//

import Foundation

public struct LoginResponse: Decodable, Equatable, Sendable {
    public let email: String
    public let role: [String]
    public let credential: TogetherCredential
    
    private enum CodingKeys: String, CodingKey {
        case email
        case role
        case credential = "jwt"
    }
}
