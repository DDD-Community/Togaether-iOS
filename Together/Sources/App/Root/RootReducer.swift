//
//  Root.swift
//  
//
//  Created by 한상진 on 2022/12/22.
//

import Foundation

import TogetherCore
import ThirdParty

import ComposableArchitecture

struct Root: ReducerProtocol {
    struct State: Equatable {
        
    }
    
    enum Action: Equatable {
        case viewDidLoad
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .viewDidLoad:
            print("havi viewDidLoad")
            return .none
        }
    }
}
