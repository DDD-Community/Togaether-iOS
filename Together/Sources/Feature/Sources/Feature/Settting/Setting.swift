//
//  File.swift
//  
//
//  Created by 한상진 on 2022/12/30.
//

import TogetherCore
import ComposableArchitecture

public struct Setting: ReducerProtocol {
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
