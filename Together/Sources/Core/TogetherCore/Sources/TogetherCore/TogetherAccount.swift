import ThirdParty
import ComposableArchitecture
import XCTestDynamicOverlay

public struct TogetherAccount {
//    public init(token: @Sendable () async throws -> String) {
//        self.token = token
//    }
    public var token: @Sendable () async throws -> String
}

extension DependencyValues {
    public var togetherAccount: TogetherAccount {
        get { self[TogetherAccount.self] }
        set { self[TogetherAccount.self] = newValue }
    }
}

extension TogetherAccount: DependencyKey {
    public static let liveValue: TogetherAccount = .init(
        token: {
            try await Task.sleep(for: .seconds(1))
            return "havi"
        }
    )
    
    public static let testValue: TogetherAccount = .init(token: unimplemented("\(Self.self).token"))
}
