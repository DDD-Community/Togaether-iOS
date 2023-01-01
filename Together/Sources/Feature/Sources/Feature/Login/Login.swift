//
//  File.swift
//  
//
//  Created by 한상진 on 2022/12/24.
//

import Foundation

import TogetherCore
import TogetherFoundation
import ThirdParty

import ComposableArchitecture

public struct Login: ReducerProtocol {
    public struct State: Equatable {
        var email: String
        var isEmailValidate: Bool
        
        var password: String
        var isPasswordValidate: Bool
        
        var isLoginAvailable: Bool { isEmailValidate && isPasswordValidate }
        
        var optionalOnboarding: Onboarding.State?
        var optionalTab: TabBar.State?
        
        public init(
            email: String = "",
            isEmailValidate: Bool = false,
            password: String = "",
            isPasswordValidate: Bool = false
        ) { 
            self.email = email
            self.isEmailValidate = isEmailValidate
            self.password = password
            self.isPasswordValidate = isPasswordValidate
        }
    }
    
    public enum Action: Equatable {
        case didChangeEmail(String)
        case emailValidateResponse(Bool)
        
        case didChangePassword(String)
        case passwordValidateResponse(Bool)
        
        case didTapLoginButton
        case loginResponse(TaskResult<String>)
        
        case didTapFindIDButton
        case didTapFindPasswordButton
        
        case optionalOnboarding(Onboarding.Action)
        case optionalTab(TabBar.Action)
    }
    
    public init() { }
    
    @Dependency(\.togetherAccount) var togetherAccount
    @Dependency(\.validator) var validator
    private enum LoginCancelID { }
    
    public var body: some ReducerProtocol<State, Action> {
        Reduce(reduce)
            ._printChanges()
            .ifLet(\.optionalOnboarding, action: /Action.optionalOnboarding) { 
                Onboarding()
            }
            .ifLet(\.optionalTab, action: /Action.optionalTab) { 
                TabBar()
            }
    }
    
    public func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case let .didChangeEmail(email):
            state.email = email
            return .task { [email = state.email] in
                let isEmailValidate: Bool = validator.validateEmail(email)
                return .emailValidateResponse(isEmailValidate)
            }
            
        case let .emailValidateResponse(isEmailValidate):
            state.isEmailValidate = isEmailValidate
            return .none
            
        case let .didChangePassword(password):
            state.password = password
            return .task { [password = state.password] in
                let isPasswordValidate: Bool = validator.validatePassword(password)
                return .passwordValidateResponse(isPasswordValidate)
            }
            
        case let .passwordValidateResponse(isPasswordValidate):
            state.isPasswordValidate = isPasswordValidate
            return .none
            
        case .didTapLoginButton:
            return .task { [email = state.email, password = state.password] in
                await .loginResponse(
                    TaskResult { 
                        try await togetherAccount.login(email, password) 
                    }
                ) 
            }
            .cancellable(id: LoginCancelID.self)
            
        case .didTapFindIDButton:
            return .none
            
        case .didTapFindPasswordButton:
            return .none
            
        case let .loginResponse(.success(token)):
            if Preferences.shared.onboardingFinished {
                state.optionalOnboarding = nil
                state.optionalTab = .init(home: .init(), setting: .init())
            } else {
                state.optionalOnboarding = .init()
                state.optionalTab = nil
            }
            
            return .none
             
        case let .loginResponse(.failure(error)):
            return .none
            
        case .optionalOnboarding:
            return .none
            
        case .optionalTab:
            return .none
        }
    }
}
