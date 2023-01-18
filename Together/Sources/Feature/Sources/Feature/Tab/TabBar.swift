//
//  TabBar.swift
//

import TogetherCore
import ComposableArchitecture

public struct TabBar: ReducerProtocol {
    public enum Tab: String, CaseIterable, Sendable { 
        case home = "홈"
        case agora = "광장"
        case today = "투데이"
        case setting = "설정"
    }
    
    public struct State: Equatable, Sendable {
        var home: Home.State
        var agora: Agora.State
        var today: Today.State
        var setting: Setting.State
        var currentTab: Tab
        
        public init (
            home: Home.State,
            agora: Agora.State,
            today: Today.State,
            setting: Setting.State,
            Tab: Tab = Tab.home
        ) {
            self.home = home
            self.agora = agora
            self.today = today
            self.setting = setting
            self.currentTab = Tab
        }
    }
    
    public enum Action: Equatable, Sendable {
        case home(Home.Action)
        case agora(Agora.Action)
        case today(Today.Action)
        case setting(Setting.Action)
        case selectTab(Tab)
    }
    
    public init() { }
    
    public var body: some ReducerProtocolOf<Self> {
        Scope(state: \.home, action: /Action.home) {
            Home()
        }

        Scope(state: \.agora, action: /Action.agora) {
            Agora()
        }

        Scope(state: \.today, action: /Action.today) {
            Today()
        }
        
        Scope(state: \.setting, action: /Action.setting) {
            Setting()
        }
        
        Reduce { state, action in
            switch action {
            case .home, .agora, .today, .setting:
                return .none
                
            case let .selectTab(tab):
                state.currentTab = tab
                return .none
            }    
        }
    }

}
