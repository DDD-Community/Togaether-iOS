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
    
    private let scrollView: UIScrollView = .init()
    
    private let contentStackView: UIStackView = {
        let stackView: UIStackView = .init()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        return stackView
    }()
    
    private let emailFieldView: TogetherInputFieldView = .init(title: "이메일(아이디)", placeholder: "예) example@togather.co.kr") 
    private let passwordFieldView: TogetherInputFieldView = .init(title: "비밀번호", placeholder: "0자리 ~ 00자리의 영어, 숫자 혹은 특수문자")
    private let passwordConfirmFieldView: TogetherInputFieldView = .init(title: "비밀번호 확인", placeholder: "비밀번호를 한 번 더 입력해주세요.") 
    private let nameFieldView: TogetherInputFieldView = .init(title: "이름", placeholder: "00자 이내로 입력해주세요.") 
    private let birthFieldView: TogetherInputFieldView = .init(title: "생년월일", placeholder: "yyyy - mm - dd") 
    private let phoneNumberFieldView: TogetherInputFieldView = .init(title: "휴대폰 번호", placeholder: "예) 01012345678")
    
    private let confirmButton: TogetherRegularButton = .init(title: "회원가입 완료")
    
    
    @LayoutBuilder var layout: some SwiftLayout.Layout {
        confirmButton
            .anchors { 
                Anchors.height.equalTo(constant: 54)
            }
        
        view
            .config { view in
                view.backgroundColor = .backgroundWhite
            }
            .sublayout {
                contentStackView
                    .config { stackView in
                        stackView.addArrangedSubview(emailFieldView)
                        stackView.setCustomSpacing(24, after: emailFieldView)
                        stackView.addArrangedSubview(passwordFieldView)
                        stackView.setCustomSpacing(24, after: passwordFieldView)
                        stackView.addArrangedSubview(passwordConfirmFieldView)
                        stackView.setCustomSpacing(24, after: passwordConfirmFieldView)
                        stackView.addArrangedSubview(nameFieldView)
                        stackView.setCustomSpacing(24, after: nameFieldView)
                        stackView.addArrangedSubview(birthFieldView)
                        stackView.setCustomSpacing(24, after: birthFieldView)
                        stackView.addArrangedSubview(phoneNumberFieldView)
                        stackView.setCustomSpacing(24, after: phoneNumberFieldView)
                        
                        stackView.addArrangedSubview(confirmButton)
                    }
                    .anchors { 
                        Anchors.horizontal(offset: 24)
                        Anchors.top.equalTo(view.safeAreaLayoutGuide)
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
        bindState()
        bindAction()
    }
    
    private func bindState() {
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
        
        phoneNumberFieldView.inputTextField
            .textPublisher
            .sink { [weak self] phoneNumber in
                self?.viewStore.send(.didChangePhoneNumber(phoneNumber))
            }
            .store(in: &cancellables)
        
        confirmButton
            .publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.viewStore.send(.confirmButtonClicked)
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
