//
//  File.swift
//  
//
//  Created by 한상진 on 2022/12/30.
//

import TogetherCore
import ComposableArchitecture

public struct Tab: ReducerProtocol {
    public struct State: Equatable {
        var home: Home.State
        var setting: Setting.State
        
        public init (
            home: Home.State,
            setting: Setting.State
        ) {
            self.home = home
            self.setting = setting
        }
    }
    
    public enum Action: Equatable {
        case home(Home.Action)
        case setting(Setting.State)
    }
    
    public init() { }
    
    public func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .home:
            return .none
            
        case .setting:
            return .none
        }
    }

}
