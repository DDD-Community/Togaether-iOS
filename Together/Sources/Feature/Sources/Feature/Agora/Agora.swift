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
        var userPage: UserPage.State?
        public init() { }
    }

    public enum Action: Equatable {
        case userPage(UserPage.Action)
        case didTapAgoraItem
    }

    public init() { }

    public var body: some ReducerProtocolOf<Self> {
        Reduce(core)
            .ifLet(\.userPage, action: /Action.userPage) {
                UserPage()
            }
    }

    public func core(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .userPage(.detachChild):
            state.userPage = nil
            return .none
        case .didTapAgoraItem:
            state.userPage = .init()
            return .none
        default:
            return .none

        }
    }

}
