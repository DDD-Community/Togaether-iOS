//
//  File.swift
//  
//
//  Created by 한상진 on 2023/01/12.
//

import UIKit

import TogetherCore
import TogetherUI
import ThirdParty

import SwiftLayout
import ComposableArchitecture

final class OnboardingFeedRegisterViewController: UIViewController {
    
    private let store: StoreOf<OnboardingFeedRegister>
    private let viewStore: ViewStoreOf<OnboardingFeedRegister>
    
    private let feedRegisterView: FeedRegisterView
    private let skipButton: TogetherRegularButton = {
        let button: TogetherRegularButton = .init(
            title: "건너뛰기", 
            titleColor: .blueGray900,
            backgroundColor: .backgroundWhite,
            disabledBackgroundColor: .backgroundWhite,
            borderColor: .blueGray300,
            borderWidth: 1
        )
        return button
    }()
    private let nextButton: TogetherRegularButton = .init(title: "다음")
    private let buttonContainerStackView: UIStackView = {
        let stackView: UIStackView = .init()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 7
        return stackView
    }()
    
    @LayoutBuilder var layout: some SwiftLayout.Layout {
        view
            .config { view in
                view.backgroundColor = .backgroundWhite
                navigationItem.setLeftBarButtonItem7(.backButtonItem(target: self, action: #selector(onClickBackButton)))
                navigationItem.title = "3/3"
            }
            .sublayout {
            buttonContainerStackView
                .config { stackView in
                    stackView.addArrangedSubview(skipButton)
                    stackView.addArrangedSubview(nextButton)
                }
                .anchors { 
                    Anchors.horizontal(offset: 24)
                    Anchors.bottom.equalTo(view.safeAreaLayoutGuide.bottomAnchor, constant: 8)
                    Anchors.height.equalTo(constant: 52)
                }
            
            feedRegisterView
                .anchors { 
                    Anchors.top.equalTo(view.safeAreaLayoutGuide.topAnchor)
                    Anchors.horizontal()
                    Anchors.bottom.equalTo(buttonContainerStackView.topAnchor)
                }
        }
    }
    
    init(store: StoreOf<OnboardingFeedRegister>) {
        self.store = store
        self.viewStore = ViewStore(store)
        let feedRegisterStore: StoreOf<FeedRegister> = store.scope(
            state: \.feedRegister, 
            action: OnboardingFeedRegister.Action.feedRegister
        )
        self.feedRegisterView = .init(store: feedRegisterStore)
        super.init(nibName: nil, bundle: nil)
        layout.finalActive()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @objc
    private func onClickBackButton(_ sender: UIBarButtonItem) {
        viewStore.send(.detachChild)
        navigationController?.popViewController(animated: true)
    }
}

