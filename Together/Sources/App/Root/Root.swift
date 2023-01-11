//
//  Root.swift
//  
//
//  Created by 한상진 on 2022/12/22.
//

import Foundation

import Feature
import TogetherCore
import TogetherFoundation
import ThirdParty

import ComposableArchitecture

struct Root: ReducerProtocol {
    enum State: Equatable {
        case root
        case login(Login.State)
        case onboarding(OnboardingInfo.State)
        case tab(TabBar.State)
    }
    
    enum Action: Equatable {
        case viewDidAppear
        case tokenResponse(TaskResult<String>)
        
        case login(Login.Action)
        case onboarding(OnboardingInfo.Action)
        case tab(TabBar.Action)
    }
    
    @Dependency(\.togetherAccount) var togetherAccount
    private enum TokenCancelID { }
    
    var body: some ReducerProtocol<State,Action> {
        Reduce { state, action in
            switch action {
            case .viewDidAppear:
                return .task {
                    await .tokenResponse(TaskResult { try await togetherAccount.token() })
                }
                .cancellable(id: TokenCancelID.self)
                
            case let .tokenResponse(.success(token)):
                if Preferences.shared.onboardingFinished {
                    state = .tab(.init(home: .init(), setting: .init()))
                } else {
                    state = .onboarding(.init())
                }
                
                return .none
                
            case let .tokenResponse(.failure(error)):
                state = .login(.init())
                return .none
                
            case .login:
                return .none
                
            case .onboarding:
                return .none
                
            case .tab:
                return .none
            }
        }
        .ifCaseLet(/State.login, action: /Action.login) { 
            Login()
        }
        .ifCaseLet(/State.onboarding, action: /Action.onboarding) { 
            OnboardingInfo()
        }
        .ifCaseLet(/State.tab, action: /Action.tab) { 
            TabBar()
        }
    }
}
