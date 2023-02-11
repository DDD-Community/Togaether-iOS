//
//  SwiftUIView.swift
//  
//
//  Created by 한상진 on 2023/02/11.
//

import SwiftUI
import TogetherCore
import ThirdParty
import ComposableArchitecture

public struct OnboardingView: UIViewControllerRepresentable {
    public typealias UIViewControllerType = OnboardingNavigationViewController
    
    private let store: StoreOf<Onboarding>
    
    public init(store: StoreOf<Onboarding>) {
        self.store = store
    }
    
    public func makeUIViewController(context: Self.Context) -> OnboardingNavigationViewController {
        return .init(store: store)
    }
    
    public func updateUIViewController(_ uiViewController: OnboardingNavigationViewController, context: Context) {
        
    }
}
