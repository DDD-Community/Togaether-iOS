//
//  File.swift
//  
//
//  Created by 한상진 on 2023/01/22.
//

import UIKit
import Combine

import TogetherCore
import TogetherUI
import ThirdParty

import SwiftLayout
import ComposableArchitecture

public final class OnboardingNavigationViewController: UINavigationController {
    
    private let store: StoreOf<Onboarding>
    private let viewStore: ViewStoreOf<Onboarding>
    private var cancellables: Set<AnyCancellable> = .init()
    
    public init(store: StoreOf<Onboarding>) {
        self.store = store
        self.viewStore = ViewStore(store)
        super.init(nibName: nil, bundle: nil)
        bindNavigation()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func bindNavigation() {
        let onboardingInfo = store.scope(
            state: \.onboardingInfo, 
            action: Onboarding.Action.onboardingInfo
        )
        let onboardingInfoViewController = OnboardingInfoViewController(store: onboardingInfo, canSkip: true)
        self.viewControllers = [onboardingInfoViewController]
        
        store
            .scope(state: \.onboardingSpecies, action: Onboarding.Action.onboardingSpecies)
            .ifLet { [weak self] species in
                let speciesViewController = OnboardingSpeciesViewController(store: species, canSkip: true)
                self?.pushViewController(speciesViewController, animated: true)
            }
            .store(in: &cancellables)
        
        store
            .scope(state: \.onboardingRegister, action: Onboarding.Action.onboardingRegister)
            .ifLet { [weak self] onboardingRegister in
                let viewController = OnboardingFeedRegisterViewController(store: onboardingRegister)
                self?.pushViewController(viewController, animated: true)
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

