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
    struct State: Equatable {
        var optionalLogin: Login.State?
        var optionalOnboarding: Onboarding.State?
        var optionalTab: TabBar.State?
    }
    
    enum Action: Equatable {
        case viewDidAppear
        case tokenResponse(TaskResult<String>)
        
        case optionalLogin(Login.Action)
        case optionalOnboarding(Onboarding.Action)
        case optionalTab(TabBar.Action)
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
                    state.optionalLogin = nil
                    state.optionalOnboarding = nil
                    state.optionalTab = .init(home: .init(), setting: .init())
                } else {
                    state.optionalLogin = nil
                    state.optionalOnboarding = nil
                    state.optionalTab = nil
                }
                
                return .none
                
            case let .tokenResponse(.failure(error)):
                state.optionalLogin = .init()
                state.optionalOnboarding = nil
                state.optionalTab = nil
                return .none
                
            case .optionalLogin:
                return .none
                
            case .optionalOnboarding:
                return .none
                
            case .optionalTab:
                return .none
            }
        }
        ._printChanges()
        .ifLet(\.optionalLogin, action: /Action.optionalLogin) { 
            Login()
        }
        .ifLet(\.optionalOnboarding, action: /Action.optionalOnboarding) { 
            Onboarding()
        }
        .ifLet(\.optionalTab, action: /Action.optionalTab) { 
            TabBar()
        }
    }
}
