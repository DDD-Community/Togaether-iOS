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

extension Pet {
    struct API {
        var list: @Sendable (
            _ pageSize: Int,
            _ currentPage: Int,
            _ petOrderBy: String
        ) async throws -> PetListResponse
    }
}

extension DependencyValues {
    var petAPI: Pet.API {
        get { self[Pet.API.self] }
        set { self[Pet.API.self] = newValue }
    }
}

extension Pet.API: DependencyKey {
    static let liveValue: Pet.API = .init { pageSize, currentPage, petOrderBy in
        return try await NetworkClient.pet.request(
            convertible: "\(Host.together)/pet/list",
            method: .get,
            parameters: [
                "page_size": pageSize,
                "current_page": currentPage,
                "pet_order_by": petOrderBy
            ],
            encoding: ParameterJSONEncoder()
        )
        .responseAsync()
    }

    public static let testValue: Pet.API = .init(
        list: unimplemented()
    )
}
