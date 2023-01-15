//
//  File.swift
//  
//
//  Created by 한상진 on 2023/01/15.
//

import TogetherCore
import ComposableArchitecture

public struct OnboardingFeedRegister: ReducerProtocol {
    public struct State: Equatable {
        var feedRegister: FeedRegister.State 
    }
    
    public enum Action: Equatable {
        case feedRegister(FeedRegister.Action)
        case didTapSkipButton
        case didTapNextButton
    }
    
    public init() { }
    
    public var body: some ReducerProtocol<State, Action> {
        Scope(state: \.feedRegister, action: /Action.feedRegister) { 
            FeedRegister()
        }
        
        Reduce(core)
    }
    
    public func core(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .feedRegister:
            return .none
            
        case .didTapSkipButton, .didTapNextButton:
            return .none
        }
    }
    
}
