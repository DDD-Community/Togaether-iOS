//
//  Today.swift
//  
//
//  Created by denny on 2023/01/18.
//

import ComposableArchitecture
import TogetherCore

public struct Today: ReducerProtocol {
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
