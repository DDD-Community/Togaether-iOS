//
//  Agora.swift
//  
//
//  Created by denny on 2023/01/18.
//

import ComposableArchitecture
import TogetherCore

public struct Agora: ReducerProtocol {
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
