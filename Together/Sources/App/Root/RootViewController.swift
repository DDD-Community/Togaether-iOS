//
//  RootViewController.swift
//  
//
//  Created by 한상진 on 2022/12/22.
//

import UIKit
import Combine

import Login
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
        viewStore.publisher.tokenResult
            .compactMap { $0 }
            .sink { tokenResult in
                switch tokenResult {
                case let .success(token):
                    print("auto login success token: \(token)")
                    if true {
                        // tab으로 이동
                    } else {
                        // onboarding으로 이동
                    }
                    
                case .failure:
                    let loginStore: StoreOf<Login> = .init(
                        initialState: Login.State.init(), 
                        reducer: Login()
                    )
                    let loginViewController: LoginViewController = .init(store: loginStore)
                    UIApplication.shared.appWindow?.rootViewController = loginViewController
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
