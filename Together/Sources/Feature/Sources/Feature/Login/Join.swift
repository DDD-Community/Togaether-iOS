//
//  File.swift
//  
//
//  Created by 한상진 on 2023/01/01.
//

import TogetherCore
import ComposableArchitecture

public struct Join: ReducerProtocol {
    public struct State: Equatable {
        var email: String = ""
        var isEmailValid: Bool?
        
        var password: String = ""
        var isPasswordValid: Bool?
        
        var passwordConfirm: String = ""
        var isPasswordConfirmValid: Bool?
        
        var name: String = ""
        
        var birth: String = ""
        var isBirthValid: Bool?
        
        var phoneNumber: String = ""
        var isPhoneNumberValid: Bool?
        
        var isJoinAvailable: Bool {
            isEmailValid == true &&
            isPasswordValid == true &&
            isPasswordConfirmValid == true &&
            isBirthValid == true &&
            isPhoneNumberValid == true
        }
    }
    
    public enum Action: Equatable {
        case didChangeEmail(String)
        case emailValidateResponse(Bool?)
        
        case didChangePassword(String)
        case passwordValidateResponse(Bool?)
        
        case didChangePasswordConfirm(String)
        case passwordConfirmValidateResponse(Bool?)
        
        case didChangeName(String)
        
        case didChangeBirth(String)
        case birthValidateResponse(Bool?)
        
        case didChangePhoneNumber(String)
        case phoneNumberValidateResponse(Bool?)
        
        case confirmButtonClicked
//        
//        case setNavigation(isActive: Bool)
    }
    
    @Dependency(\.validator) var validator
    
    public init() { }
    
    public var body: some ReducerProtocol<State, Action> {
        Reduce(reduce)
            ._printChanges()
    }
    
    public func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case let .didChangeEmail(email):
            state.email = email
            return .task { [email = state.email] in
                return .emailValidateResponse(validator.validateEmail(email))
            }
            
        case let .emailValidateResponse(isEmailValid):
            state.isEmailValid = isEmailValid
            return .none
            
        case let .didChangePassword(password):
            state.password = password
            return .task { [password = state.password] in 
                return .passwordValidateResponse(validator.validatePassword(password))
            }
            
        case let .passwordValidateResponse(isPasswordValid):
            state.isPasswordValid = isPasswordValid
            return .none
            
        case let .didChangePasswordConfirm(passwordConfirm):
            state.passwordConfirm = passwordConfirm
            return .task { [passwordConfirm = state.passwordConfirm] in 
                return .passwordConfirmValidateResponse(validator.validatePassword(passwordConfirm))
            }
            
        case let .passwordConfirmValidateResponse(isPasswordConfirmValid):
            state.isPasswordConfirmValid = isPasswordConfirmValid
            return .none
            
        case let .didChangeName(name):
            state.name = name
            return .none
            
        case let .didChangeBirth(birth):
            state.birth = birth
            return .none
            
        case let .birthValidateResponse(isBirthValid):
            state.isBirthValid = isBirthValid
            return .task { [birth = state.birth] in
                return .birthValidateResponse(validator.validateBirth(birth))
            }
            
        case let .didChangePhoneNumber(phoneNumber):
            state.phoneNumber = phoneNumber
            return .task { [phoneNumber = state.phoneNumber] in 
                return .phoneNumberValidateResponse(validator.validatePhoneNumber(phoneNumber))
            }
            
        case let .phoneNumberValidateResponse(isPhoneNumberValid):
            state.isPhoneNumberValid = isPhoneNumberValid
            return .none
            
        case .confirmButtonClicked:
            return .none
        }
    }
    
}
