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
        var isEmailValid: Bool?
        
        var password: String
        var isPasswordValid: Bool?
        
        var isLoginAvailable: Bool { isEmailValid == true && isPasswordValid == true }
        var isLoginInflight: Bool = false
        var alert: AlertState<Action>?
        
//        var optionalOnboarding: Onboarding.State?
        var optionalTerms: Terms.State?
//        var optionalTab: TabBar.State?
        
        public init(
            email: String = "",
            isEmailValid: Bool? = nil,
            password: String = "",
            isPasswordValid: Bool? = nil
        ) { 
            self.email = email
            self.isEmailValid = isEmailValid
            self.password = password
            self.isPasswordValid = isPasswordValid
        }
    }
    
    public enum Action: Equatable {
        case didChangeEmail(String)
        case emailValidateResponse(Bool?)
        
        case didChangePassword(String)
        case passwordValidateResponse(Bool?)
        
        case didTapLoginButton
        case loginResponse(TaskResult<LoginResponse>)
        case alertDismissed
        
        case didTapFindIDButton
        case didTapFindPasswordButton
        case didTapJoinButton
        
//        case optionalOnboarding(Onboarding.Action)
        case optionalTerms(Terms.Action)
//        case optionalTab(TabBar.Action)
        
        case detachChild
    }
    
    public init() { }
    
    @Dependency(\.togetherAccount.login) var login
    @Dependency(\.validator) var validator
    private enum LoginCancelID { }
    
    public var body: some ReducerProtocolOf<Self> {
        Reduce(core)
//            .ifLet(\.optionalOnboarding, action: /Action.optionalOnboarding) { 
//                Onboarding()
//            }
            .ifLet(\.optionalTerms, action: /Action.optionalTerms) {
                Terms()
            }
//            .ifLet(\.optionalTab, action: /Action.optionalTab) { 
//                TabBar()
//            }
    }
    
    public func core(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case let .didChangeEmail(email):
            state.email = email
            return .task { [email = state.email] in
                let isEmailValid: Bool? = validator.validateEmail(email)
                return .emailValidateResponse(isEmailValid)
            }
            
        case let .emailValidateResponse(isEmailValid):
            state.isEmailValid = isEmailValid
            return .none
            
        case let .didChangePassword(password):
            state.password = password
            return .task { [password = state.password] in
                let isPasswordValid: Bool? = validator.validatePassword(password)
                return .passwordValidateResponse(isPasswordValid)
            }
            
        case let .passwordValidateResponse(isPasswordValid):
            state.isPasswordValid = isPasswordValid
            return .none
            
        case .didTapLoginButton:
            state.isLoginInflight = true
            state.alert = nil
            return .task { [email = state.email, password = state.password] in
                await .loginResponse(
                    TaskResult { 
                        try await login(email, password) 
                    }
                ) 
            }
            .cancellable(id: LoginCancelID.self)
            
        case .didTapFindIDButton:
            return .none
            
        case .didTapFindPasswordButton:
            return .none
            
        case .didTapJoinButton:
            state.optionalTerms = .init()
            return .none
            
        case let .loginResponse(.success(response)):
            print("Login Success token: \(response.credential)")
            
            state.isLoginInflight = false
            
//            if Preferences.shared.onboardingFinished == true {
//                state.optionalTab = .init(home: .init(), agora: .init(), today: .init(), mypage: .init())
//            } else {
//                state.optionalOnboarding = .init()
//            }
            
            return .none
             
        case let .loginResponse(.failure(error)):
            print("Login Failure error: \(error)")
            state.isLoginInflight = false
            state.alert = .init(
                title: { 
                    TextState("로그인 실패")
                }, 
                actions: { 
                    ButtonState(action: .alertDismissed) {
                        TextState("취소")
                    }
                    ButtonState(action: .didTapLoginButton) {
                        TextState("다시시도")
                    }
                }
            )
            return .none
            
        case .alertDismissed:
            state.alert = nil
            return .none
            
//        case .optionalOnboarding(.delegate(.routeToTab)):
//            state.optionalOnboarding = nil
//            state.optionalTab = .init(home: .init(), agora: .init(), today: .init(), mypage: .init())
//            return .none
//            
//        case .optionalOnboarding:
//            return .none
            
        case .optionalTerms(.optionalJoin(.joinResponse(.success))):
            state.optionalTerms = nil
            state.alert = .init(
                title: { 
                    TextState("회원가입 성공 :)")
                }, actions: { 
                    ButtonState(action: .alertDismissed) { 
                        TextState("확인")
                    }
                }, message: { 
                    TextState("로그인을 진행해주세요.")
                }
            )
            return .none
            
        case .optionalTerms:
            return .none
            
//        case .optionalTab:
//            return .none
            
        case .detachChild:
//            state.optionalTab = nil
            state.optionalTerms = nil
//            state.optionalOnboarding = nil
            return .none
        }
    }
}
