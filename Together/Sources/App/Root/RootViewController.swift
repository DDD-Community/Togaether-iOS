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
    
    private let launchScreenImageView: UIImageView = .init()
    
    @LayoutBuilder var layout: some Layout {
      view.sublayout {
          launchScreenImageView.anchors { 
              Anchors.allSides()
          }
          launchScreenImageView.config { view in
              view.backgroundColor = .yellow
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
            .scope(state: \.optionalLogin, action: Root.Action.optionalLogin)
            .ifLet(
                then: { store in
                    UIApplication.shared.appWindow?.rootViewController = LoginViewController(store: store)
                }
            )
            .store(in: &cancellables)
        
        store
            .scope(state: \.optionalOnboarding, action: Root.Action.optionalOnboarding)
            .ifLet(
                then: { store in
                    UIApplication.shared.appWindow?.rootViewController = OnboardingViewController(store: store)
                }
            )
            .store(in: &cancellables)
        
        store
            .scope(state: \.optionalTab, action: Root.Action.optionalTab)
            .ifLet(
                then: { store in
                    UIApplication.shared.appWindow?.rootViewController = TabBarController(store: store)
                }
            )
            .store(in: &cancellables)
    }
}

public extension UIApplication {
    var appWindow: UIWindow? {
        return (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window
    }
    
    var keyWindow: UIWindow? {
        return UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .map { $0 as? UIWindowScene }
            .compactMap { $0 }
            .first?.windows
            .filter(\.isKeyWindow)
            .first
    }
}



//        viewStore.publisher.destination
//            .compactMap { $0 }
//            .sink { [weak self] destination in
//                guard let self = self else { return }
//                
//                switch destination {
//                case .home:
//                    let tabController = TabController()
//                    UIApplication.shared.appWindow?.rootViewController = tabController
//                
//                case .login:
//                    let loginViewController = IfLetStoreController(
//                        store: self.store.scope(
//                            state: \.optionalLogin, 
//                            action: Root.Action.optionalLogin
//                        )
//                    ) {
//                        LoginViewController(store: $0)
//                    } else: {
//                        .init()
//                    }
//                    
//                    UIApplication.shared.appWindow?.rootViewController = loginViewController
//                    
//                case .onboarding:
//                    let onboardingViewController = IfLetStoreController(
//                        store: self.store.scope(
//                            state: \.optionalOnboarding, 
//                            action: Root.Action.optionalOnboarding
//                        )
//                    ) {
//                        OnboardingViewController(store: $0)
//                    } else: {
//                        .init()
//                    }
//                    
//                    UIApplication.shared.appWindow?.rootViewController = onboardingViewController
//                }
//            }
//            .store(in: &cancellables)
