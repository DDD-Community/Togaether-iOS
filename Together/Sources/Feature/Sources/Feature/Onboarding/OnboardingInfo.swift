//
//  File.swift
//  
//
//  Created by 한상진 on 2022/12/26.
//

import TogetherCore
import TogetherFoundation
import ComposableArchitecture

public struct OnboardingInfo: ReducerProtocol {
    public enum Gender {
        case male
        case female
    }
    
    public struct State: Equatable {
        var name: String = ""
        var gender: Gender?
        var birth: String = ""
        var isBirthValid: Bool?
        
        var canMoveNext: Bool { name.isNotEmpty && gender.isNotNil && isBirthValid.isTrue }
        
        public init() { }
    }
    
    public enum Action: Equatable {
        case didChangeName(String)
        case didSelectGender(Gender)
        case didChangeBirth(String)
        case birthValidateResponse(Bool?)
        
        case didTapSkipButton
        case didTapNextButton
        
        case detachChild
    }
    
    @Dependency(\.validator) var validator
    
    public init() { }
    
    public var body: some ReducerProtocol<State, Action> {
        Reduce(core)
    }
    
    public func core(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case let .didChangeName(name):
            state.name = name
            return .none
            
        case let .didSelectGender(gender):
            state.gender = gender
            return .none
            
        case let .didChangeBirth(birth):
            state.birth = birth
            return .task { [birth = state.birth] in
                return .birthValidateResponse(validator.validateBirth(birth))
            }
            
        case let .birthValidateResponse(isBirthValid):
            state.isBirthValid = isBirthValid
            return .none
            
        case .didTapSkipButton, .didTapNextButton, .detachChild: // Onboarding Reducer에서 처리
            return .none
        }
    }

}
