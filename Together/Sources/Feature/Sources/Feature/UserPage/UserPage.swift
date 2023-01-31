//
//  UserPage.swift
//  
//
//  Created by denny on 2023/01/31.
//

import ComposableArchitecture
import TogetherCore

public struct UserPage: ReducerProtocol {
    public struct State: Equatable {
        var postDetail: PostDetail.State?

        public init() { }
    }

    public enum Action: Equatable {
        case postDetail(PostDetail.Action)
        case didTapPost
        case detachChild
    }

    public init() { }

    public var body: some ReducerProtocolOf<Self> {
        Reduce(core)
    }

    public func core(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .postDetail(.detachChild):
            state.postDetail = nil
            return .none
        case .didTapPost:
            state.postDetail = .init()
            return .none
        case .detachChild:
            return .none

        default:
            return .none
        }
    }

}
