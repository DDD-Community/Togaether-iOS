//
//  File.swift
//  
//
//  Created by 한상진 on 2022/12/24.
//

import TogetherCore
import TogetherFoundation
import ThirdParty

import ComposableArchitecture

public struct Login: ReducerProtocol {
    public struct State: Equatable {
        var id: String
        var password: String
        
        var optionalOnboarding: Onboarding.State?
        var optionalTab: Tab.State?
        
        public init(id: String = "", password: String = "") { 
            self.id = id
            self.password = password
        }
    }
    
    public enum Action: Equatable {
        case loginButtonDidTapped
        case loginResponse(TaskResult<String>)
        
        case optionalOnboarding(Onboarding.Action)
        case optionalTab(Tab.Action)
    }
    
    public init() { }
    
    @Dependency(\.togetherAccount) var togetherAccount
    private enum LoginCancelID { }
    
    public var body: some ReducerProtocol<State, Action> {
        Reduce(reduce)
            .ifLet(\.optionalOnboarding, action: /Action.optionalOnboarding) { 
                Onboarding()
            }
            .ifLet(\.optionalTab, action: /Action.optionalTab) { 
                Tab()
            }
    }
    
    public func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .loginButtonDidTapped:
            print("\(Self.self): loginButtonDidTapped")
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
            
            if Preferences.shared.onboardingFinished {
                print("\(Self.self): routing to home")
                state.optionalOnboarding = nil
                state.optionalTab = .init(home: .init(), setting: .init())
            } else {
                print("\(Self.self): user needs onboarding")
                state.optionalOnboarding = .init()
                state.optionalTab = nil
            }
            
            return .none
             
        case let .loginResponse(.failure(error)):
            print("\(Self.self): 로그인 실패 error \(error)")
            return .none
            
        case .optionalOnboarding:
            return .none
            
        case .optionalTab:
            return .none
        }
    }
}
