//
//  MyPetResponse.swift
//  
//
//  Created by denny on 2023/02/07.
//

import Foundation

public struct MyPetResponse: Decodable, Equatable, Sendable {
    public let pets: [PetResponse]

    private enum CodingKeys: String, CodingKey {
        case pets = "rows"
    }
}
