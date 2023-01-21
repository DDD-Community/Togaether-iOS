//
//  RootViewController.swift
//  
//
//  Created by 한상진 on 2022/12/22.
//

import UIKit
import Combine

import Feature
import TogetherCore
import TogetherUI
import ThirdParty

import SwiftLayout
import ComposableArchitecture

final class RootViewController: UIViewController {
    
    private let store: StoreOf<Root>
    private let viewStore: ViewStoreOf<Root>
    private var cancellables: Set<AnyCancellable> = .init()
    
    private let launchScreenImageView: UIImageView = .init(image: .init(named: "splash"))
    
    @LayoutBuilder var layout: some Layout {
      view.sublayout {
          launchScreenImageView.anchors { 
              Anchors.allSides()
          }
      }
    }
    
    init(store: StoreOf<Root>) {
        self.store = store
        self.viewStore = ViewStore(store)
        super.init(nibName: nil, bundle: nil)
        layout.finalActive()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindState()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewStore.send(.viewDidAppear)
    }
    
    private func bindState() {
        store
            .scope(state: /Root.State.login, action: Root.Action.login)
            .ifLet { store in
                let loginViewController = LoginViewController(store: store)
                let navigationController = TogetherNavigation(rootViewController: loginViewController)
                UIApplication.shared.appKeyWindow?.rootViewController = navigationController 
            }
            .store(in: &cancellables)
        
        store
            .scope(state: /Root.State.onboarding, action: Root.Action.onboarding)
            .ifLet { store in
                let navigationController = OnboardingNavigationViewController(store: store) 
                UIApplication.shared.appKeyWindow?.rootViewController = navigationController 
            }
            .store(in: &cancellables)
        
        store
            .scope(state: /Root.State.tab, action: Root.Action.tab)
            .ifLet { store in
                UIApplication.shared.appKeyWindow?.rootViewController = TabBarController(store: store)
            }
            .store(in: &cancellables)
    }
}
