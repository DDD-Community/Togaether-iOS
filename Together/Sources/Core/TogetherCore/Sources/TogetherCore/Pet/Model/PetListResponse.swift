//
//  PetListResponse.swift
//  
//
//  Created by denny on 2023/02/07.
//

import Foundation

public struct PetListResponse: Decodable, Equatable, Sendable {
    public let totalCount: Int
    public let totalPages: Int
    public let currentPage: Int
    public let petList: [PetResponse]

    private enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case totalPages = "total_pages"
        case currentPage = "current_page"
        case petList = "rows"
    }
}
