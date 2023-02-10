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
        var alert: AlertState<Action>?
    }
    
    public enum Action: Equatable {
        case feedRegister(FeedRegister.Action)
        case pickerDismissed
        case detachChild
        case didTapSkipButton
        case didTapNextButton
        case petRegisterResponse(TaskResult<DefaultResponse>)
        case registerComplete
        case alertDismissed
    }
    
    @Dependency(\.petAPI) var petAPI
    
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
            
        case .didTapNextButton:
            return .task { 
                await .petRegisterResponse(
                    TaskResult {
                        return .init()
//                        return try await petAPI.register()
                    }
                )
            }
            
        case .petRegisterResponse(.success):
            state.alert = .init(
                title: { 
                    TextState("등록 완료")
                }, 
                actions: {
                    ButtonState(action: .registerComplete) {
                        TextState("확인")
                    }
                }
            )
            return .none
            
        case .petRegisterResponse(.failure):
            state.alert = .init(
                title: { 
                    TextState("등록 실패")
                }, 
                actions: {
                    ButtonState(action: .alertDismissed) {
                        TextState("확인")
                    }
                }
            )
            return .none
            
        case .alertDismissed:
            state.alert = nil
            return .none
            
        case .didTapSkipButton, .detachChild, .registerComplete:
            return .none
        }
    }
    
}
