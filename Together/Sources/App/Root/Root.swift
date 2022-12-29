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
    }
    
    enum Action: Equatable {
        case viewDidAppear
        case tokenResponse(TaskResult<String>)
        case optionalLogin(Login.Action)
        case optionalOnboarding(Onboarding.Action)
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
                print("\(Self.self): auto login success token: \(token)")
                
                if Preferences.shared.onboardingFinished {
                    state.optionalLogin = nil
                    state.optionalOnboarding = nil
                } else {
                    print("\(Self.self): user needs onboarding")
                    state.optionalLogin = nil
                    state.optionalOnboarding = nil
                }
                
                return .none
                
            case let .tokenResponse(.failure(error)):
                print("\(Self.self): auto login failure error: \(error)")
                state.optionalLogin = .init()
                state.optionalOnboarding = nil
                return .none
                
            case let .optionalLogin(loginAction):
                switch loginAction {
                case let .loginResponse(.success(token)):
                    print("\(Self.self): login success token: \(token)")
                    state.optionalLogin = nil
                    state.optionalOnboarding = .init()
                    return .none
                    
                default:
                    return .none
                }
                
            case .optionalOnboarding:
                return .none
            }
        }
        .ifLet(\.optionalLogin, action: /Action.optionalLogin) { 
            Login()
        }
        .ifLet(\.optionalOnboarding, action: /Action.optionalOnboarding) { 
            Onboarding()
        }
    }
}
