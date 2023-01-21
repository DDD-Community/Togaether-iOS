//
//  TabBar.swift
//

import TogetherCore
import ComposableArchitecture

public struct TabBar: ReducerProtocol {
    public enum Tab: String, CaseIterable { 
        case home = "홈"
        case agora = "광장"
        case today = "투데이"
        case mypage = "MY"
    }
    
    public struct State: Equatable {
        var home: Home.State
        var agora: Agora.State
        var today: Today.State
        var mypage: MyPage.State
        var currentTab: Tab
        
        public init (
            home: Home.State,
            agora: Agora.State,
            today: Today.State,
            mypage: MyPage.State,
            Tab: Tab = Tab.home
        ) {
            self.home = home
            self.agora = agora
            self.today = today
            self.mypage = mypage
            self.currentTab = Tab
        }
    }
    
    public enum Action: Equatable {
        case home(Home.Action)
        case agora(Agora.Action)
        case today(Today.Action)
        case mypage(MyPage.Action)
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
        
        Scope(state: \.mypage, action: /Action.mypage) {
            MyPage()
        }
        
        Reduce { state, action in
            switch action {
            case .home, .agora, .today, .mypage:
                return .none
                
            case let .selectTab(tab):
                state.currentTab = tab
                return .none
            }    
        }
    }

}
