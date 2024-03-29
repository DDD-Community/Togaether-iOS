//
//  File.swift
//  
//
//  Created by 한상진 on 2022/12/30.
//

import TogetherCore
import ComposableArchitecture

public struct Setting: ReducerProtocol {
    public enum SettingItem: String, CaseIterable {
        case petInfo = "강아지 정보 설정"
        case agreement = "이용약관"
        case personalInfo = "개인정보 처리방침"
        case version = "버전 정보"
        case logout = "로그아웃"
        case withdraw = "탈퇴하기"
    }
    
    public struct State: Equatable {
        var onboarding: Onboarding.State?
        var settingAgreement: Policy.State?
        var settingPersonalInfo: Policy.State?
        var alert: AlertState<Action>? = nil
        var isLoggedOut: Bool = false

        let settingItems: [SettingItem] = [
            .petInfo, .agreement, .personalInfo, .version, .logout, .withdraw
        ]
    }
    
    public enum Action: Equatable {
        // MARK: 설정 내부 화면
        case onboarding(Onboarding.Action)
        case settingAgreement(Policy.Action)
        case settingPersonalInfo(Policy.Action)
        
        // MARK: 설정 화면 이벤트 처리
        case defaultAction
        case detachChild
        case didTapPetInfo
        case didTapAgreement
        case didTapPersonalInfo
        case didTapVersion
        case didTapLogout
        case didTapWithdraw
        
        case logoutConfirmed
        case withdrawConfirmed
        case logoutResponse(TaskResult<String>)
        case routeToRoot
        case alertDismissed
    }
    
    @Dependency(\.togetherAccount) var togetherAccount
    
    public init() { }
    
    public var body: some ReducerProtocolOf<Self> {
        Reduce(core)
            .ifLet(\.onboarding, action: /Action.onboarding) {
                Onboarding()
            }
            .ifLet(\.settingAgreement, action: /Action.settingAgreement) {
                Policy()
            }
            .ifLet(\.settingPersonalInfo, action: /Action.settingPersonalInfo) {
                Policy()
            }
    }

    public func core(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .onboarding(.delegate(.routeToTab)),
                .onboarding(.delegate(.onboardingDismissed)):
            state.onboarding = nil
            return .none
            
        case .onboarding:
            return .none
            
        case .settingAgreement(.backButtonTapped):
            state.settingAgreement = nil
            return .none
        case .settingPersonalInfo(.backButtonTapped):
            state.settingPersonalInfo = nil
            return .none
        case .detachChild:
            return .none


        case .defaultAction:
            return .none
            
        case .didTapPetInfo:
            state.onboarding = .init()
            return .none
            
        case .didTapAgreement:
            state.settingAgreement = .init(.terms)
            return .none
            
        case .didTapPersonalInfo:
            state.settingPersonalInfo = .init(.personalInfo)
            return .none
            
        case .didTapVersion:
            print("Version")
            return .none
            
        case .didTapLogout:
            state.alert = .init(
                title: { 
                    TextState("로그아웃 하시겠습니까?")
                }, 
                actions: { 
                    ButtonState(action: .alertDismissed) {
                        TextState("취소")
                    }
                    ButtonState(action: .logoutConfirmed) {
                        TextState("확인")
                    }
                }
            )
            return .none
            
        case .logoutConfirmed:
            state.alert = nil
            return .task {
                await .logoutResponse(TaskResult {
                    await togetherAccount.logout()
                    return "equatable 때문에 임시로"
                })
            }
            
        case .didTapWithdraw:
            state.alert = .init(
                title: { 
                    TextState("회원탈퇴 하시겠습니까?")
                }, 
                actions: { 
                    ButtonState(action: .alertDismissed) {
                        TextState("취소")
                    }
                    ButtonState(action: .withdrawConfirmed) {
                        TextState("확인")
                    }
                }
            )
            return .none
            
        case .withdrawConfirmed:
            state.alert = nil
            return .task {
                await .logoutResponse(TaskResult {
                    try? await togetherAccount.withdraw()
                    return "equatable 때문에 임시로"
                })
            }
            
        case .logoutResponse(.success):
            state.alert = .init(
                title: { 
                    TextState("로그아웃 완료")
                }, 
                actions: { 
                    ButtonState(action: .routeToRoot) {
                        TextState("확인")
                    }
                }
            )
            return .none
            
        case .logoutResponse(.failure):
            return .none
            
        case .routeToRoot:
            state.alert = nil
            state.isLoggedOut = true
            return .none
            
        case .alertDismissed:
            state.alert = nil
            return .none
        }
    }
    
}
