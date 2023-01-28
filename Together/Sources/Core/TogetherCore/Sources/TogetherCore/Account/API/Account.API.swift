//
//  File.swift
//  
//
//  Created by 한상진 on 2023/01/28.
//

import Foundation

import TogetherNetwork
import ThirdParty

import ComposableArchitecture
import XCTestDynamicOverlay

public extension Account {
    struct API { 
        var login: @Sendable (_ email: String, _ password: String) async throws -> LoginResponse
        var fetchNewToken: @Sendable () async throws -> TogetherCredential
        var refresh: @Sendable (_ old: TogetherCredential) async throws -> TogetherCredential
    }
}

public extension Account.API {
    func login(email: String, password: String) async throws -> LoginResponse {
        try await self.login(email, password)
    }
}

extension DependencyValues {
    var accountAPI: Account.API {
        get { self[Account.API.self] }
        set { self[Account.API.self] = newValue }
    }
}

extension Account.API: DependencyKey {
    public static let liveValue: Account.API = .init(
        login: { email, password in
            return try await NetworkClient.account.request(
                convertible: "http://localhost:8080/sign-in/member", 
                method: .post,
                parameters: [
                    "email": email,
                    "password": password
                ],
                encoding: ParameterJSONEncoder()
            )
            .responseAsync()
        },
        fetchNewToken: { 
            preconditionFailure("새 토큰만 가져오는 로직 없음")
        },
        refresh: { credential in
            preconditionFailure("리프레쉬 타는 로직 없음")
        }
    )
    public static let testValue: Account.API = .init(
        login: unimplemented(),
        fetchNewToken: unimplemented(), 
        refresh: unimplemented()
    )
}
