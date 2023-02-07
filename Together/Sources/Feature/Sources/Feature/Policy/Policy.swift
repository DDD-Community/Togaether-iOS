//
//  File.swift
//  
//
//  Created by 한상진 on 2023/02/05.
//

import TogetherCore
import MarkdownView
import ComposableArchitecture

public struct Policy: ReducerProtocol {
    
    // MARK: State
    
    public enum State: Equatable {
        case terms
        case personalInfo
        
        var title: String {
            switch self {
            case .terms: return "이용 약관"
            case .personalInfo: return "개인 정보 수집 동의"
            }
        }
        
        var content: String {
            switch self {
            case .terms: return TextReader.loadContentIntoString(name: "Agreement")
            case .personalInfo: return TextReader.loadContentIntoString(name: "PersonalInfo")
            }
        }
    }
    
    // MARK: Action
    
    public enum Action: Equatable, Sendable {
        case backButtonTapped
    }
    
    // MARK: Init
    
    public init() { }
    
    // MARK: Body
    
    public var body: some ReducerProtocolOf<Self> {
        Reduce(core)
    }
    
    public func core(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .backButtonTapped:
            return .none
        }
    }
    
}
