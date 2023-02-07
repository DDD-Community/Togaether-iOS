//
//  PetResponse.swift
//  
//
//  Created by denny on 2023/02/07.
//

import Foundation

public struct PetResponse: Decodable, Equatable, Sendable {
    public let id: Int
    public let name: String
    public let species: String
    public let petCharacter: String
    public let gender: String
    public let birth: String
    public let mainImage: String
    public let description: String
    public let etc: String
    public let followerCount: Int

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case species
        case petCharacter = "pet_character"
        case gender
        case birth
        case mainImage = "main_image"
        case description
        case etc
        case followerCount = "follower_count"
    }
}
