//
//  File.swift
//  
//
//  Created by 한상진 on 2023/01/01.
//

import UIKit
import Combine

import TogetherCore
import TogetherUI
import ThirdParty

import SwiftLayout
import ComposableArchitecture

final class JoinViewController: UIViewController {
    
    private let store: StoreOf<Join>
    private let viewStore: ViewStoreOf<Join>
    private var cancellables: Set<AnyCancellable> = .init()
    
    private let scrollView: UIScrollView = {
        let scrollView: UIScrollView = .init()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let contentStackView: UIStackView = {
        let stackView: UIStackView = .init()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        return stackView
    }()
    
    private let emptyView: UIView = .init()
    private let titleLabel: UILabel = {
        let label: UILabel = .init()
        label.font = .display1
        label.textColor = .blueGray900
        label.text = "서비스 이용을 위해\n정보를 입력해주세요."
        label.numberOfLines = 2
        return label
    }()
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
    private let passwordConfirmFieldView: TogetherInputFieldView = .init(
        title: "비밀번호 확인", 
        placeholder: "비밀번호를 한 번 더 입력해주세요."
    ).config { view in
        view.inputTextField.isSecureTextEntry = true
    }
    private let nameFieldView: TogetherInputFieldView = .init(
        title: "이름", 
        placeholder: "00자 이내로 입력해주세요."
    ) 
    private let birthFieldView: TogetherInputFieldView = .init(
        title: "생년월일", 
        placeholder: "yyyy - mm - dd",
        keyboardType: .numberPad
    ) 
    
    private let confirmButton: TogetherRegularButton = .init(title: "완료")
    
    @LayoutBuilder var layout: some SwiftLayout.Layout {
        view
            .config { view in
                view.backgroundColor = .backgroundWhite
                view.keyboardLayoutGuide.followsUndockedKeyboard = true
            }
            .sublayout {
                scrollView
                    .anchors { 
                        Anchors.horizontal(offset: 24)
                        Anchors.top.equalTo(view.safeAreaLayoutGuide.topAnchor)
                        Anchors.bottom.equalTo(view.keyboardLayoutGuide.topAnchor, constant: -8)
                    }
            }
        
        emptyView
            .anchors { 
                Anchors.height.equalTo(constant: 32)
            }
        
        scrollView
            .sublayout {
                contentStackView
                    .config { stackView in
                        stackView.addArrangedSubview(emptyView)
                        stackView.addArrangedSubview(titleLabel)
                        stackView.setCustomSpacing(32, after: titleLabel)
                        stackView.addArrangedSubview(emailFieldView)
                        stackView.setCustomSpacing(20, after: emailFieldView)
                        stackView.addArrangedSubview(passwordFieldView)
                        stackView.setCustomSpacing(20, after: passwordFieldView)
                        stackView.addArrangedSubview(passwordConfirmFieldView)
                        stackView.setCustomSpacing(20, after: passwordConfirmFieldView)
                        stackView.addArrangedSubview(nameFieldView)
                        stackView.setCustomSpacing(20, after: nameFieldView)
                        stackView.addArrangedSubview(birthFieldView)
                        stackView.setCustomSpacing(20, after: birthFieldView)
                        
                        stackView.addArrangedSubview(confirmButton)
                    }
                    .anchors { 
                        Anchors.allSides(scrollView)
                        Anchors.width.equalTo(scrollView.widthAnchor)
                    }
            }
    }
    
    init(store: StoreOf<Join>) {
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
        configureNavigation()
        bindState()
        bindAction()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        if !self.isMovingToParent {
//          viewStore.send(.setNavigation(isActive: false))
//        }
    }
    
    private func configureNavigation() {
        if let navBar = navigationController?.navigationBar as? TogetherNavigationBar {
            navBar.setBackgroundImage(UIImage(color: .blueGray0), for: .default)
        }

        navigationItem.setLeftBarButtonItem7(.backButtonItem(target: self, action: #selector(onClickBackButton)))
    }
    
    @objc
    private func onClickBackButton(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
        viewStore.send(.detachChild)
    }
    
    private func bindState() {
        viewStore.publisher.isEmailValid
            .assign(to: \.isValid, onWeak: emailFieldView)
            .store(in: &cancellables)
        
        viewStore.publisher.isPasswordValid
            .assign(to: \.isValid, onWeak: passwordFieldView)
            .store(in: &cancellables)
        
        viewStore.publisher.isPasswordConfirmValid
            .assign(to: \.isValid, onWeak: passwordConfirmFieldView)
            .store(in: &cancellables)
        
        viewStore.publisher.isBirthValid
            .assign(to: \.isValid, onWeak: birthFieldView)
            .store(in: &cancellables)
        
        viewStore.publisher.isJoinAvailable
            .assign(to: \.isEnabled, onWeak: confirmButton)
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
        
        passwordConfirmFieldView.inputTextField
            .textPublisher
            .sink { [weak self] passwordConfirm in
                self?.viewStore.send(.didChangePasswordConfirm(passwordConfirm))
            }
            .store(in: &cancellables)
        
        nameFieldView.inputTextField
            .textPublisher
            .sink { [weak self] name in
                self?.viewStore.send(.didChangeName(name))
            }
            .store(in: &cancellables)
        
        birthFieldView.inputTextField
            .textPublisher
            .sink { [weak self] birth in
                self?.viewStore.send(.didChangeBirth(birth))
            }
            .store(in: &cancellables)
        
        confirmButton
            .publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.viewStore.send(.confirmButtonClicked)
            }
            .store(in: &cancellables)
        
        view
            .throttleTapGesture
            .sink { [weak self] _ in
                self?.emailFieldView.endEditing(true)
                self?.passwordFieldView.endEditing(true)
                self?.passwordConfirmFieldView.endEditing(true)
                self?.nameFieldView.endEditing(true)
                self?.birthFieldView.endEditing(true)
            }
            .store(in: &cancellables)
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct JoinPreviews: PreviewProvider {
    static var previews: some View {
        let store: StoreOf<Join> = .init(initialState: .init(), reducer: Join())
        return JoinViewController(store: store)
            .showPrieview()
    }
}
#endif
