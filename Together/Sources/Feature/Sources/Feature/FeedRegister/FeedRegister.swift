//
//  File.swift
//  
//
//  Created by 한상진 on 2023/01/12.
//

import UIKit
import TogetherCore
import TogetherFoundation
import ComposableArchitecture

public struct FeedRegister: ReducerProtocol {
    public struct State: Equatable {
        @BindableState var text: String = ""
        var selectedImage: UIImage?
        
        var canMoveNext: Bool { return text.isNotEmpty && selectedImage.isNotNil }
    }
    
    public enum Action: Equatable, BindableAction {
        case binding(BindingAction<State>)
        case didTapPhotoImageView
        case didSelectPhoto(UIImage?)
    }
    
    public init() { }
    
    public var body: some ReducerProtocolOf<Self> {
        BindingReducer()
        Reduce(core)
    }
    
    public func core(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .binding(\.$text):
            return .none
        case .binding:
            return .none
            
        case .didTapPhotoImageView:
            return .none
            
        case let .didSelectPhoto(image):
            state.selectedImage = image
            return .none
        }
    }
    
}
