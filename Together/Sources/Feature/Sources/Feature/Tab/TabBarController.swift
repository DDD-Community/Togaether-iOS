//
//  File.swift
//  
//
//  Created by 한상진 on 2022/12/30.
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
    
    @LayoutBuilder var layout: some Layout {
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
                let navigationController: UINavigationController = .init(rootViewController: viewController)
                navigationController.tabBarItem = tab.tabBarItem
                return navigationController
                
            case .setting:
                let store: StoreOf<Setting> = store.scope(state: \.setting, action: TabBar.Action.setting)
                let viewController: SettingViewController = .init(store: store) 
                let navigationController: UINavigationController = .init(rootViewController: viewController)
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
            title: "홈",
            image: UIImage(systemName: "house"), 
            selectedImage: UIImage(systemName: "house.fill")
        )
        case .setting: return .init(
            title: "설정",
            image: UIImage(systemName: "person"), 
            selectedImage: UIImage(systemName: "person.fill")
        )    
        }
    }
    
    var selectedIndex: Int {
        switch self {
        case .home: return 0
        case .setting: return 1
        }
    }
}
