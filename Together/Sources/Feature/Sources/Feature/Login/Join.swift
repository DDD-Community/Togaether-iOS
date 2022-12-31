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
        case emailDidChanged(String)
        case passwordDidChanged(String)
        case passwordConfirmDidChanged(String)
        case nameDidChanged(String)
        case birthDidChanged(String)
        case phoneNumberDidChanged(String)
        
        case confirmButtonClicked
    }
    
    init() { }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case let .emailDidChanged(email):
            state.email = email
            return .none
            
        case let .passwordDidChanged(password):
            state.password = password
            return .none
            
        case let .passwordConfirmDidChanged(passwordConfirm):
            state.passwordConfirm = passwordConfirm
            return .none
            
        case let .nameDidChanged(name):
            state.name = name
            return .none
            
        case let .birthDidChanged(birth):
            state.birth = birth
            return .none
            
        case let .phoneNumberDidChanged(phoneNumber):
            state.phoneNumber = phoneNumber
            return .none
            
        case .confirmButtonClicked:
            return .none
        }
    }
    
}
