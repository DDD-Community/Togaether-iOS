//
//  Member.swift
//  
//
//  Created by denny on 2023/02/07.
//

import ComposableArchitecture
import Foundation
import TogetherNetwork
import ThirdParty
import XCTestDynamicOverlay

public struct Member {
    public var myPets: @Sendable () async throws -> MyPetResponse
}

public extension Member {
    func myPets() async throws -> MyPetResponse {
        try await self.myPets()
    }
}

extension DependencyValues {
    public var memberAPI: Member {
        get { self[Member.self] }
        set { self[Member.self] = newValue }
    }
}

extension Member: DependencyKey {
    public static let liveValue: Member = .init {
        return try await NetworkClient.together.request(
            convertible: "\(Host.together)/member/my-pets",
            method: .get,
            encoding: ParameterURLEncoder()
        )
        .responseAsync()
    }

    public static let testValue: Member = .init(
        myPets: unimplemented()
    )
}
