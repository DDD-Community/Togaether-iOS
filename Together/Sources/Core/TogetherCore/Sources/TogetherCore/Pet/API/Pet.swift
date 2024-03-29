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
        _ petOrderBy: String?
    ) async throws -> PetListResponse

    public var petContents: @Sendable (
        _ petId: Int
    ) async throws -> PetContentResponse

    public var petFollow: @Sendable (
        _ petId: Int
    ) async throws -> DefaultResponse

    public var petInfoRegister: @Sendable (
        _ name: String,
        _ species: String,
        _ petCharacter: String,
        _ gender: String,
        _ birth: String,
        _ description: String,
        _ etc: String
    ) async throws -> DefaultResponse

    public var petInfoModify: @Sendable (
        _ petId: Int,
        _ name: String,
        _ species: String,
        _ petCharacter: String,
        _ gender: String,
        _ birth: String,
        _ description: String,
        _ etc: String
    ) async throws -> DefaultResponse
    
    public var register: @Sendable(
        _ image: Data,
        _ name: String,
        _ species: String,
        _ petCharacter: String,
        _ gender: String,
        _ birth: String,
        _ description: String,
        _ etc: String
    ) async throws -> DefaultResponse
}

public extension Pet {
    func list(pageSize: Int, currentPage: Int, petOrderBy: String? = nil) async throws -> PetListResponse {
        try await self.list(pageSize, currentPage, petOrderBy)
    }

    func petContentList(petId: Int) async throws -> PetContentResponse {
        try await self.petContents(petId)
    }

    func petFollow(petId: Int) async throws -> DefaultResponse {
        try await self.petFollow(petId)
    }

    func petInfoRegister(name: String, species: String, petCharacter: String, gender: String, birth: String, description: String, etc: String) async throws -> DefaultResponse {
        try await self.petInfoRegister(name, species, petCharacter, gender, birth, description, etc)
    }

    func petInfoModify(petId: Int, name: String, species: String, petCharacter: String, gender: String, birth: String, description: String, etc: String) async throws -> DefaultResponse {
        try await self.petInfoModify(petId, name, species, petCharacter, gender, birth, description, etc)
    }
    
    func register(
        data: Data,
        name: String,
        species: String,
        petCharacter: String,
        gender: String,
        birth: String,
        description: String,
        etc: String
    ) async throws -> DefaultResponse {
        try await self.register(data, name, species, petCharacter, gender, birth, description, etc)
    }
}

extension DependencyValues {
    public var petAPI: Pet {
        get { self[Pet.self] }
        set { self[Pet.self] = newValue }
    }
}

extension Pet: DependencyKey {
    public static let liveValue: Pet = Pet(
        list: { pageSize, currentPage, petOrderBy in
            let parameters: [String: Any]
            if petOrderBy != nil {
                parameters = ["page_size": pageSize, "current_page": currentPage, "pet_order_by": petOrderBy ?? "FOLLOWER_COUNT_DESC"]
            } else {
                parameters = ["page_size": pageSize, "current_page": currentPage]
            }

            return try await NetworkClient.together.request(
                convertible: "\(Host.together)/pet/list2",
                method: .get,
                parameters: parameters,
                encoding: ParameterURLEncoder()
            )
            .responseAsync()
        },
        petContents: { petId in
            return try await NetworkClient.together.request(
                convertible: "\(Host.together)/pet/\(petId)/contents",
                method: .get,
                encoding: ParameterURLEncoder()
            ).responseAsync()
        },
        petFollow: { petId in
            return try await NetworkClient.together.request(
                convertible: "\(Host.together)/pet/\(petId)/follow",
                method: .put,
                encoding: ParameterURLEncoder()
            ).responseAsync()
        },
        petInfoRegister: { name, species, petCharacter, gender, birth, description, etc in
            return try await NetworkClient.together.request(
                convertible: "\(Host.together)/pet",
                method: .post,
                parameters: [
                    "name": name,
                    "species": species,
                    "pet_character": petCharacter,
                    "gender": gender,
                    "birth": birth,
                    "description": description,
                    "etc": etc
                ],
                encoding: ParameterJSONEncoder()
            ).responseAsync()
        },
        petInfoModify: { petId, name, species, petCharacter, gender, birth, description, etc in
            return try await NetworkClient.together.request(
                convertible: "\(Host.together)/pet/\(petId)",
                method: .post,
                parameters: [
                    "name": name,
                    "species": species,
                    "pet_character": petCharacter,
                    "gender": gender,
                    "birth": birth,
                    "description": description,
                    "etc": etc
                ],
                encoding: ParameterJSONEncoder()
            ).responseAsync()
        },
        register: { data, name, species, petCharacter, gender, birth, description, etc in
            let value = MultiPartValue(name: "main_image", fileName: "@Retriever.png", mime: "image/png", data: data)
            return try await NetworkClient.together.upload(
                convertible: "\(Host.together)/pet/with-image", 
                values: [value]
            )
            .responseAsync()
        }
    )

    public static let testValue: Pet = Pet(
        list: unimplemented(),
        petContents: unimplemented(),
        petFollow: unimplemented(),
        petInfoRegister: { _,_,_,_,_,_,_  in fatalError() },
        petInfoModify: { _,_,_,_,_,_,_,_  in fatalError() }, 
        register: { image,name,species,petCharacter,gender,birth,description,etc in 
            fatalError()
        }
    )
}
