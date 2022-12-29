//
//  Root.swift
//  
//
//  Created by 한상진 on 2022/12/22.
//

import Foundation

import Login
import Tab
import TogetherCore
import TogetherFoundation
import ThirdParty

import ComposableArchitecture

struct Root: ReducerProtocol {
    enum RootDestination {
        case home
        case onboarding
        case login
    }
    
    struct State: Equatable {
        var destination: RootDestination?
        var optionalLogin: Login.State?
    }
    
    enum Action: Equatable {
        case viewDidAppear
        case tokenResponse(TaskResult<String>)
        case optionalLogin(Login.Action)
    }
    
    @Dependency(\.togetherAccount) var togetherAccount
    private enum TokenCancelID { }
    
    var body: some ReducerProtocol<State,Action> {
        Reduce(reduce)
            .ifLet(\.optionalLogin, action: /Action.optionalLogin) { 
                Login()
            }
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .viewDidAppear:
            return .task {
                await .tokenResponse(TaskResult { try await togetherAccount.token() })
            }
            .cancellable(id: TokenCancelID.self)
            
        case let .tokenResponse(.success(token)):
            print("\(Self.self): auto login success token: \(token)")
            
            if Preferences.shared.onboardingFinished {
                state.destination = .home
            } else {
                print("\(Self.self): user needs onboarding")
                state.destination = .onboarding
            }
            
            return .none
            
        case let .tokenResponse(.failure(error)):
            print("\(Self.self): auto login failure error: \(error)")
            state.destination = .login
            return .none
            
        case let .optionalLogin(loginAction):
            switch loginAction {
            case let .loginResponse(.success(token)):
                print("\(Self.self): login success token: \(token)")
                state.destination = .home
                return .none
                
            default:
                return .none
            }
        }
    }
}
