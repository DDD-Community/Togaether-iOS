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

public struct TabBarView: UIViewControllerRepresentable {
    public typealias UIViewControllerType = TabBarController
    
    private let store: StoreOf<TabBar>
    
    public init(store: StoreOf<TabBar>) {
        self.store = store
    }
    
    public func makeUIViewController(context: Self.Context) -> TabBarController {
        return .init(store: store)
    }
    
    public func updateUIViewController(_ uiViewController: TabBarController, context: Context) {
        
    }
}
