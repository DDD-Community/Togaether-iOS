//
//  Home.swift
//  
//

import ComposableArchitecture
import TogetherCore

public struct Home: ReducerProtocol {
    public struct State: Equatable {
        public init() { }
    }
    
    public enum Action: Equatable {
        
    }
    
    public init() { }
    
    public func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
            
        }
    }
    
}

