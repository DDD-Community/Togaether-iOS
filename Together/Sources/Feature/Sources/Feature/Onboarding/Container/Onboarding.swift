//
//  File.swift
//  
//
//  Created by 한상진 on 2023/01/12.
//

import TogetherCore
import TogetherFoundation
import ComposableArchitecture

public struct Onboarding: ReducerProtocol {
    public struct State: Equatable {
        var onboardingInfo: OnboardingInfo.State
        var onboardingSpecies: OnboardingSpecies.State?
        var onboardingRegister: OnboardingFeedRegister.State?
        public init(
            onboardingInfo: OnboardingInfo.State = .init(),
            onboardingSpecies: OnboardingSpecies.State? = nil,
            onboardingRegister: OnboardingFeedRegister.State? = nil
        ) {
            self.onboardingInfo = onboardingInfo
            self.onboardingSpecies = onboardingSpecies
            self.onboardingRegister = onboardingRegister
        }
    }
    
    public enum Action: Equatable {
        case onboardingInfo(OnboardingInfo.Action)
        case onboardingSpecies(OnboardingSpecies.Action)
        case onboardingRegister(OnboardingFeedRegister.Action)
        case delegate(DelegateAction)
    }
    
    public enum DelegateAction: Equatable {
        case routeToTab
        case onboardingDismissed
    }
    
    public init() { }
    
    public var body: some ReducerProtocolOf<Self> {
        Scope(state: \.onboardingInfo, action: /Action.onboardingInfo) { 
            OnboardingInfo()
        }
        
        Reduce(core)
            .ifLet(\.onboardingSpecies, action: /Action.onboardingSpecies) { 
                OnboardingSpecies()
            }
            .ifLet(\.onboardingRegister, action: /Action.onboardingRegister) {
                OnboardingFeedRegister()
            }
    }
    
    public func core(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .onboardingInfo(.didTapSkipButton), 
                .onboardingSpecies(.didTapSkipButton),
                .onboardingRegister(.didTapSkipButton),
                .onboardingRegister(.didTapNextButton):
            Preferences.shared.onboardingFinished = true
            return .task { return .delegate(.routeToTab) }
            
        case .onboardingInfo(.didTapNextButton):
            state.onboardingSpecies = .init(petName: state.onboardingInfo.name)
            return .none
            
        case .onboardingSpecies(.didTapNextButton):
            state.onboardingRegister = .init(feedRegister: .init(), navigationTitle: "3/3")
            return .none
            
        case .onboardingInfo(.detachChild):
            state.onboardingSpecies = nil
            return .none
            
        case .onboardingSpecies(.detachChild):
            state.onboardingRegister = nil
            return .none
            
        case .onboardingRegister(.detachChild):
            return .none
            
        case .onboardingInfo, .onboardingSpecies, .onboardingRegister:
            return .none
            
        case .delegate:
            return .none
        }
    }
    
}

