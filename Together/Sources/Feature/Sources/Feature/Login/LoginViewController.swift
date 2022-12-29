//
//  File.swift
//  
//
//  Created by 한상진 on 2022/11/26.
//

import UIKit
import Combine

import TogetherCore
import TogetherUI
import ThirdParty

import SwiftLayout
import ComposableArchitecture

public final class LoginViewController: UIViewController {
    
    private let store: StoreOf<Login>
    private let viewStore: ViewStoreOf<Login>
    private var cancellables: Set<AnyCancellable> = .init()
    
    private let loginButton: UIButton = {
        let button: UIButton = .init(frame: .zero)
        button.setTitle("로그인", for: .init())
        button.setTitleColor(.black, for: .init())
        return button
    }()
    
    @LayoutBuilder var layout: some Layout {
      view.sublayout {
          loginButton.anchors { 
              Anchors.centerX.centerY.equalToSuper()
              Anchors.width.height.equalTo(constant: 100)
          }
      }
        view.config { view in
            view.backgroundColor = .white
        }
    }
    
    public init(store: StoreOf<Login>) {
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
        configureUI()
        bindState()
    }
    
    private func configureUI() {
        loginButton.addTarget(self, action: #selector(loginButtonDidTapped), for: .touchUpInside)
    }
    
    private func bindState() {
        store
            .scope(state: \.optionalOnboarding, action: Login.Action.optionalOnboarding)
            .ifLet(
                then: { store in
                    UIApplication.shared.keyWindow?.rootViewController = OnboardingViewController(store: store)
                }
            )
            .store(in: &cancellables)
        
        store
            .scope(state: \.optionalTab, action: Login.Action.optionalTab)
            .ifLet(
                then: { store in
                    UIApplication.shared.keyWindow?.rootViewController = TabViewController(store: store)
                }
            )
            .store(in: &cancellables)
    }
    
    @objc
    private func loginButtonDidTapped() {
        viewStore.send(.loginButtonDidTapped)
    }
}

public extension UIApplication {
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

