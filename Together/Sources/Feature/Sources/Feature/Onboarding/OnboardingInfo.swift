//
//  File.swift
//  
//
//  Created by 한상진 on 2022/12/26.
//

import TogetherCore
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
        
        var onboardingSpecies: OnboardingSpecies.State?
        
        public init() { }
    }
    
    public enum Action: Equatable {
        case didChangeName(String)
        case didSelectGender(Gender)
        case didChangeBirth(String)
        
        case didTapSkipButton
        case didTapNextButton
        
        case onboardingSpecies(OnboardingSpecies.Action)
        case detachChild
    }
    
    public init() { }
    
    public var body: some ReducerProtocol<State, Action> {
        Reduce(core)
            ._printChanges()
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
            return .none
            
        case .didTapSkipButton:
            return .none
            
        case .didTapNextButton:
            state.onboardingSpecies = .init()
            return .none
            
        case .detachChild:
            state.onboardingSpecies = nil
            return .none
        }
    }

}
