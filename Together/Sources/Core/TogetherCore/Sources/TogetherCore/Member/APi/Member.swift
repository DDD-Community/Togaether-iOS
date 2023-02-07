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
            encoding: ParameterURLEncoder(),
            headers: ["Content-Type": "application/json",
                      "Authorization": "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ0ZXN0QHRlc3QuY29tIiwiaXNzIjoiVE9HQUVUSEVSIiwiYXVkIjoiVVNFUiIsInJvbGVzIjpbIk5PUk1BTCJdLCJpYXQiOjE2NzU3NDM2ODIsImV4cCI6MTY3NTc0NzI4Mn0.6-ViJNRydqDK0Iu5C5lBW9N2dyMwJgQ3iw_-rclXEus"]
        )
        .responseAsync()
    }

    public static let testValue: Member = .init(
        myPets: unimplemented()
    )
}
