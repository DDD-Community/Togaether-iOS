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
    }
    
    public struct State: Equatable {
        var settingPetInfo: PetInfo.State?
        var settingAgreement: Agreement.State?
        var settingPersonalInfo: PersonalInfo.State?

        public init(settingPetInfo: PetInfo.State? = nil,
                    settingAgreement: Agreement.State? = nil,
                    settingPersonalInfo: PersonalInfo.State? = nil) {
            self.settingPetInfo = settingPetInfo
            self.settingAgreement = settingAgreement
            self.settingPersonalInfo = settingPersonalInfo
        }

        let settingItems: [SettingItem] = [
            .petInfo, .agreement, .personalInfo, .version, .logout
        ]
    }
    
    public enum Action: Equatable {
        // MARK: 설정 내부 화면
        case settingPetInfo(PetInfo.Action)
        case settingAgreement(Agreement.Action)
        case settingPersonalInfo(PersonalInfo.Action)
        
        // MARK: 설정 화면 이벤트 처리
        case defaultAction
        case detachChild
        case didTapPetInfo
        case didTapAgreement
        case didTapPersonalInfo
        case didTapVersion
        case didTapLogout
    }
    
    public init() { }
    
    public var body: some ReducerProtocolOf<Self> {
        Reduce(core)
            .ifLet(\.settingPetInfo, action: /Action.settingPetInfo) {
                PetInfo()
            }
            .ifLet(\.settingAgreement, action: /Action.settingAgreement) {
                Agreement()
            }
            .ifLet(\.settingPersonalInfo, action: /Action.settingPersonalInfo) {
                PersonalInfo()
            }
    }

    public func core(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .settingPetInfo(.detachChild):
            state.settingPetInfo = nil
            return .none
        case .settingAgreement(.detachChild):
            state.settingAgreement = nil
            return .none
        case .settingPersonalInfo(.detachChild):
            state.settingPersonalInfo = nil
            return .none
        case .detachChild:
            return .none


        case .defaultAction:
            return .none
        case .didTapPetInfo:
            state.settingPetInfo = .init()
            return .none
        case .didTapAgreement:
            state.settingAgreement = .init()
            return .none
        case .didTapPersonalInfo:
            state.settingPersonalInfo = .init()
            return .none
        case .didTapVersion:
            print("Version")
            return .none
        case .didTapLogout:
            print("Logout")
            return .none
        }
    }
    
}
