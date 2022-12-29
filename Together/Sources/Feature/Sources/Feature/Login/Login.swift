//
//  File.swift
//  
//
//  Created by 한상진 on 2022/12/24.
//

import TogetherCore
import ComposableArchitecture

public struct Login: ReducerProtocol {
    public struct State: Equatable {
        var id: String
        var password: String
        
        public init(id: String = "", password: String = "") { 
            self.id = id
            self.password = password
        }
    }
    
    public enum Action: Equatable {
        case loginButtonDidTapped
        case loginResponse(TaskResult<String>)
    }
    
    public init() { }
    
    @Dependency(\.togetherAccount) var togetherAccount
    private enum LoginCancelID { }
    
    public var body: some ReducerProtocol<State, Action> {
        Reduce(reduce)
    }
    
    public func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .loginButtonDidTapped:
            print("\(Self.self): 로그인 버튼 눌림")
            return .task { [id = state.id, password = state.password] in
                await .loginResponse(
                    TaskResult { 
                        try await togetherAccount.login(id, password) 
                    }
                ) 
            }
            .cancellable(id: LoginCancelID.self)
            
        case let .loginResponse(.success(token)):
            print("\(Self.self): 로그인 성공 token \(token)")
            return .none
             
        case let .loginResponse(.failure(error)):
            print("\(Self.self): 로그인 실패 error \(error)")
            return .none
        }
    }
}
