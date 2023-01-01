//
//  File.swift
//  
//
//  Created by 한상진 on 2022/12/30.
//

import TogetherCore
import ComposableArchitecture

public struct TabBar: ReducerProtocol {
    public enum Tab: String, CaseIterable { 
        case home = "홈"
        case setting = "설정"
    }
    
    public struct State: Equatable {
        var home: Home.State
        var setting: Setting.State
        var currentTab: Tab
        
        public init (
            home: Home.State,
            setting: Setting.State,
            Tab: Tab = Tab.home
        ) {
            self.home = home
            self.setting = setting
            self.currentTab = Tab
        }
    }
    
    public enum Action: Equatable {
        case home(Home.Action)
        case setting(Setting.Action)
        case selectTab(Tab)
    }
    
    public init() { }
    
    public var body: some ReducerProtocol<State, Action> {
        Scope(state: \.home, action: /Action.home) {
            Home()
        }
        
        Scope(state: \.setting, action: /Action.setting) {
            Setting()
        }
        
        Reduce { state, action in
            switch action {
            case .home, .setting:
                return .none
                
            case let .selectTab(tab):
                state.currentTab = tab
                return .none
            }    
        }
    }

}
