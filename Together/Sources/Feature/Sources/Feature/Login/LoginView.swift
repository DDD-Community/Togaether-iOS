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
import TogetherUI

public struct LoginView: UIViewControllerRepresentable {
    public typealias UIViewControllerType = TogetherNavigation
    
    private let store: StoreOf<Login>
    
    public init(store: StoreOf<Login>) {
        self.store = store
    }
    
    public func makeUIViewController(context: Self.Context) -> TogetherNavigation {
        let loginViewController = LoginViewController(store: store)
        let navigationController = TogetherNavigation(rootViewController: loginViewController)
        return navigationController
    }
    
    public func updateUIViewController(_ uiViewController: TogetherNavigation, context: Context) {
        
    }
}

//struct LoginView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginView()
//    }
//}
