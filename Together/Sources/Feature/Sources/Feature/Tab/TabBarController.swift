//
//  TabBarController.swift
//
//

import UIKit
import Combine

import TogetherCore
import TogetherUI
import ThirdParty

import SwiftLayout
import ComposableArchitecture

public final class TabBarController: UITabBarController {
    
    private let store: StoreOf<TabBar>
    private let viewStore: ViewStoreOf<TabBar>
    private var cancellables: Set<AnyCancellable> = .init()
    
    @LayoutBuilder var layout: some SwiftLayout.Layout {
      view.sublayout {
          UIView()
      }
    }
    
    public init(store: StoreOf<TabBar>) {
        self.store = store
        self.viewStore = ViewStore(store)
        super.init(nibName: nil, bundle: nil)
        layout.finalActive()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.tintColor = .blueGray700
        tabBar.barTintColor = .blueGray700
        tabBar.unselectedItemTintColor = .blueGray700
        setupViewControllers()
        bindState()
    }
    
    private func bindState() {
        viewStore.publisher
            .currentTab
            .map(\.selectedIndex)
            .sink { [weak self] index in
                self?.selectedIndex = index
            }
            .store(in: &cancellables)
    }
    
    private func setupViewControllers() {
        let tabs: [UIViewController] = TabBar.Tab.allCases.map { tab in 
            switch tab {
            case .home:
                let store: StoreOf<Home> = store.scope(state: \.home, action: TabBar.Action.home)
                let viewController: HomeViewController = .init(store: store) 
                let navigationController: UINavigationController = .init(navigationBarClass: TogetherNavigationBar.self, toolbarClass: nil)
                navigationController.viewControllers = [viewController]
                navigationController.isNavigationBarHidden = true
                navigationController.tabBarItem = tab.tabBarItem
                return navigationController

            case .agora:
                let store: StoreOf<Agora> = store.scope(state: \.agora, action: TabBar.Action.agora)
                let viewController: AgoraViewController = .init(store: store)
                let navigationController: UINavigationController = .init(navigationBarClass: TogetherNavigationBar.self, toolbarClass: nil)
                navigationController.viewControllers = [viewController]
                navigationController.isNavigationBarHidden = true
                navigationController.tabBarItem = tab.tabBarItem
                return navigationController

            case .today:
                let store: StoreOf<Today> = store.scope(state: \.today, action: TabBar.Action.today)
                let viewController: TodayViewController = .init(store: store)
                let navigationController: UINavigationController = .init(navigationBarClass: TogetherNavigationBar.self, toolbarClass: nil)
                navigationController.viewControllers = [viewController]
                navigationController.isNavigationBarHidden = true
                navigationController.tabBarItem = tab.tabBarItem
                return navigationController
                
            case .mypage:
                let store: StoreOf<MyPage> = store.scope(state: \.mypage, action: TabBar.Action.mypage)
                let viewController: MyPageViewController = .init(store: store)
                let navigationController: UINavigationController = .init(navigationBarClass: TogetherNavigationBar.self, toolbarClass: nil)
                navigationController.viewControllers = [viewController]
                navigationController.isNavigationBarHidden = true
                navigationController.tabBarItem = tab.tabBarItem
                return navigationController
            } 
        }
        
        self.setViewControllers(tabs, animated: false)
    }
    
    public override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let title = item.title, let tab = TabBar.Tab(rawValue: title) else { return }
        viewStore.send(.selectTab(tab))
    }
}

extension TabBar.Tab {
    var tabBarItem: UITabBarItem {
        switch self {
        case .home: return .init(
            title: nil,
            image: UIImage(named: "ic_gnb_main_nor"),
            selectedImage: UIImage(named: "ic_gnb_main_sel")
        )
        case .agora: return .init(
            title: nil,
            image: UIImage(named: "ic_gnb_best_nor"),
            selectedImage: UIImage(named: "ic_gnb_best_sel")
        )
        case .today: return .init(
            title: nil,
            image: UIImage(named: "ic_gnb_today_nor"),
            selectedImage: UIImage(named: "ic_gnb_today_nor") // TODO: Image Change (nor > sel)
        )
        case .mypage: return .init(
            title: nil,
            image: UIImage(systemName: "person")?.withRenderingMode(.alwaysTemplate).withTintColor(.blueGray700),
            selectedImage: UIImage(systemName: "person.fill")?.withRenderingMode(.alwaysTemplate).withTintColor(.blueGray700)
        )    
        }
    }
    
    var selectedIndex: Int {
        switch self {
        case .home: return 0
        case .agora: return 1
        case .today: return 2
        case .mypage: return 3
        }
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        let store: StoreOf<TabBar> = .init(initialState: .init(home: .init(), agora: .init(), today: .init(), mypage: .init()), reducer: TabBar())
        return TabBarController(store: store)
            .showPrieview()
    }
}
#endif

