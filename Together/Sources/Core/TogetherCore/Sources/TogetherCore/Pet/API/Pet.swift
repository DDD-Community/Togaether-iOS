//
//  Pet.API.swift
//  
//
//  Created by denny on 2023/02/07.
//

import Foundation

import TogetherNetwork
import ThirdParty

import ComposableArchitecture
import XCTestDynamicOverlay

public struct Pet {
    public var list: @Sendable (
        _ pageSize: Int,
        _ currentPage: Int,
        _ petOrderBy: String
    ) async throws -> PetListResponse
}

public extension Pet {
    func list(pageSize: Int, currentPage: Int, petOrderBy: String) async throws -> PetListResponse {
        try await self.list(pageSize, currentPage, petOrderBy)
    }
}

extension DependencyValues {
    public var petAPI: Pet {
        get { self[Pet.self] }
        set { self[Pet.self] = newValue }
    }
}

extension Pet: DependencyKey {
    public static let liveValue: Pet = .init { pageSize, currentPage, petOrderBy in
        return try await NetworkClient.together.request(
            convertible: "\(Host.together)/pet/list",
            method: .get,
            parameters: [
                "page_size": pageSize,
                "current_page": currentPage,
                "pet_order_by": petOrderBy
            ],
            encoding: ParameterURLEncoder()
        )
        .responseAsync()
    }

    public static let testValue: Pet = .init(
        list: unimplemented()
    )
}
