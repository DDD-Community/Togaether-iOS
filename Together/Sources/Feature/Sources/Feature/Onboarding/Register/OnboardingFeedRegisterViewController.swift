//
//  File.swift
//  
//
//  Created by 한상진 on 2023/01/12.
//

import UIKit
import PhotosUI
import Combine

import TogetherCore
import TogetherUI
import ThirdParty

import SwiftLayout
import ComposableArchitecture

final class OnboardingFeedRegisterViewController: UIViewController {
    
    private let store: StoreOf<OnboardingFeedRegister>
    private let viewStore: ViewStoreOf<OnboardingFeedRegister>
    private var cancellables: Set<AnyCancellable> = .init()
    private let canSkip: Bool
    private var alertController: UIAlertController?
    
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
                view.keyboardLayoutGuide.followsUndockedKeyboard = true
                view.backgroundColor = .backgroundWhite
            }
            .sublayout {
                buttonContainerStackView
                    .config { stackView in
                        if canSkip { stackView.addArrangedSubview(skipButton) }
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
    
    init(
        store: StoreOf<OnboardingFeedRegister>,
        canSkip: Bool
    ) {
        let feedRegisterStore: StoreOf<FeedRegister> = store.scope(
            state: \.feedRegister, 
            action: OnboardingFeedRegister.Action.feedRegister
        )
        self.feedRegisterView = .init(store: feedRegisterStore)
        
        self.store = store
        self.viewStore = ViewStore(store)
        
        self.canSkip = canSkip
        
        super.init(nibName: nil, bundle: nil)
        layout.finalActive()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindAction()
        bindState()
    }
    
    private func setupUI() {
        navigationItem.setLeftBarButtonItem7(.backButtonItem(target: self, action: #selector(onClickBackButton)))
        navigationItem.title = viewStore.navigationTitle
    }
    
    private func bindAction() {
        skipButton.throttleTap
            .sink { [weak self] _ in
                self?.viewStore.send(.didTapSkipButton)
            }
            .store(in: &cancellables)
        
        nextButton.throttleTap
            .sink { [weak self] _ in
                self?.viewStore.send(.didTapNextButton)
            }
            .store(in: &cancellables)
    }
    
    private func bindState() {
        viewStore.publisher.configuration
            .compactMap { $0 }
            .sink { [weak self] configuration in
                guard let self = self else { return }
                let picker = PHPickerViewController(configuration: configuration)
                picker.presentationController?.delegate = self
                picker.delegate = self
                DispatchQueue.main.async {
                    self.present(picker, animated: true)
                }
            }
            .store(in: &cancellables)
        
        
        viewStore.publisher.feedRegister.canMoveNext
            .assign(to: \.isEnabled, onWeak: nextButton)
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
    
    @objc
    private func onClickBackButton(_ sender: UIBarButtonItem) {
        viewStore.send(.detachChild)
        navigationController?.popViewController(animated: true)
    }
}

extension OnboardingFeedRegisterViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        return true
    }
    
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        viewStore.send(.pickerDismissed)
    }
}

extension OnboardingFeedRegisterViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        let itemProvider = results.first?.itemProvider
        
        if let itemProvider = itemProvider,
           itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                DispatchQueue.main.async { [weak self] in
                    self?.viewStore.send(.feedRegister(.didSelectPhoto(image as? UIImage)))
                }
            }
        } else {
            viewStore.send(.pickerDismissed)
        }
    }
}
