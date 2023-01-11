//
//  File.swift
//  
//
//  Created by 한상진 on 2023/01/12.
//

import TogetherCore
import ComposableArchitecture

public struct OnboardingSpecies: ReducerProtocol {
    public struct State: Equatable {
        
    }
    
    public enum Action: Equatable {
        
    }
    
    public init() { }
    
    public var body: some ReducerProtocol<State, Action> {
        Reduce(core)
    }
    
    public func core(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
            
        }
    }
    
}

