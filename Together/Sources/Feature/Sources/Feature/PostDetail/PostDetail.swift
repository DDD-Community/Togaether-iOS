//
//  PostDetail.swift
//  
//
//  Created by denny on 2023/01/31.
//

import ComposableArchitecture
import TogetherCore

public struct PostDetail: ReducerProtocol {
    public struct State: Equatable {
        public init() { }
    }

    public enum Action: Equatable {
        case detachChild
    }

    public init() { }

    public func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .detachChild:
            return .none
        }
    }

}
