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
        case onboarding(Onboarding.State)
        case tab(TabBar.State)
    }
    
    indirect enum Action: Equatable {
        case viewDidAppear
        case tokenResponse(TaskResult<TogetherCredential>)
        
        case root(Action)
        case login(Login.Action)
        case onboarding(Onboarding.Action)
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
                print("AutoLogin Success token: \(token)")
                
                if Preferences.shared.onboardingFinished == true {
                    state = .tab(.init(home: .init(), agora: .init(), today: .init(), mypage: .init()))
                } else {
                    state = .onboarding(.init())
                }
                
                return .none
                
            case let .tokenResponse(.failure(error)):
                print("AutoLogin Failure error: \(error)")
                state = .login(.init())
                return .none
                
            case .login(.loginResponse(.success)):
                
                if Preferences.shared.onboardingFinished == true {
                    state = .tab(.init(home: .init(), agora: .init(), today: .init(), mypage: .init()))
                } else {
                    state = .onboarding(.init())
                }
                
                return .none
                
            case .onboarding(.delegate(.routeToTab)):
                state = .tab(.init(home: .init(), agora: .init(), today: .init(), mypage: .init()))
                return .none
                
            case .login:
                return .none
                
            case .onboarding:
                return .none
                
            case .tab(.mypage(.myPageSetting(.routeToRoot))):
                state = .login(.init())
                return .none
                
            case .tab:
                return .none
                
            case .root:
                return .none
            }
        }
        .ifCaseLet(/State.login, action: /Action.login) { 
            Login()
        }
        .ifCaseLet(/State.onboarding, action: /Action.onboarding) { 
            Onboarding()
        }
        .ifCaseLet(/State.tab, action: /Action.tab) { 
            TabBar()
        }
    }
}
