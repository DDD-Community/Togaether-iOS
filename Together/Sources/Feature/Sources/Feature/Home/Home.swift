//
//  File.swift
//  
//
//  Created by 한상진 on 2022/12/30.
//

import ComposableArchitecture
import TogetherCore
import UIKit

public struct Home: ReducerProtocol {
    public struct State: Equatable, Sendable {
        public init() { }
    }
    
    public enum Action: Equatable, Sendable {
        
    }
    
    public init() { }
    
    public func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
            
        }
    }
    
}

