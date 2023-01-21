//
//  MyPage.swift
//  
//
//  Created by denny on 2023/01/19.
//

import ComposableArchitecture
import TogetherCore

public struct MyPage: ReducerProtocol {
    public struct State: Equatable {
        var myPageSetting: Setting.State?

        public init(myPageSetting: Setting.State? = nil) {
            self.myPageSetting = myPageSetting
        }
    }

    public enum Action: Equatable {
        case myPageSetting(Setting.Action)

        case didTapSetting
    }

    public init() { }

    public var body: some ReducerProtocolOf<Self> {
        Reduce(core)
            .ifLet(\.myPageSetting, action: /Action.myPageSetting) {
                Setting()
            }
    }

    public func core(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .myPageSetting(.detachChild):
            state.myPageSetting = nil
            return .none
        case .didTapSetting:
            state.myPageSetting = .init()
            return .none
        default:
            return .none
        }
    }

}
