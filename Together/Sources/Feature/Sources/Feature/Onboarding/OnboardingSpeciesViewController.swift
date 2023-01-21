//
//  File.swift
//  
//
//  Created by 한상진 on 2023/01/12.
//

import UIKit
import Combine

import TogetherCore
import TogetherUI
import ThirdParty

import SwiftLayout
import ComposableArchitecture

public final class OnboardingSpeciesViewController: UIViewController {
    
    private let store: StoreOf<Onboarding>
    private let viewstore: ViewStoreOf<Onboarding>
    private let tempViewStore: ViewStoreOf<OnboardingSpecies>
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
        label.numberOfLines = 2
        return label
    }()
    
    private let searchTextField: UITextField = .init().then { 
        $0.attributedPlaceholder = .init(
            string: "검색어를 입력해주세요.", 
            attributes: [
                .foregroundColor: UIColor.blueGray300,
                .font: UIFont.body2 as Any
            ]
        )
    }
    private let searchButton: UIButton = .init().then {
        $0.setImage(.init(named: "ic_search"), for: .init())
    }
    private let searchDevider: UIView = .init().then {
        $0.backgroundColor = .borderPrimary
    }
    
    private let searchTableView: OnboardingSpeciesTableView = .init()
    private lazy var datasource: OnboardingSpeciesDataSource = .init(tableView: searchTableView) { tableView, indexPath, name in
        let cell = tableView.dequeueReusableCell(withIdentifier: OnboardingSpeciesCell.identifier, for: indexPath) as? OnboardingSpeciesCell
        cell?.configure(name: name)
        return cell
    }
    
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
        stackView.alignment = .center
        stackView.spacing = 7
        return stackView
    }()
    
    @LayoutBuilder var layout: some SwiftLayout.Layout {
        searchDevider.anchors { Anchors.height.equalTo(constant: 2) }
        
        view
            .config{ view in
                view.backgroundColor = .backgroundWhite
                navigationItem.setLeftBarButtonItem7(.backButtonItem(target: self, action: #selector(onClickBackButton)))
                navigationItem.title = "2/3"
            }
            .sublayout {
                titleLabel
                    .anchors { 
                        Anchors.top.equalTo(view.safeAreaLayoutGuide.topAnchor, constant: 32)
                        Anchors.leading.equalToSuper(constant: 24)
                    }
                
                contentStackView
                    .config { stackView in
                        let searchBarStackView: UIStackView = .init().then {
                            $0.axis = .horizontal
                            $0.alignment = .fill
                            $0.distribution = .fill
                        }
                        searchBarStackView.addArrangedSubview(searchTextField)
                        searchBarStackView.setCustomSpacing(16, after: searchTextField)
                        searchBarStackView.addArrangedSubview(searchButton)
                        stackView.addArrangedSubview(searchBarStackView)
                        stackView.setCustomSpacing(6, after: searchBarStackView)
                        stackView.addArrangedSubview(searchDevider)
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
                        Anchors.height.equalTo(constant: 72)
                    }
                
                searchTableView
                    .anchors { 
                        Anchors.top.equalTo(contentStackView.bottomAnchor, constant: 12)
                        Anchors.bottom.equalTo(buttonContainerStackView.topAnchor)
                        Anchors.horizontal()
                    }
            }
    }
    
    public init(
        store: StoreOf<Onboarding>,
        speciesStore: StoreOf<OnboardingSpecies>,
        canSkip: Bool
    ) {
        self.store = store
        self.viewstore = ViewStore(store)
        self.canSkip = canSkip
        self.tempViewStore = ViewStore(speciesStore)
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
            viewstore.send(.onboardingSpecies(.detachChild))
        }
    }
    
    private func bindAction() {
        tempViewStore.send(.viewDidLoad)
        
        nextButton
            .throttleTapGesture
            .sink { [weak self] _ in
                self?.viewstore.send(.onboardingSpecies(.didTapNextButton))
            }
            .store(in: &cancellables)
        
        skipButton
            .throttleTapGesture
            .sink { [weak self] _ in
                self?.viewstore.send(.onboardingSpecies(.didTapSkipButton))
            }
            .store(in: &cancellables)
    }
    
    private func bindState() {
        titleLabel.text = "\(viewstore.onboardingInfo.name)는\n어떤 종인가요?"
        
        tempViewStore.publisher.species
            .sink { [weak self] species in
                var snapshot = SpeciesSnapshot.init()
                species.forEach { section in
                    snapshot.appendSections([section.id])
                    snapshot.appendItems(section.names, toSection: section.id)
                }
                self?.datasource.apply(snapshot)
            }
            .store(in: &cancellables)
    }
    
    private func bindNavigation() {
        store
            .scope(state: \.onboardingRegister, action: Onboarding.Action.onboardingRegister)
            .ifLet { [weak self] onboardingRegister in
                guard let self = self else { return }
                let viewController = OnboardingFeedRegisterViewController(store: onboardingRegister)
                self.navigationController?.pushViewController(
                    viewController, 
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
    
    @objc
    private func onClickBackButton(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
        viewstore.send(.onboardingSpecies(.detachChild))
    }
}
