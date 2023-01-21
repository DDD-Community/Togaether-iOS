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
        @BindableState var name: String = ""
        @BindableState var gender: Gender?
        @BindableState var birth: String = ""
        var isBirthValid: Bool?
        
        var canMoveNext: Bool { name.isNotEmpty && gender.isNotNil && isBirthValid.isTrue }
        
        public init(
            name: String = "",
            gender: Gender? = nil,
            birth: String = "",
            isBirthValid: Bool? = nil
        ) { 
            self.name = name
            self.gender = gender
            self.birth = birth
            self.isBirthValid = isBirthValid
        }
    }
    
    public enum Action: Equatable, BindableAction {
        case binding(BindingAction<State>)
        case didTapSkipButton
        case didTapNextButton
        case detachChild
    }
    
    @Dependency(\.validator) var validator
    
    public init() { }
    
    public var body: some ReducerProtocolOf<Self> {
        BindingReducer()
        Reduce(core)
    }
    
    public func core(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .binding(\.$birth):
            state.isBirthValid = validator.validateBirth(state.birth)
            return .none
            
        case .binding:
            return .none
            
        case .didTapSkipButton, .didTapNextButton, .detachChild: // Onboarding Reducer에서 처리
            return .none
        }
    }
}
