//
//  File.swift
//  
//
//  Created by 한상진 on 2023/01/12.
//

import TogetherCore
import ComposableArchitecture

public struct FeedRegister: ReducerProtocol {
    public struct State: Equatable {
        
    }
    
    public enum Action: Equatable {
        case didTapPhotoImageView
    }
    
    public init() { }
    
    public var body: some ReducerProtocolOf<Self> {
        Reduce(core)
    }
    
    public func core(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .didTapPhotoImageView:
            return .none
        }
    }
    
}

