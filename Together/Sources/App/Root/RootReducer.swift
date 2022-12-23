//
//  Root.swift
//  
//
//  Created by 한상진 on 2022/12/22.
//

import Foundation

import TogetherCore
import TogetherFoundation
import ThirdParty

import ComposableArchitecture

struct Root: ReducerProtocol {
    struct State: Equatable {
        var token: String?
    }
    
    enum Action: Equatable {
        case viewDidLoad
        case tokenResponse(TaskResult<String>)
    }
    
    @Dependency(\.togetherAccount) var togetherAccount
    private enum TokenCancelID { }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .viewDidLoad:
            return .task {
                await .tokenResponse(TaskResult { try await togetherAccount.token() })
            }
            .cancellable(id: TokenCancelID.self)
            
        case let .tokenResponse(.success(token)):
            state.token = token
            print(token)
            return .none
            
        case let .tokenResponse(.failure(error)):
            print(error)
            return .none
        }
    }
}
