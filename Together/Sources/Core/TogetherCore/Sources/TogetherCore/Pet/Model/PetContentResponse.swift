//
//  PetContentResponse.swift
//  
//
//  Created by denny on 2023/02/08.
//

import Foundation

public struct PetContentResponse: Decodable, Equatable, Sendable {
    public let rows: [ContentResponse]

    private enum CodingKeys: String, CodingKey {
        case rows
    }
}

public struct ContentResponse: Decodable, Equatable, Sendable {
    public let content: String
    public let imageUrl: String

    private enum CodingKeys: String, CodingKey {
        case content
        case imageUrl = "image_url"
    }
}
