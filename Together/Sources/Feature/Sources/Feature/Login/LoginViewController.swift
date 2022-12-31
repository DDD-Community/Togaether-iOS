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
    
    private let contentStackView: UIStackView = {
        let stackView: UIStackView = .init()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        return stackView
    }()
    
    private let iconView: UIView = {
        let view: UIView = .init()
        view.backgroundColor = .backgroundIvory100
        return view
    }()
    
    private let iconImageView: UIImageView = {
        let imageView: UIImageView = .init(image: .init(named: "투개더 아이콘"))
        imageView.backgroundColor = .cyan
        return imageView
    }()
    
    private let emailFieldView: TogetherInputFieldView = .init(
        title: "이메일(아이디)", 
        placeholder: "예) example@togather.co.kr"
    ) 
    private let passwordFieldView: TogetherInputFieldView = .init(
        title: "비밀번호", 
        placeholder: "0자리 ~ 00자리의 영어, 숫자 혹은 특수문자"
    ) 
    private let loginButton: TogetherRegularButton = .init(title: "로그인") 
    
    private let findContainerView: UIStackView = {
        let stackView: UIStackView = .init()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        return stackView
    }()
    
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
    
    @LayoutBuilder var layout: some SwiftLayout.Layout {
        view.sublayout {
            contentStackView.anchors { 
                Anchors.horizontal(offset: 24)
                Anchors.top.equalTo(view.safeAreaLayoutGuide)
            }
            findContainerView.anchors {
                Anchors.height.equalTo(constant: 20)
                Anchors.top.equalTo(contentStackView.bottomAnchor, constant: 26)
                Anchors.centerX.equalTo(view.centerXAnchor)
            }
        }
        
        view.config { view in
            view.backgroundColor = .backgroundIvory100
        }
        
        iconView
            .sublayout { 
                iconImageView.anchors { 
                    Anchors.center()
                    Anchors.size(width: 66.78, height: 48.76)
                }
            }.anchors {
                Anchors.height.equalTo(constant: 140)
            }
        
        loginButton.anchors { 
            Anchors.height.equalTo(constant: 54)
        }
        
        dividerView.anchors { 
            Anchors.width.equalTo(constant: 1)
            Anchors.height.equalTo(constant: 12)
        }
        
        contentStackView.config { stackView in
            stackView.addArrangedSubview(iconView)
            stackView.addArrangedSubview(emailFieldView)
            stackView.setCustomSpacing(24, after: emailFieldView)
            stackView.addArrangedSubview(passwordFieldView)
            stackView.setCustomSpacing(24, after: passwordFieldView)
            stackView.addArrangedSubview(loginButton)
        }
        
        findContainerView.config { stackView in
                stackView.addArrangedSubview(findIDButton)
                stackView.setCustomSpacing(20, after: findIDButton)
                stackView.addArrangedSubview(dividerView)
                stackView.setCustomSpacing(20, after: dividerView)
                stackView.addArrangedSubview(findPasswordButton)
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
    }
    
    private func bindState() {
        store
            .scope(state: \.optionalOnboarding, action: Login.Action.optionalOnboarding)
            .ifLet(
                then: { store in
                    UIApplication.shared.appKeyWindow?.rootViewController = OnboardingViewController(store: store)
                }
            )
            .store(in: &cancellables)
        
        store
            .scope(state: \.optionalTab, action: Login.Action.optionalTab)
            .ifLet(
                then: { store in
                    UIApplication.shared.appKeyWindow?.rootViewController = TabViewController(store: store)
                }
            )
            .store(in: &cancellables)
    }
    
    private func bindAction() {
        emailFieldView.inputTextField
            .textPublisher
            .sink { [weak self] email in
                self?.viewStore.send(.emailDidChanged(email))
            }
            .store(in: &cancellables)
        
        passwordFieldView.inputTextField
            .textPublisher
            .sink { [weak self] password in
                self?.viewStore.send(.passwordDidChanged(password))
            }
            .store(in: &cancellables)
        
        loginButton
            .publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.viewStore.send(.loginButtonDidTapped)        
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
