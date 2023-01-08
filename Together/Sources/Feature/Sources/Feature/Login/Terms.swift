//
//  File.swift
//  
//
//  Created by 한상진 on 2023/01/08.
//

import TogetherCore
import ComposableArchitecture

public struct Terms: ReducerProtocol {
    public struct State: Equatable {
        var overFourteen: Bool = false
        var termsAndConditionAgreed: Bool = false
        var collectPersonalInformationAgreed: Bool = false
        
        var allAgreed: Bool {
            get { return overFourteen && termsAndConditionAgreed && collectPersonalInformationAgreed }
            set {
                overFourteen = newValue
                termsAndConditionAgreed = newValue
                collectPersonalInformationAgreed = newValue
            }
        }
    }
    
    public enum Action: Equatable {
        case didTapAllAgree
        case didTapOverFourteen
        case didTapTermsAndCondition
        case didTapPersionalInformation
        
        case didTapNext
    }
    
    public init() { }
    
    public var body: some ReducerProtocol<State, Action> {
        Reduce(reduce)
            ._printChanges()
    }
    
    public func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .didTapAllAgree:
            if state.allAgreed {
                state.overFourteen = false
                state.termsAndConditionAgreed = false
                state.collectPersonalInformationAgreed = false    
            } else {
                state.overFourteen = true
                state.termsAndConditionAgreed = true
                state.collectPersonalInformationAgreed = true
            }
            return .none
            
        case .didTapOverFourteen:
            state.overFourteen = !state.overFourteen 
            return .none
            
        case .didTapTermsAndCondition:
            state.termsAndConditionAgreed = !state.termsAndConditionAgreed
            return .none
            
        case .didTapPersionalInformation:
            state.collectPersonalInformationAgreed = !state.collectPersonalInformationAgreed
            return .none
            
        case .didTapNext:
            return .none
        }
    }
    
}

