//
//  File.swift
//  
//
//  Created by 한상진 on 2023/01/15.
//

import PhotosUI
import TogetherCore
import ComposableArchitecture

public struct OnboardingFeedRegister: ReducerProtocol {
    public struct State: Equatable {
        var feedRegister: FeedRegister.State 
        var navigationTitle: String
        var configuration: PHPickerConfiguration?
    }
    
    public enum Action: Equatable {
        case feedRegister(FeedRegister.Action)
        case pickerDismissed
        case detachChild
        case didTapSkipButton
        case didTapNextButton
    }
    
    public init() { }
    
    public var body: some ReducerProtocolOf<Self> {
        Reduce(core)
        
        Scope(state: \.feedRegister, action: /Action.feedRegister) { 
            FeedRegister()
        }
    }
    
    public func core(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .feedRegister(.didSelectPhoto):
            state.configuration = nil
            return .none
            
        case .feedRegister(.didTapPhotoImageView):
            var configuration = PHPickerConfiguration()
            configuration.filter = .any(of: [.images])
            state.configuration = configuration
            return .none
            
        case .feedRegister:
            return .none
            
        case .pickerDismissed:
            state.configuration = nil
            return .none
            
        case .didTapSkipButton, .didTapNextButton, .detachChild:
            return .none
        }
    }
    
}
