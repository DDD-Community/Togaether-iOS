//
//  PetInfo.swift
//  
//
//  Created by denny on 2023/01/18.
//

import ComposableArchitecture
import TogetherCore

public struct PetInfo: ReducerProtocol {
    public struct State: Equatable, Sendable {
        public init() { }
    }

    public enum Action: Equatable, Sendable {
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
