import Foundation

import ThirdParty
import ComposableArchitecture
import XCTestDynamicOverlay

public struct TogetherAccount {
    // xAuth
    // kicout
    public var token: @Sendable () async throws -> TogetherCredential
    public var login: @Sendable (_ email: String, _ password: String) async throws -> TogetherCredential
    public var logout: @Sendable () async -> Void
}

extension TogetherAccount: DependencyKey {
    public static var liveValue: TogetherAccount {
        @Dependency(\.tokenStorage) var tokenStorage
        @Dependency(\.togetherNetwork) var togetherNetwork
        
        return TogetherAccount(
            token: {
                // 캐시된 토큰이 있고, valid해야함
                guard let cachedToken = await tokenStorage.load() else { throw AccountError.emptyCredential }
                guard !cachedToken.isRefreshTokenInvalid else { throw AccountError.invalidToken }
                
                // 만약 엑세스토큰 만료 생기면 추가해야함
                guard !cachedToken.isAccessTokenInvalid else { return try await refresh(old: cachedToken) }
                
                return cachedToken
            }, 
            login: { email, password in
                let newCredential = try await togetherNetwork.fetchNewToken()
                await tokenStorage.store(credential: newCredential)
                return newCredential
            },
            logout: {
                try? await Task.sleep(for: .seconds(0.5))
            }
        )
    }
    
    private static func refresh(old credential: TogetherCredential) async throws -> TogetherCredential {
        @Dependency(\.tokenStorage) var tokenStorage
        @Dependency(\.togetherNetwork) var togetherNetwork
        
        let newCredential: TogetherCredential = try await togetherNetwork.refresh(credential)
        await tokenStorage.store(credential: newCredential)
        return newCredential
    }
}

extension TogetherAccount {
    public static let testValue: TogetherAccount = .init(
        token: unimplemented("\(Self.self).token"), 
        login: unimplemented("\(Self.self).login"),
        logout: unimplemented("\(Self.self).logout")
    )
}

extension DependencyValues {
    public var togetherAccount: TogetherAccount {
        get { self[TogetherAccount.self] }
        set { self[TogetherAccount.self] = newValue }
    }
}
