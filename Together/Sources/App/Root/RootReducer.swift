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
        var tokenResult: TaskResult<String>?
    }
    
    enum Action: Equatable {
        case viewDidAppear
        case tokenResponse(TaskResult<String>)
    }
    
    @Dependency(\.togetherAccount) var togetherAccount
    private enum TokenCancelID { }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .viewDidAppear:
            return .task {
                await .tokenResponse(TaskResult { try await togetherAccount.token() })
            }
            .cancellable(id: TokenCancelID.self)
            
        case let .tokenResponse(tokenResult):
            state.tokenResult = tokenResult
            return .none
        }
    }
}
