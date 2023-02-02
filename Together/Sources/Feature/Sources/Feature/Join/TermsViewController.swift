//
//  File.swift
//  
//
//  Created by 한상진 on 2023/01/08.
//

import UIKit
import Combine

import TogetherCore
import TogetherUI
import ThirdParty

import SwiftLayout
import ComposableArchitecture

final class TermsViewController: UIViewController {
    
    private let store: StoreOf<Terms>
    private let viewStore: ViewStoreOf<Terms>
    private var cancellables: Set<AnyCancellable> = .init()
    
    private let titleContainerView: UIView = .init()
    
    private let titleLabel: UILabel = {
        let label: UILabel = .init()
        label.font = .display1
        label.textColor = .blueGray900
        label.text = "서비스 이용약관에\n동의해주세요."
        label.numberOfLines = 2
        return label
    }()
    
    private let allAgreeToggleView: TermsToggleView = .init(title: "네, 모두 동의합니다.", hasButton: false)
    private let overFourteenToggleView: TermsToggleView = .init(title: "(필수) 만 14세 이상입니다.", hasButton: false)
    private let termsAndConditionToggleView: TermsToggleView = .init(title: "(필수) 서비스 이용약관에 동의", hasButton: true)
    private let personalInformationToggleView: TermsToggleView = .init(title: "(필수) 개인정보 수집 이용에 동의", hasButton: true)
    
    private let nextButton: TogetherRegularButton = .init(title: "다음 ") 
    
    @LayoutBuilder var layout: some SwiftLayout.Layout {
        view
            .config { view in
                view.backgroundColor = .backgroundWhite
            }
            .sublayout {
                titleContainerView
                    .config { view in
                        view.backgroundColor = .backgroundWhite
                    }
                    .anchors { 
                        Anchors.horizontal()
                        Anchors.top.equalTo(view.topAnchor)
                        Anchors.height.equalTo(constant: 280)
                    }
                    .sublayout { 
                        titleLabel
                            .anchors { 
                                Anchors.top.equalTo(view.safeAreaLayoutGuide.topAnchor, constant: 32)
                                Anchors.leading.equalToSuper(constant: 24)
                            }
                        allAgreeToggleView
                            .anchors { 
                                Anchors.top.equalTo(titleLabel.bottomAnchor, constant: 26)
                                Anchors.horizontal()
                                Anchors.height.equalTo(constant: 26)
                            }
                    }
                
                overFourteenToggleView
                    .anchors { 
                        Anchors.top.equalTo(titleContainerView.bottomAnchor, constant: 26)
                        Anchors.horizontal()
                        Anchors.height.equalTo(constant: 26)
                    }
                
                termsAndConditionToggleView
                    .anchors { 
                        Anchors.top.equalTo(overFourteenToggleView.bottomAnchor, constant: 18)
                        Anchors.horizontal()
                        Anchors.height.equalTo(constant: 26)
                    }
                
                personalInformationToggleView
                    .anchors { 
                        Anchors.top.equalTo(termsAndConditionToggleView.bottomAnchor, constant: 18)
                        Anchors.horizontal()
                        Anchors.height.equalTo(constant: 26)
                    }
                
                nextButton
                    .anchors { 
                        Anchors.horizontal(offset: 24)
                        Anchors.bottom.equalTo(view.safeAreaLayoutGuide.bottomAnchor, constant: 8)
                    }
            }
    }
    
    init(store: StoreOf<Terms>) {
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
        bindAction()
        bindState()
        bindNavigation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !isMovingToParent {
            viewStore.send(.detachChild)
        }
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
    
    private func bindAction() {
        allAgreeToggleView
            .throttleTapGesture
            .sink { [weak self] _ in
                self?.viewStore.send(.didTapAllAgree)
            }
            .store(in: &cancellables)
        
        overFourteenToggleView
            .throttleTapGesture
            .sink { [weak self] _ in
                self?.viewStore.send(.didTapOverFourteen)
            }
            .store(in: &cancellables)
        
        termsAndConditionToggleView
            .throttleTapGesture
            .sink { [weak self] _ in
                self?.viewStore.send(.didTapTermsAndCondition)
            }
            .store(in: &cancellables)
        
        personalInformationToggleView
            .throttleTapGesture
            .sink { [weak self] _ in
                self?.viewStore.send(.didTapPersionalInformation)
            }
            .store(in: &cancellables)
        
        nextButton
            .throttleTap
            .sink { [weak self] _ in
                self?.viewStore.send(.didTapNext)
            }
            .store(in: &cancellables)
    }
    
    private func bindState() {
        viewStore.publisher.allAgreed
            .assign(to: \.isEnabled, onWeak: allAgreeToggleView)
            .store(in: &cancellables)
        
        viewStore.publisher.allAgreed
            .assign(to: \.isEnabled, onWeak: nextButton)
            .store(in: &cancellables)
        
        viewStore.publisher.overFourteen
            .assign(to: \.isEnabled, onWeak: overFourteenToggleView)
            .store(in: &cancellables)
        
        viewStore.publisher.termsAndConditionAgreed
            .assign(to: \.isEnabled, onWeak: termsAndConditionToggleView)
            .store(in: &cancellables)
        
        viewStore.publisher.collectPersonalInformationAgreed
            .assign(to: \.isEnabled, onWeak: personalInformationToggleView)
            .store(in: &cancellables)
    }
    
    private func bindNavigation() {
        store
            .scope(state: \.optionalJoin, action: Terms.Action.optionalJoin)
            .ifLet { [weak self] store in
                let join = JoinViewController(store: store)
                self?.navigationController?.pushViewController(join, animated: true)
            }
            .store(in: &cancellables)
    }
}

fileprivate final class TermsToggleView: UIView {
    var isEnabled: Bool = false {
        willSet {
            if newValue {
                enabledImageView.image = enabledImage
            } else {
                enabledImageView.image = disabledImage
            }
        }
    }
    
    private let enabledImage: UIImage? = .init(named: "ic_check_enabled")
    private let disabledImage: UIImage? = .init(named: "ic_check_unselected")
    private let enabledImageView: UIImageView = .init()
    private let descriptionLabel: TogetherLabel = .init(text: nil, font: .body2, textColor: .blueGray900)
    let showButton: UIButton = {
        let button: UIButton = .init(type: .system)
        button.setTitle("보기", for: .init())
        button.setTitleColor(.blueGray400, for: .init())
        button.titleLabel?.font = .subhead2
        return button
    }()
    
    @LayoutBuilder var layout: some SwiftLayout.Layout {
        self
            .sublayout { 
                enabledImageView
                    .anchors { 
                        Anchors.leading.equalToSuper(constant: 24)
                        Anchors.centerY.equalToSuper()
                        Anchors.size(width: 24, height: 24)
                    }
                showButton
                    .anchors {
                        Anchors.trailing.equalToSuper(constant: -24)
                        Anchors.size(width: 25, height: 22)
                        Anchors.centerY.equalToSuper()
                    }
                descriptionLabel
                    .anchors { 
                        Anchors.leading.equalTo(enabledImageView.trailingAnchor, constant: 8)
                        Anchors.trailing.equalTo(showButton.leadingAnchor)
                        Anchors.centerY.equalToSuper()
                    }
            }
    }
    
    init(title: String, hasButton: Bool) {
        super.init(frame: .zero)
        showButton.isHidden = !hasButton
        descriptionLabel.text = title
        layout.finalActive()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct Terms_Previews: PreviewProvider {
    static var previews: some View {
        let store: StoreOf<Terms> = .init(initialState: .init(), reducer: Terms())
        return TermsViewController(store: store)
            .showPrieview()
    }
}
#endif

