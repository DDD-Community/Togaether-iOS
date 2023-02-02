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
        var join: @Sendable (
            _ email: String,
            _ password: String,
            _ name:  String,
            _ birth: String
        ) async throws -> JoinResponse
        var login: @Sendable (_ email: String, _ password: String) async throws -> LoginResponse
        var fetchNewToken: @Sendable () async throws -> TogetherCredential
        var refresh: @Sendable (_ old: TogetherCredential) async throws -> TogetherCredential
    }
}

public extension Account.API {
    func join(
        email: String,
        password: String,
        name:  String,
        birth: String
    ) async throws -> JoinResponse {
        try await self.join(email, password, name, birth)
    }
    
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
        join: { email, password, name, birth in
            // birth.toArray "19990101" -> [1999, 1, 1]
            return try await NetworkClient.account.request(
                convertible: "\(Host.together)/member", 
                method: .post,
                parameters: [
                    "email": email,
                    "password": password,
                    "name": name,
                    "birth": birth
                ],
                encoding: ParameterJSONEncoder()
            )
            .responseAsync()
        },
        login: { email, password in
            return try await NetworkClient.account.request(
                convertible: "\(Host.together)/sign-in/member", 
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
            // "새 토큰만 가져오는 로직 없음"
            throw AccountError.invalidToken
        },
        refresh: { credential in
            // "리프레쉬 타는 로직 없음"
            throw AccountError.invalidToken
        }
    )
    public static let testValue: Account.API = .init(
        join: unimplemented(), 
        login: unimplemented(),
        fetchNewToken: unimplemented(), 
        refresh: unimplemented()
    )
}
