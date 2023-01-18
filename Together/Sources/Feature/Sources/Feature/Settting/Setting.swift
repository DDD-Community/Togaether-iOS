//
//  File.swift
//  
//
//  Created by 한상진 on 2022/12/30.
//

import TogetherCore
import ComposableArchitecture

public struct Setting: ReducerProtocol {
    public enum SettingItem: String, CaseIterable, Sendable {
        case myInfo = "내 정보 설정"
        case petInfo = "강아지 정보 설정"
        case agreement = "이용약관"
        case personalInfo = "개인정보 처리방침"
        case version = "버전 정보"
        case logout = "로그아웃"
    }
    
    public struct State: Equatable, Sendable {
        public init() { }

        let settingItems: [SettingItem] = [
            .myInfo, .petInfo, .agreement, .personalInfo, .version, .logout
        ]
    }
    
    public enum Action: Equatable, Sendable {
        case didTapMyInfo
        case didTapPetInfo
        case didTapAgreement
        case didTapPersonalInfo
        case didTapVersion
        case didTapLogout
    }
    
    public init() { }
    
    public var body: some ReducerProtocolOf<Self> {
        Reduce(core)
    }

    public func core(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .didTapMyInfo:
            print("MyInfo")
            return .none
        case .didTapPetInfo:
            print("PetInfo")
            return .none
        case .didTapAgreement:
            print("Agreement")
            return .none
        case .didTapPersonalInfo:
            print("PersonalInfo")
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
