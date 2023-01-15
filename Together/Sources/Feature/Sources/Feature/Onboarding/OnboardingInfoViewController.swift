//
//  File.swift
//  
//
//  Created by 한상진 on 2022/12/26.
//

import UIKit
import Combine

import TogetherCore
import TogetherUI
import ThirdParty

import SwiftLayout
import ComposableArchitecture

public final class OnboardingInfoViewController: UIViewController {
    
    private let store: StoreOf<Onboarding>
    private let viewStore: ViewStoreOf<Onboarding>
    private let canSkip: Bool
    private var cancellables: Set<AnyCancellable> = .init()
    
    private let contentStackView: UIStackView = {
        let stackView: UIStackView = .init()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label: UILabel = .init()
        label.font = .display1
        label.textColor = .blueGray900
        label.text = "반려동물의\n정보를 입력해주세요."
        label.numberOfLines = 2
        return label
    }()
    
    private let nameFieldView: TogetherInputFieldView = .init(
        title: "이름", 
        placeholder: "이름을 입력해주세요."
    )
    private let genderSelectionView: GenderSelectionView = .init()
    private let birthFieldView: TogetherInputFieldView = .init(
        title: "생년월일", 
        placeholder: "yyyy - mm - dd", 
        keyboardType: .numberPad
    )
    
    private lazy var skipButton: TogetherRegularButton = {
        let button: TogetherRegularButton = .init(
            title: "건너뛰기", 
            titleColor: .blueGray900,
            backgroundColor: .backgroundWhite,
            disabledBackgroundColor: .backgroundWhite,
            borderColor: .blueGray300,
            borderWidth: 1
        )
        button.isHidden = !self.canSkip
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
            .config{ view in
                view.backgroundColor = .backgroundWhite
            }
            .sublayout {
                titleLabel
                    .anchors { 
                        Anchors.top.equalTo(view.safeAreaLayoutGuide.topAnchor, constant: 32)
                        Anchors.leading.equalToSuper(constant: 24)
                    }
                
                contentStackView
                    .config { stackView in
                        stackView.addArrangedSubview(nameFieldView)
                        stackView.setCustomSpacing(20, after: nameFieldView)
                        
                        stackView.addArrangedSubview(genderSelectionView)
                        stackView.setCustomSpacing(20, after: genderSelectionView)
                        
                        stackView.addArrangedSubview(birthFieldView)
                        stackView.setCustomSpacing(20, after: birthFieldView)
                    }
                    .anchors { 
                        Anchors.top.equalTo(titleLabel.bottomAnchor, constant: 32)
                        Anchors.horizontal(offset: 24)
                    }
                
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
            }
    }
    
    public init(
        store: StoreOf<Onboarding>,
        canSkip: Bool
    ) {
        self.store = store
        self.viewStore = ViewStore(store)
        self.canSkip = canSkip
        super.init(nibName: nil, bundle: nil)
        layout.finalActive()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        bindAction()
        bindState()
        bindNavigation()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !isMovingToParent {
            viewStore.send(.onboardingInfo(.detachChild))
        }
    }
    
    private func bindAction() {
        nameFieldView.inputTextField
            .textPublisher
            .sink { [weak self] name in
                self?.viewStore.send(.onboardingInfo(.set(\.$name, name)))
            }
            .store(in: &cancellables)
        
        genderSelectionView.maleLabel
            .throttleTapGesture
            .sink { [weak self] _ in
                self?.viewStore.send(.onboardingInfo(.set(\.$gender, .male)))
            }
            .store(in: &cancellables)
        
        genderSelectionView.femaleLabel
            .throttleTapGesture
            .sink { [weak self] _ in
                self?.viewStore.send(.onboardingInfo(.set(\.$gender, .female)))
            }
            .store(in: &cancellables)
        
        birthFieldView.inputTextField
            .textPublisher
            .sink { [weak self] birth in
                self?.viewStore.send(.onboardingInfo(.set(\.$birth, birth)))
            }
            .store(in: &cancellables)
        
        skipButton.throttleTap
            .sink { [weak self] _ in
                self?.viewStore.send(.onboardingInfo(.didTapSkipButton))
            }
            .store(in: &cancellables)
        
        nextButton.throttleTap
            .sink { [weak self] _ in
                self?.viewStore.send(.onboardingInfo(.didTapNextButton))
            }
            .store(in: &cancellables)
    }
    
    private func bindState() {
        viewStore.publisher.onboardingInfo.gender
            .assign(to: \.selectedGender, onWeak: genderSelectionView)
            .store(in: &cancellables)
        
        viewStore.publisher.onboardingInfo.canMoveNext
            .assign(to: \.isEnabled, onWeak: nextButton)
            .store(in: &cancellables)
        
        viewStore.publisher.onboardingInfo.isBirthValid
            .assign(to: \.isValid, onWeak: birthFieldView)
            .store(in: &cancellables)
    }
    
    private func bindNavigation() {
        store
            .scope(state: \.onboardingSpecies)
            .ifLet { [weak self] species in
                guard let self = self else { return }
                self.navigationController?.pushViewController(
                    OnboardingSpeciesViewController(store: self.store, canSkip: true), 
                    animated: true
                )
            }
            .store(in: &cancellables)
        
        store
            .scope(state: \.tabBar, action: Onboarding.Action.tabBar)
            .ifLet { store in
                UIApplication.shared.appKeyWindow?.rootViewController = TabBarController(store: store)
            }
            .store(in: &cancellables)
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct OnboardingInfo_Previews: PreviewProvider {
    static var previews: some View {
        let store: StoreOf<Onboarding> = .init(initialState: .init(), reducer: Onboarding())
        return OnboardingInfoViewController(store: store, canSkip: true)
            .showPrieview()
    }
}
#endif


fileprivate final class GenderSelectionView: UIView {
    
    var selectedGender: OnboardingInfo.Gender? {
        willSet {
            switch newValue {
            case .male:
                maleLabel.textColor = .backgroundWhite
                maleLabel.backgroundColor = .primary500
                
                femaleLabel.textColor = .blueGray300
                femaleLabel.backgroundColor = .backgroundWhite
            case .female:
                femaleLabel.textColor = .backgroundWhite
                femaleLabel.backgroundColor = .primary500
                
                maleLabel.textColor = .blueGray300
                maleLabel.backgroundColor = .backgroundWhite
            case .none:
                maleLabel.textColor = .blueGray300
                maleLabel.backgroundColor = .backgroundWhite
                
                femaleLabel.textColor = .blueGray300
                femaleLabel.backgroundColor = .backgroundWhite
            }
        }
    }
    
    private let genderLabel: UILabel = {
        let label: UILabel = .init()
        label.font = .body1
        label.textColor = .blueGray500
        label.backgroundColor = .backgroundWhite
        label.textAlignment = .left
        label.text = "성별"
        return label
    }()
    
    let maleLabel: UILabel = {
        let label: UILabel = .init()
        label.font = .subhead3
        label.textColor = .blueGray300
        label.backgroundColor = .backgroundWhite
        label.textAlignment = .center
        label.text = "남자"
        label.isUserInteractionEnabled = true
        label.cornerRadius = 8
        label.clipsToBounds = true
        label.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        return label
    }()
    
    private let dividerView: UIView = {
        let view: UIView = .init()
        view.backgroundColor = .blueGray300
        return view
    }()
    
    let femaleLabel: UILabel = {
        let label: UILabel = .init()
        label.font = .subhead3
        label.textColor = .blueGray300
        label.textAlignment = .center
        label.text = "여자"
        label.isUserInteractionEnabled = true
        label.cornerRadius = 8
        label.clipsToBounds = true
        label.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner] 
        return label
    }()
    
    private let genderSelectorView: UIStackView = {
        let stackView: UIStackView = .init()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.borderWidth = 1
        stackView.borderColor = .borderPrimary
        stackView.cornerRadius = 8
        stackView.backgroundColor = .backgroundWhite
        return stackView
    }()
    
    @LayoutBuilder var layout: some SwiftLayout.Layout {
        dividerView.anchors { Anchors.width.equalTo(constant: 1) }
        
        genderSelectorView.config { stackView in
            stackView.addArrangedSubview(maleLabel)
            stackView.addArrangedSubview(dividerView)
            stackView.addArrangedSubview(femaleLabel)
        }
        
        self
            .sublayout { 
                genderLabel
                    .anchors { 
                        Anchors.top.equalToSuper()
                        Anchors.horizontal()
                    }
                
                genderSelectorView
                    .anchors { 
                        Anchors.horizontal()
                        Anchors.top.equalTo(genderLabel, attribute: .bottom, constant: 6)
                        Anchors.height.equalTo(constant: 48)
                        Anchors.bottom.equalToSuper()
                    }
            }
    }
    
    init() {
        super.init(frame: .zero)
        layout.finalActive()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
