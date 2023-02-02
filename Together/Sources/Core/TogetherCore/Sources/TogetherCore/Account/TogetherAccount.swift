import Foundation

import ThirdParty
import ComposableArchitecture
import XCTestDynamicOverlay

public struct TogetherAccount {
    public var token: @Sendable () async throws -> TogetherCredential
    public var login: @Sendable (_ email: String, _ password: String) async throws -> LoginResponse
    public var logout: @Sendable () async -> Void
    public var join: @Sendable (
        _ email: String,
        _ password: String,
        _ name:  String,
        _ birth: String
    ) async throws  -> JoinResponse
    // kicout
}

public extension TogetherAccount {
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

extension TogetherAccount: DependencyKey {
    public static var liveValue: TogetherAccount {
        @Dependency(\.tokenStorage) var tokenStorage
        @Dependency(\.accountAPI) var accountAPI
        
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
                let loginResponse: LoginResponse = try await accountAPI.login(email, password)
                await tokenStorage.store(credential: loginResponse.credential)
                return loginResponse
            },
            logout: {
                try? await Task.sleep(for: .seconds(0.5))
            },
            join: { email, password, name, birth in
                let joinResponse: JoinResponse = try await accountAPI.join(email, password, name, birth)
                // do some more work
                return joinResponse
            }
        )
    }
    
    private static func refresh(old credential: TogetherCredential) async throws -> TogetherCredential {
        @Dependency(\.tokenStorage) var tokenStorage
        @Dependency(\.accountAPI) var accountAPI
        
        let newCredential: TogetherCredential = try await accountAPI.refresh(credential)
        await tokenStorage.store(credential: newCredential)
        return newCredential
    }
}

extension TogetherAccount {
    public static let testValue: TogetherAccount = .init(
        token: unimplemented("\(Self.self).token"), 
        login: unimplemented("\(Self.self).login"),
        logout: unimplemented("\(Self.self).logout"), 
        join: unimplemented("\(Self.self).join")
    )
}

extension DependencyValues {
    public var togetherAccount: TogetherAccount {
        get { self[TogetherAccount.self] }
        set { self[TogetherAccount.self] = newValue }
    }
}
