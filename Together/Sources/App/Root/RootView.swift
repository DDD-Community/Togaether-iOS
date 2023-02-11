//
//  RootView.swift
//  Together
//
//  Created by 한상진 on 2023/02/11.
//  Copyright © 2023 Army. All rights reserved.
//

import SwiftUI
import Feature
import TogetherCore
import TogetherUI
import ComposableArchitecture

struct RootView: View {
    private let store: StoreOf<Root>
    
    init(store: StoreOf<Root>) {
        self.store = store
    }
    
    var body: some View {
        SwitchStore(store) {
            CaseLet(state: /Root.State.root, action: Root.Action.root) { store in
                Image("splash")
                    .resizable()
                    .ignoresSafeArea()
            }
            
            CaseLet(state: /Root.State.login, action: Root.Action.login) { store in
                LoginView(store: store)
                    .ignoresSafeArea()
            }
            
            CaseLet(state: /Root.State.onboarding, action: Root.Action.onboarding) { store in
                OnboardingView(store: store)
                    .ignoresSafeArea()
            }
            
            CaseLet(state: /Root.State.tab, action: Root.Action.tab) { store in
                TabBarView(store: store)
                    .ignoresSafeArea()
            }
        }
        .onAppear {
            ViewStore(store).send(.viewDidAppear)
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        let store: StoreOf<Root> = .init(
            initialState: .root, 
            reducer: Root()
        )
        RootView(store: store)
    }
}
