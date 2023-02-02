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
            isBirthValid == true
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
        case joinResponse(TaskResult<JoinResponse>)
        
        case detachChild
    }
    
    @Dependency(\.validator) var validator
    @Dependency(\.togetherAccount.join) var join
    
    public init() { }
    
    public var body: some ReducerProtocolOf<Self> {
        Reduce(core)
    }
    
    public func core(into state: inout State, action: Action) -> EffectTask<Action> {
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
            return .task { [birth = state.birth] in
                return .birthValidateResponse(validator.validateBirth(birth))
            }
            
        case let .birthValidateResponse(isBirthValid):
            state.isBirthValid = isBirthValid
            return .none
            
        case let .didChangePhoneNumber(phoneNumber):
            state.phoneNumber = phoneNumber
            return .task { [phoneNumber = state.phoneNumber] in 
                return .phoneNumberValidateResponse(validator.validatePhoneNumber(phoneNumber))
            }
            
        case let .phoneNumberValidateResponse(isPhoneNumberValid):
            state.isPhoneNumberValid = isPhoneNumberValid
            return .none
            
        case .confirmButtonClicked:
            return .task { [state] in
                await .joinResponse(
                    TaskResult{
                        try await join(
                            state.email, 
                            state.password, 
                            state.name, 
                            state.birth
                        )
                    }
                )
            }
            
        case let .joinResponse(.success(joinResponse)):
            print("join success \(joinResponse)")
            return .none
            
        case let .joinResponse(.failure(error)):
            // 화면에 대한 에러 핸들링
            print("join fail \(error)")
            return .none
            
        case .detachChild:
            return .none
        }
    }
    
}
