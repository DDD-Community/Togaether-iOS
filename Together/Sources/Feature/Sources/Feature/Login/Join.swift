//
//  File.swift
//  
//
//  Created by 한상진 on 2023/01/01.
//

import TogetherCore
import ComposableArchitecture

struct Join: ReducerProtocol {
    struct State: Equatable {
        var email: String = ""
        var password: String = ""
        var passwordConfirm: String = ""
        var name: String = ""
        var birth: String = ""
        var phoneNumber: String = ""
    }
    
    enum Action: Equatable {
        case didChangeEmail(String)
        case didChangePassword(String)
        case didChangePasswordConfirm(String)
        case didChangeName(String)
        case didChangeBirth(String)
        case didChangePhoneNumber(String)
        
        case confirmButtonClicked
    }
    
    init() { }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case let .didChangeEmail(email):
            state.email = email
            return .none
            
        case let .didChangePassword(password):
            state.password = password
            return .none
            
        case let .didChangePasswordConfirm(passwordConfirm):
            state.passwordConfirm = passwordConfirm
            return .none
            
        case let .didChangeName(name):
            state.name = name
            return .none
            
        case let .didChangeBirth(birth):
            state.birth = birth
            return .none
            
        case let .didChangePhoneNumber(phoneNumber):
            state.phoneNumber = phoneNumber
            return .none
            
        case .confirmButtonClicked:
            return .none
        }
    }
    
}
