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
        var feedRegister: OnboardingFeedRegister.State?

        public init(myPageSetting: Setting.State? = nil) {
            self.myPageSetting = myPageSetting
        }
    }

    public enum Action: Equatable {
        case myPageSetting(Setting.Action)
        case feedRegister(OnboardingFeedRegister.Action)
        case didTapCreate
        case didTapSetting
    }

    public init() { }

    public var body: some ReducerProtocolOf<Self> {
        Reduce(core)
            .ifLet(\.myPageSetting, action: /Action.myPageSetting) {
                Setting()
            }
            .ifLet(\.feedRegister, action: /Action.feedRegister) { 
                OnboardingFeedRegister()
            }
    }

    public func core(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .myPageSetting(.detachChild):
            state.myPageSetting = nil
            return .none
            
        case .feedRegister(.detachChild):
            state.feedRegister = nil
            return .none
            
        case .didTapCreate:
            state.feedRegister = .init(feedRegister: .init(), navigationTitle: "게시물 등록")
            return .none
            
        case .didTapSetting:
            state.myPageSetting = .init()
            return .none
            
        default:
            return .none
        }
    }

}
