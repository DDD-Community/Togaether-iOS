//
//  File.swift
//  
//
//  Created by 한상진 on 2023/01/30.
//

import Foundation

public struct JoinResponse: Decodable, Equatable, Sendable {
    let id: Int
    let name: String
    let birth: [Int]
    let profileURL: URL
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case birth
        case profileURL = "my_profile_picture_url"
    }
}
