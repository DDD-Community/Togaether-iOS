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

public struct LoginView: UIViewControllerRepresentable {
    public typealias UIViewControllerType = LoginViewController
    
    private let store: StoreOf<Login>
    
    public init(store: StoreOf<Login>) {
        self.store = store
    }
    
    public func makeUIViewController(context: Self.Context) -> LoginViewController {
        return .init(store: store)
    }
    
    public func updateUIViewController(_ uiViewController: LoginViewController, context: Context) {
        
    }
}

//struct LoginView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginView()
//    }
//}
