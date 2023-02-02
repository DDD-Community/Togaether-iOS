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

extension Account {
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

extension DependencyValues {
    var accountAPI: Account.API {
        get { self[Account.API.self] }
        set { self[Account.API.self] = newValue }
    }
}

extension Account.API: DependencyKey {
    static let liveValue: Account.API = .init(
        join: { email, password, name, birth in
            return try await NetworkClient.account.request(
                convertible: "\(Host.together)/member", 
                method: .post,
                parameters: [
                    "email": email,
                    "password": password,
                    "name": name,
                    "birth": birth.toDTO
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

private extension String {
    var toDTO: [Int] {
        let year = Int(self.subString(from: 0, to: 4)) ?? 2000
        let month = Int(self.subString(from: 4, to: 6)) ?? 1
        let day = Int(self.subString(from: 6, to: 8)) ?? 1
        return [year, month, day]
    }
}

private extension String {
    func subString(from: Int, to: Int) -> String {
       let startIndex = self.index(self.startIndex, offsetBy: from)
       let endIndex = self.index(self.startIndex, offsetBy: to)
       return String(self[startIndex..<endIndex])
    }
}
