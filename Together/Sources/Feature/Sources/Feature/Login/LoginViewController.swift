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
    private var alertController: UIAlertController?
    
    private let contentStackView: UIStackView = .init().config { stackView in
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
    }
    
    private let iconView: UIView = .init().config { view in
        view.backgroundColor = .backgroundGray
    }
    
    private let iconImageView: UIImageView = .init(image: .init(named: "img_login", in: .main, with: nil))
    
    private let emailFieldView: TogetherInputFieldView = .init(
        title: "이메일(아이디)", 
        placeholder: "예) example@togather.co.kr",
        keyboardType: .emailAddress
    )
    private let passwordFieldView: TogetherInputFieldView = .init(
        title: "비밀번호", 
        placeholder: "0자리 ~ 00자리의 영어, 숫자 혹은 특수문자"
    ).config { view in
        view.inputTextField.isSecureTextEntry = true
    }
    private let loginButton: TogetherRegularButton = .init(title: "로그인") 
    
    private let findContainerView: UIStackView = .init().config { stackView in
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
    }
    
    private let findIDButton: UIButton = {
        let button: UIButton = .init(frame: .zero)
        button.setTitle("아이디 찾기", for: .init())
        button.titleLabel?.font = .body1
        button.setTitleColor(.black, for: .init())
        return button
    }()
    
    private let dividerView: UIView = {
        let view: UIView = .init()
        view.backgroundColor = .hex("D9D9D9")
        return view
    }()
    
    private let findPasswordButton: UIButton = {
        let button: UIButton = .init(frame: .zero)
        button.setTitle("비밀번호 찾기", for: .init())
        button.titleLabel?.font = .body1
        button.setTitleColor(.black, for: .init())
        return button
    }()
    
    private let joinContainerView: UIStackView = {
        let stackView: UIStackView = .init()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        return stackView
    }()
    
    private let noAccountLabel: UILabel = {
        let label: UILabel = .init()
        label.text = "계정이 없으신가요?"
        label.font = .caption
        label.textColor = .blueGray900
        return label
    }()
    
    private let joinButton: UIButton = {
        let button: UIButton = .init()
        button.setTitle("가입하기", for: .init())
        button.setTitleColor(.primary500, for: .init())
        button.titleLabel?.font = .caption
        return button
    }()
    
    @LayoutBuilder var layout: some SwiftLayout.Layout {
        view.sublayout {
            contentStackView.anchors { 
                Anchors.horizontal(offset: 24)
                Anchors.top.equalTo(view.safeAreaLayoutGuide)
            }
            findContainerView.anchors {
                Anchors.height.equalTo(constant: 20)
                Anchors.top.equalTo(contentStackView.bottomAnchor, constant: 24)
                Anchors.centerX.equalTo(view.centerXAnchor)
            }
            joinContainerView.anchors { 
                Anchors.bottom.equalTo(view.safeAreaLayoutGuide.bottomAnchor, constant: -14)
                Anchors.centerX.equalTo(view.centerXAnchor)
            }
        }
        
        view.config { view in
            view.backgroundColor = .backgroundGray
        }
        
        iconView
            .sublayout { 
                iconImageView.anchors { 
                    Anchors.center()
                }
            }
            .anchors {
                Anchors.height.equalTo(constant: 186)
            }
        
        dividerView.anchors { 
            Anchors.width.equalTo(constant: 1)
            Anchors.height.equalTo(constant: 12)
        }
        
        contentStackView.config { stackView in
            stackView.addArrangedSubview(iconView)
            stackView.addArrangedSubview(emailFieldView)
            stackView.setCustomSpacing(20, after: emailFieldView)
            stackView.addArrangedSubview(passwordFieldView)
            stackView.setCustomSpacing(20, after: passwordFieldView)
            stackView.addArrangedSubview(loginButton)
        }
        
//        findContainerView.config { stackView in
//            stackView.addArrangedSubview(findIDButton)
//            stackView.setCustomSpacing(20, after: findIDButton)
//            stackView.addArrangedSubview(dividerView)
//            stackView.setCustomSpacing(20, after: dividerView)
//            stackView.addArrangedSubview(findPasswordButton)
//        }
        
        joinContainerView.config { stackView in
            stackView.addArrangedSubview(noAccountLabel)
            stackView.setCustomSpacing(3, after: noAccountLabel)
            stackView.addArrangedSubview(joinButton)
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
        bindState()
        bindAction()
        bindNavigation()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !isMovingToParent {
            viewStore.send(.detachChild)
        }
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    
    private func bindState() {
        viewStore.publisher.isEmailValid
            .assign(to: \.isValid, onWeak: emailFieldView)
            .store(in: &cancellables)
        
        viewStore.publisher.isPasswordValid
            .assign(to: \.isValid, onWeak: passwordFieldView)
            .store(in: &cancellables)
        
        viewStore.publisher.isLoginAvailable
            .assign(to: \.isEnabled, onWeak: loginButton)
            .store(in: &cancellables)
        
        viewStore.publisher.isLoginInflight
            .map { return !$0 }
            .assign(to: \.isEnabled, onWeak: loginButton)
            .store(in: &cancellables)
        
        viewStore.publisher.alert
            .delay(for: .seconds(0.3), scheduler: DispatchQueue.main)
            .sink { [weak self] alert in
                if let alert = alert {
                    let alertController = UIAlertController(state: alert) { action in
                        guard let action else { return }
                        self?.viewStore.send(action)
                    }
                    self?.present(alertController, animated: true, completion: nil)
                    self?.alertController = alertController
                } else {
                    self?.alertController?.dismiss(animated: true, completion: nil)
                    self?.alertController = nil
                }
            }
            .store(in: &cancellables)
        
    }
    
    private func bindAction() {
        emailFieldView.inputTextField
            .textPublisher
            .sink { [weak self] email in
                self?.viewStore.send(.didChangeEmail(email))
            }
            .store(in: &cancellables)
        
        passwordFieldView.inputTextField
            .textPublisher
            .sink { [weak self] password in
                self?.viewStore.send(.didChangePassword(password))
            }
            .store(in: &cancellables)
        
        loginButton
            .publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.viewStore.send(.didTapLoginButton)        
            }
            .store(in: &cancellables)
        
        findIDButton
            .publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.viewStore.send(.didTapFindIDButton)
            }
            .store(in: &cancellables)
        
        findPasswordButton
            .publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.viewStore.send(.didTapFindPasswordButton)
            }
            .store(in: &cancellables)
        
        joinButton
            .publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.viewStore.send(.didTapJoinButton)
            }
            .store(in: &cancellables)
        
        view
            .throttleTapGesture
            .sink { [weak self] _ in
                self?.emailFieldView.endEditing(true)
                self?.passwordFieldView.endEditing(true)
            }
            .store(in: &cancellables)
    }
    
    private func bindNavigation() {
        store
            .scope(state: \.optionalOnboarding, action: Login.Action.optionalOnboarding)
            .ifLet { store in
                let navigationController = OnboardingNavigationViewController(store: store) 
                UIApplication.shared.appKeyWindow?.rootViewController = navigationController
            }
            .store(in: &cancellables)
        
        store
            .scope(state: \.optionalTerms, action: Login.Action.optionalTerms)
            .ifLet(
                then: { [weak self] store in
                    self?.navigationController?.pushViewController(
                        TermsViewController(store: store), 
                        animated: true
                    )
                }, 
                else: { [weak self] in
                    self?.navigationController?.popToRootViewController(animated: true)
                }
            )
            .store(in: &cancellables)
        
        store
            .scope(state: \.optionalTab, action: Login.Action.optionalTab)
            .ifLet { store in
                UIApplication.shared.appKeyWindow?.rootViewController = TabBarController(store: store)
            }
            .store(in: &cancellables)
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        let store: StoreOf<Login> = .init(initialState: .init(), reducer: Login())
        return LoginViewController(store: store)
            .showPrieview()
    }
}
#endif
