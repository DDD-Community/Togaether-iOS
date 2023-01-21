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
        var tabBar: TabBar.State?
        public init(
            onboardingInfo: OnboardingInfo.State = .init(),
            onboardingSpecies: OnboardingSpecies.State? = nil,
            onboardingRegister: OnboardingFeedRegister.State? = nil,
            tabBar: TabBar.State? = nil
        ) {
            self.onboardingInfo = onboardingInfo
            self.onboardingSpecies = onboardingSpecies
            self.onboardingRegister = onboardingRegister
            self.tabBar = tabBar
        }
    }
    
    public enum Action: Equatable {
        case onboardingInfo(OnboardingInfo.Action)
        case onboardingSpecies(OnboardingSpecies.Action)
        case onboardingRegister(OnboardingFeedRegister.Action)
        case tabBar(TabBar.Action)
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
            .ifLet(\.tabBar, action: /Action.tabBar) { 
                TabBar()
            }
    }
    
    public func core(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .onboardingInfo(.didTapSkipButton), 
                .onboardingSpecies(.didTapSkipButton),
                .onboardingRegister(.didTapSkipButton):
            Preferences.shared.onboardingFinished = true
            state.tabBar = .init(home: .init(), agora: .init(), today: .init(), mypage: .init())
            return .none
            
        case .onboardingInfo(.didTapNextButton):
            state.onboardingSpecies = .init()
            return .none
            
        case .onboardingInfo(.detachChild):
            state.onboardingSpecies = nil
            return .none
            
        case .onboardingInfo:
            return .none
            
        case .onboardingSpecies(.didTapNextButton):
            state.onboardingRegister = .init(feedRegister: .init())
            return .none
            
        case .onboardingSpecies(.detachChild):
            state.onboardingRegister = nil
            return .none
            
        case .onboardingSpecies:
            return .none
            
        case .onboardingRegister:
            return .none
            
        case .tabBar:
            return .none
        }
    }
    
}

