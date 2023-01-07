//
//  File.swift
//  
//
//  Created by 한상진 on 2023/01/01.
//

import Foundation

import ThirdParty

import ComposableArchitecture
import XCTestDynamicOverlay

public struct Validator {
    public var validateEmail: (String) -> Bool?
    public var validatePassword: (String) -> Bool?
}

public extension DependencyValues {
    var validator: Validator {
        get { self[Validator.self] }
        set { self[Validator.self] = newValue }
    }
}

extension Validator: DependencyKey {
    public static let liveValue: Validator = .init(
        validateEmail: { email in
            guard !email.isEmpty else { return nil }
            let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
            return emailPredicate.evaluate(with: email)
        }, 
        validatePassword: { password in
            guard !password.isEmpty else { return nil }
            let passwordRegex = "^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[!@#$%^&*()_+=-]).{8,50}" // 8자리 ~ 50자리 영어+숫자+특수문자
            let passwordPredicate = NSPredicate(format:"SELF MATCHES %@", passwordRegex)
            return passwordPredicate.evaluate(with: password)
        }
    )
    
    public static let testValue: Validator = .init(
        validateEmail: unimplemented("\(Self.self).validateEmail"), 
        validatePassword: unimplemented("\(Self.self).validatePassword")
    )
}
