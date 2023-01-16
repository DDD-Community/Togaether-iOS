//
//  File.swift
//  
//
//  Created by 한상진 on 2023/01/08.
//

import TogetherCore
import ComposableArchitecture

public struct Terms: ReducerProtocol {
    public struct State: Equatable, Sendable {
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
        
        var optionalJoin: Join.State?
    }
    
    public enum Action: Equatable, Sendable {
        case didTapAllAgree
        case didTapOverFourteen
        case didTapTermsAndCondition
        case didTapPersionalInformation
        
        case didTapNext
        
        case optionalJoin(Join.Action)
        case detachChild
    }
    
    public init() { }
    
    public var body: some ReducerProtocolOf<Self> {
        Reduce(core)
            .ifLet(\.optionalJoin, action: /Action.optionalJoin) { 
                Join()
            }
    }
    
    public func core(into state: inout State, action: Action) -> EffectTask<Action> {
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
            state.optionalJoin = .init()
            return .none
            
        case .optionalJoin(.joinResponse(.success)):
            return .none
            
        case .optionalJoin:
            return .none
            
        case .detachChild:
            state.optionalJoin = nil
            return .none
        }
    }
    
}

