//
//  RootViewController.swift
//  
//
//  Created by 한상진 on 2022/12/22.
//

import UIKit
import Combine

import Login
import Tab
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
    
    /// reducer에서 분기처리 해서 error일 경우랑 token이 있는 경우 랑
    /// 따로 처리해야할 지 같이 처리해야할지 .... 
    private func bindState() {
        viewStore.publisher.destination
            .compactMap { $0 }
            .sink { destination in
                switch destination {
                case .home:
                    let tabController = TabController()
                    UIApplication.shared.appWindow?.rootViewController = tabController
                
                case .login:
                    let loginViewController = IfLetStoreController(
                        store: self.store.scope(state: \.optionalLogin, action: Root.Action.optionalLogin)
                    ) {
                        LoginViewController(store: $0)
                    } else: {
                        .init()
                    }
                    
                    UIApplication.shared.appWindow?.rootViewController = loginViewController
                    
                case .onboarding:
                    let store: StoreOf<Onboarding> = .init(initialState: .init(), reducer: Onboarding())
                    let onboardingViewController = OnboardingViewController(store: store)
                    UIApplication.shared.appWindow?.rootViewController = onboardingViewController
                }
            }
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

final class IfLetStoreController<State, Action>: UIViewController {
  let store: Store<State?, Action>
  let ifDestination: (Store<State, Action>) -> UIViewController
  let elseDestination: () -> UIViewController

  private var cancellables: Set<AnyCancellable> = []
  private var viewController = UIViewController() {
    willSet {
      self.viewController.willMove(toParent: nil)
      self.viewController.view.removeFromSuperview()
      self.viewController.removeFromParent()
      self.addChild(newValue)
      self.view.addSubview(newValue.view)
      newValue.didMove(toParent: self)
    }
  }

  init(
    store: Store<State?, Action>,
    then ifDestination: @escaping (Store<State, Action>) -> UIViewController,
    else elseDestination: @escaping () -> UIViewController
  ) {
    self.store = store
    self.ifDestination = ifDestination
    self.elseDestination = elseDestination
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    self.store.ifLet(
      then: { [weak self] store in
        guard let self = self else { return }
        self.viewController = self.ifDestination(store)
      },
      else: { [weak self] in
        guard let self = self else { return }
        self.viewController = self.elseDestination()
      }
    )
    .store(in: &self.cancellables)
  }
}
