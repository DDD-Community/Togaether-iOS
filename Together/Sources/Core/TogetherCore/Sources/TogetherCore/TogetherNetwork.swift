//
//  File.swift
//  
//
//  Created by 한상진 on 2022/12/04.
//

import Foundation
import ThirdParty
import ComposableArchitecture
import XCTestDynamicOverlay

struct TogetherNetwork {
    var fetchNewToken: @Sendable () async throws -> TogetherCredential
    var refresh: @Sendable (_ old: TogetherCredential) async throws -> TogetherCredential
}

extension DependencyValues {
    var togetherNetwork: TogetherNetwork {
        get { self[TogetherNetwork.self] }
        set { self[TogetherNetwork.self] = newValue }
    }
}

extension TogetherNetwork: DependencyKey {
    static let liveValue: TogetherNetwork = .init(
        fetchNewToken: { 
            let calendar = Calendar.current
            let date: Date = calendar.date(byAdding: .minute, value: 5, to: .init()) ?? .init()
            return .init(
                accessToken: "havi_access", 
                accessTokenExpiresAt: date, 
                refreshToken: "havi_refresh", 
                refreshTokenExpiresAt: date
            )
        },
        refresh: { credential in
            let calendar = Calendar.current
            let date: Date = calendar.date(byAdding: .minute, value: 5, to: .init()) ?? .init()
            return .init(
                accessToken: "havi_access", 
                accessTokenExpiresAt: date, 
                refreshToken: "havi_refresh", 
                refreshTokenExpiresAt: date
            )
        }
    )
    static let testValue: TogetherNetwork = .init(
        fetchNewToken: unimplemented(), 
        refresh: unimplemented()
    )
}
